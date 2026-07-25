{
  description = "Vimdoc development";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.neovim
          pkgs.git
          pkgs.curl
          pkgs.tree-sitter
        ];
        shellHook = ''
          echo "Vimdoc testing environment"
          echo "Test env: nvim -u dev/init.lua ."
          vd() {
                if [ $# -eq 0 ]; then
                    nvim -u dev/init.lua
                else
                    nvim -u dev/init.lua "+Vimdoc $*"
                fi
          }
          alias cl='./dev/clean'
        '';
      };

      checks.${system}.default =
        pkgs.runCommand "Vimdoc-tests"
          {
            buildInputs = [
              pkgs.neovim
            ];
            src = self;
          }
          ''
            cd $src

            nvim --headless \
                -u dev/init.lua \
                -l tests/adapter/rst_spec.lua \
            touch $out
          '';
    };
}
