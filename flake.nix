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

        src = typixLib.cleanTypstSource ./.;

        unstable_typstPackages = import ./nix/typstPackages.nix;
        mkTypstArtifacts = import ./nix/mkTypstArtifacts.nix;
        mkBaseArgs = import ./nix/mkBaseArgs.nix;

        baseArgs = mkBaseArgs { inherit pkgs; };

        mkDoc =
          { name, typstSource }:
          mkTypstArtifacts {
            inherit name typstSource;
            inherit typixLib flake-utils;
            inherit baseArgs src unstable_typstPackages;
          };
      in
      lib.fold lib.recursiveUpdate { } [
        (mkDoc {
          name = "example";
          typstSource = "main.typ";
        })
      ]
    );
}
