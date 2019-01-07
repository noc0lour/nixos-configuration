# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users.nix
      ./services.nix
      ./fonts.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "/dev/sda";
    };
  };

  networking = {
    hostName = "ginfizz";
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  # Home: "Europe/Amsterdam";
  # Virginia: "America/New_York";
  time.timeZone = "Europe/Berlin";

  nixpkgs = {
    config = {
      # Allow proprietary packages
      allowUnfree = true;
      allowBroken = false;
      # Create an alias for the unstable channel
      packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
          # pass the nixpkgs config to the unstable alias
          # to ensure `allowUnfree = true;` is propagated:
          config = config.nixpkgs.config;
        };
      };
    };
  };

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs;
    let
      core-packages = [
        acpi
        atool
        bc
        binutils
        busybox
        coreutils
        cryptsetup
        ctags
        curl
        direnv
        dpkg
        exa
        file
        findutils
        htop
        inotify-tools
        iputils
        psmisc
        rsync
        unrar
        unzip
        wget
        which
        xbindkeys
        xclip
        xsel
        zip
      ];
      crypt-packages = [
        git-crypt
        gnupg1
        kbfs
      ];
      development-packages = [
        autoconf
        automake
        clang-tools
        gcc
        gitFull
        gnumake
        watson-ruby
      ];
      nix-packages = [
        nix-prefetch-git
        nix-repl
        nixos-container
        nixpkgs-lint
        nox
        patchelf
      ];
      python-packages = [
        python3Full
        python3Packages.jedi
        python3Packages.yapf
      ];
      texlive-packages = [
        biber
        (texlive.combine {
           inherit (texlive)
           collection-basic
           collection-bibtexextra
           collection-binextra
           collection-fontsextra
           collection-fontsrecommended
           collection-fontutils
           collection-formatsextra
           #collection-genericextra
           #collection-genericrecommended
           collection-langenglish
           collection-langeuropean
           collection-langitalian
           collection-latex
           collection-latexextra
           collection-latexrecommended
           collection-luatex
           #collection-mathextra
           collection-metapost
           collection-pictures
           #collection-plainextra
           collection-pstricks
           collection-publishers
           #collection-science
           collection-xetex;
        })
      ];
      user-packages = [
        awesome
        emacs
        areca
        aspell
        aspellDicts.en
        aspellDicts.it
        aspellDicts.nb
        calibre
        chromium
        drive
        evince
        feh
        firefox
        ghostscript
        imagemagick
        libreoffice
        liferea
        meld
        pass
        pdftk
        phototonic
        rambox
        shutter
        spotify
        taskwarrior
        transmission
        transmission_gtk
        vlc
      ];
    in
      core-packages
      ++ crypt-packages
      ++ development-packages
      ++ nix-packages
      ++ python-packages
      ++ texlive-packages
      ++ user-packages;

    variables.EDITOR = "emacs";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    fish.enable = true;
    tmux.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.09";

}
