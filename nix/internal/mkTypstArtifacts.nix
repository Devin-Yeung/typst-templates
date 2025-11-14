{
  typixLib,
  flake-utils,
}:
{
  name, # the name of the artifact
  typstSource, # the main Typst source file
  baseArgs,
  src, # the cleaned Typst sources
  typstPackages,
}:
let
  commonArgs = baseArgs // {
    # Specify the main Typst source file here
    inherit typstSource;
    typstOpts = {
      root = "."; # Set the root directory for Typst
    };
  };

  drvs = {
    # Compile a Typst project, *without* copying the result to the current directory
    "build-${name}-drv" = typixLib.buildTypstProject (
      commonArgs
      // {
        inherit src;
        unstable_typstPackages = typstPackages;
      }
    );

    # Compile a Typst project, and then copy the result to the current directory
    "build-${name}-script" = typixLib.buildTypstProjectLocal (
      commonArgs
      // {
        inherit src;
        unstable_typstPackages = typstPackages;
        typstOutput = "${name}.pdf";
      }
    );

    # Watch a project and recompile on changes
    "watch-${name}-script" = typixLib.watchTypstProject commonArgs;
  };

  apps = {
    "build-${name}" =
      flake-utils.lib.mkApp {
        drv = drvs."build-${name}-script";
      }
      // {
        meta = {
          description = "Build the ${name}";
        };
      };
    "watch-${name}" =
      flake-utils.lib.mkApp {
        drv = drvs."watch-${name}-script";
      }
      // {
        meta = {
          description = "Watch the ${name} for changes and recompile automatically";
        };
      };
  };
in
{
  inherit apps;
  checks = drvs;
}
