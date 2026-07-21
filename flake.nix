{
  description = "VimDocs development";
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
        ];
        shellHook = ''
          echo "Vimdoc testing environment"
          echo "Test env: nvim -u init.lua ."
        '';
      };

      checks.${system}.default =
        pkgs.runCommand "Vimdoc-tests"
          {
            buildInputs = [
              pkgs.neovim
            ];
          }
          ''
            cd ${self}

            nvim --headless \
                -u tests/init.lua \
                -c "lua dofile('tests/run.lua')" \
                -c "qa"
            touch $out
          '';
    };
}
