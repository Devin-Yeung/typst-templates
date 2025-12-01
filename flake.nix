{
  description = "A opinionated typst lecture notes template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{
      nixpkgs,
      typix,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;
        typixLib = typix.lib.${system};
        internal = import ./nix/internal {
          inherit pkgs flake-utils typixLib;
        };

        inherit (internal)
          baseArgs
          typstPackages
          mkTypstArtifacts
          mergeArtifacts
          ;

        src = lib.fileset.toSource {
          root = ./.;
          fileset = lib.fileset.unions [
            (lib.fileset.fromSource (typixLib.cleanTypstSource ./.))
            ./figures
          ];
        };

        mkDoc =
          { name, typstSource }:
          mkTypstArtifacts {
            inherit name typstSource;
            inherit baseArgs src typstPackages;
          };
      in
      let
        notes-example = mkDoc {
          name = "notes-example";
          typstSource = "examples/notes.typ";
        };
        cheatsheet-example = mkDoc {
          name = "cheatsheet-example";
          typstSource = "examples/cheatsheet.typ";
        };
      in
      mergeArtifacts [
        notes-example
        cheatsheet-example
      ]
    );
}
