{ config, pkgs, ... }:
{
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
    };
    printing = {
      enable = true;
      drivers = [
        pkgs.hplip
      ];
    };
    emacs = {
      enable = true;
    };
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "de";
      xkbOptions = "eurosign:e";
      # Enable touchpad support.
      libinput.enable = true;
      # Display manager
      # Window manager
      #windowManager = {
      #  default = "awesome";
      #  awesome.enable = true;
      #};
      # Desktop manager
      desktopManager = {
        xterm.enable = false;
      };
    };
    nixosManual.showManual = true;
  };
}
