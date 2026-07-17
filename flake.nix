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
          echo "VimDoc testing environment"
          echo "Running : nvim -u init.lua ."
          nvim -u init.lua
        '';
      };
    };
}
