{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    jq
    fd
    ripgrep
    uutils-findutils # xargs
    fzf
  ];

  # https://devenv.sh/languages/
  languages.typst.enable = true;

  enterShell = ''
    typst --version
    typstyle --version
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    typstyle --version | grep --color=auto "${pkgs.typstyle.version}"
    typst --version | grep --color=auto "${pkgs.typst.version}"
  '';

  scripts.list-apps.exec = ''
    nix flake show --json 2>/dev/null \
    | jq -r '.apps.["${pkgs.stdenv.hostPlatform.system}"] | keys | .[]'
  '';

  # build all documents
  scripts.build-all.exec = ''
    list-apps | rg build | xargs -I {} nix run .#{}
  '';

  # bd stands for "build document"
  scripts.bd.exec = ''
    list-apps | rg build | fzf --bind 'enter:become(nix run .#{})'
  '';

  # wd stands for "watch document"
  scripts.wd.exec = ''
    list-apps | rg watch | fzf --bind 'enter:become(nix run .#{})'
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    trim-trailing-whitespace = {
      enable = true;
    };

    nixfmt = {
      enable = true;
    };

    yamlfmt = {
      enable = true;
      settings = {
        lint-only = false;
      };
    };

    typstyle = {
      enable = true;
    };

  };

  # See full reference at https://devenv.sh/reference/options/
}
