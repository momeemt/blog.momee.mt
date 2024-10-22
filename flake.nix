{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    brack.url = "github:brack-lang/brack";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    flake-compat,
    brack,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        brack-bin = brack.packages.${system}.default;
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            alejandra
            brack-bin
          ];
        };
      }
    );
}
