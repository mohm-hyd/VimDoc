{
  description = "Vimdoc development";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.lua
        p.rst
        p.markdown
        p.html
      ]);

      nvim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
        configure = {
          packages.myPlugins = {
            start = [
              treesitter
            ];
          };
        };
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          nvim
          pkgs.git
          pkgs.curl
        ];

        shellHook = ''
          echo "Vimdoc testing environment"
          echo "Test env: nvim -u tests/init.lua ."

          vd() {
            if [ $# -eq 0 ]; then
              nvim --clean -u tests/init.lua
            else
              nvim --clean -u tests/init.lua "+Vimdoc $*"
            fi
          }

          alias cl='./tests/clean'
        '';
      };

      checks.${system}.default =
        pkgs.runCommand "Vimdoc-tests"
          {
            buildInputs = [
              nvim
              pkgs.git
              pkgs.curl
            ];

            src = self;
          }
          ''
            set -eux

            cd $src
            export HOME=$(mktemp -d)

            echo "Nvim path:"
            ${nvim}/bin/nvim --version

            echo "Runtime paths:"
            ${nvim}/bin/nvim --headless \
              -u tests/nix_init.lua \
              +"lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))" \
              +q

            echo "Running tests..."

            ${nvim}/bin/nvim --headless \
              -u tests/nix_init.lua \
              -l tests/run.lua

            echo "Tests finished"

            touch $out          '';
    };
}
