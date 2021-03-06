{ config, pkgs, ... }:
{
  fonts = {
    fontconfig.enable = true;
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts           # Microsoft free fonts
      dejavu_fonts
      fira-code
      fira-code-symbols
      font-awesome-ttf
      gyre-fonts
      hack-font
      hasklig
      inconsolata         # monospaced
      latinmodern-math
      lato
      monoid
      source-code-pro
      terminus_font
      tex-gyre-bonum-math
      tex-gyre-pagella-math
      tex-gyre-schola-math
      tex-gyre-termes-math
      ubuntu_font_family  # Ubuntu fonts
      unifont             # some international languages
      xits-math
    ];
  };
}
