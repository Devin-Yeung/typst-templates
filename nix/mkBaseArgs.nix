{ pkgs }:
{
  fontPaths = [
    # Add paths to fonts here
    "${pkgs.libertinus}/share/fonts/opentype"
    "${pkgs.iosevka}/share/fonts/truetype"
    "${pkgs.lxgw-wenkai}/share/fonts/truetype"
  ];

  virtualPaths = [
    # Add paths that must be locally accessible to typst here
    {
      dest = "fonts/libertinus";
      src = "${pkgs.libertinus}/share/fonts/opentype";
    }
    {
      dest = "fonts/iosevka";
      src = "${pkgs.iosevka}/share/fonts/truetype";
    }
    {
      dest = "fonts/lxgw-wenkai";
      src = "${pkgs.lxgw-wenkai}/share/fonts/truetype";
    }
  ];
}
