# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./users.nix
      ./minazo.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda3";
      preLVM = true;
    }
  ]; 

  networking.hostName = "minazo"; # Define your hostname.
  networking.networkmanager.enable = true; 

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "it";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # core
    stdenv
    findutils
    coreutils
    gnumake
    psmisc
    iputils
    nettools
    netcat
    rsync
    htop
    iotop
    python
    file
    bc
    wget
    curl
    unrar
    tree
    unzip 
    fish
    neovim
    git

    # nix
    nix-repl
    nix-prefetch-git
    nixos-container
    patchelf
  ]
  ++ (import ./env.nix pkgs);

  programs.fish.enable = true;
  programs.tmux.enable = true;
  
  # editor is always nvim
  environment.variables.EDITOR = "nvim";
  
  virtualisation.docker.enable = false;
  
  nix = rec {
    # use nix sandboxing for greater determinism
    useSandbox = true;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
