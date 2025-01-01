{
  description = "momeemt's blog";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    brack-repo.url = "github:brack-lang/brack";
    ravenlog-repo.url = "github:brack-lang/ravenlog?dir=backend";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    brack-repo,
    ravenlog-repo,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        brack = brack-repo.packages.${system}.default;
        ravenlog = ravenlog-repo.packages.${system}.default;
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            alejandra
            brack
            ravenlog
          ];
        };
      }
    );
}
