{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils, flake-compat, ... }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nim-unwrapped
            nimPackages.nimble
          ] ++ lib.optional stdenv.isDarwin (with pkgs.darwin; [
            Security
          ]);

          shellHook = ''
            export PATH=$PATH:$HOME/.nimble/bin
          '';
        };
      }
    );
}
