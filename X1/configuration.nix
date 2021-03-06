# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
      <nixos-hardware/lenovo/thinkpad/x1>
      ./hardware-configuration.nix
      ./users.nix
      ./services.nix
      ./fonts.nix
      ./multi-glibc-locale-paths.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernel = {
      sysctl = {
        "kernel.perf_event_paranoid" = 0;
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "/dev/nvme0n1";
    };
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/nvme0n1p3";
        preLVM = true;
      }
    ];
  };

  networking = {
    hostName = "minazo";
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  # Home: "Europe/Amsterdam";
  #time.timeZone = "Europe/Amsterdam";
  # Virginia
  time.timeZone = "America/New_York";

  nixpkgs = {
    config = {
      # Allow proprietary packages
      allowUnfree = true;
      allowBroken = false;
      # Configure Firefox
      firefox = {
       enableGoogleTalkPlugin = true;
      };
      # Create an alias for the unstable channel
      packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
          # Pass the nixpkgs config to the unstable alias
          # to ensure `allowUnfree = true;` is propagated:
          config = config.nixpkgs.config;
        };
      };
    };
    overlays = [(self: super: {
      bat = super.unstable.bat;
      borgbackup = super.unstable.borgbackup;
      emacs = super.unstable.emacs;
      # FIXME See https://github.com/NixOS/nixpkgs/pull/48020
      exa = super.unstable.exa;
      firefox = super.unstable.firefox;
      kbfs = super.unstable.kbfs;
      keybase = super.unstable.keybase;
      keybase-gui = super.unstable.keybase-gui;
      kitty = super.unstable.kitty;
      #lua5_3 = super.unstable.lua5_3;
      #lua53Packages = super.unstable.lua53Packages;
      neovim = super.neovim.override {
        withPython = true;
        withPython3 = true;
        vimAlias = true;
      };
      nix-home = super.callPackage ./pkgs/nix-home {};
      openvpn = super.openvpn.override {
        pkcs11Support = true;
      };
      wavebox = super.unstable.wavebox;
    })];
  };

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs;
    let
      core-packages = [
        acpi
        ag
        atool
        bat
        bc
        binutils
        coreutils
        cryptsetup
        curl
        direnv
        dmidecode
        editorconfig-core-c
        emacs
        exa
        file
        findutils
        freerdp
        htop
        inotify-tools
        iputils
        kitty
        ncurses.dev
        neovim
        networkmanager
        nnn
        opensc
        openvpn
        pciutils
        pcsctools
        psmisc
        rsync
        tldr
        tree
        unrar
        unzip
        usbutils
        wget
        which
        xbindkeys
        xclip
        xdg_utils
        xsel
        zip
      ];
      crypt-packages = [
        git-crypt
        gnupg1
        kbfs
        keybase
        keybase-gui
      ];
      development-packages = [
        autoconf
        automake
        clang-tools
        ctags
        flameGraph
        gcc
        git-lfs
        gitAndTools.gitFull
        gitAndTools.hub
        global
        gnumake
        linuxPackages.perf
        perf-tools
        pijul
        rtags
        shellcheck
      ];
      haskell-packages = [
        ghc
        haskellPackages.apply-refact
        haskellPackages.hasktags
        haskellPackages.hindent
        haskellPackages.hlint
        haskellPackages.hoogle
        haskellPackages.stylish-haskell
        stack
      ];
      lua-packages = [
        lua
        luaPackages.lgi
        luaPackages.luacheck
      ];
      nix-packages = [
        nix-home
        nix-prefetch-git
        nixos-container
        nixpkgs-lint
        nox
        patchelf
      ];
      python-packages = [
        autoflake
        pipenv
        python3Full
        python3Packages.importmagic
        python3Packages.isort
        python3Packages.jedi
        python3Packages.pygments
        python3Packages.pytest
        python3Packages.yapf
      ];
      texlive-packages = [
        asymptote
        biber
        (texlive.combine {
           inherit (texlive)
           collection-basic
           collection-bibtexextra
           collection-binextra
           collection-context
           collection-fontsextra
           collection-fontsrecommended
           collection-fontutils
           collection-formatsextra
           collection-langenglish
           collection-langeuropean
           collection-langfrench
           collection-langitalian
           collection-langother
           collection-latex
           collection-latexextra
           collection-latexrecommended
           collection-luatex
           collection-mathscience
           collection-metapost
           collection-pictures
           collection-plaingeneric
           collection-pstricks
           collection-publishers
           collection-xetex;
        })
      ];
      user-packages = [
        aspell
        aspellDicts.en
        aspellDicts.it
        aspellDicts.nb
        borgbackup
        chromium
        evince
        feh
        firefox
        ghostscript
        gimp
        gv
        imagemagick
        inkscape
        libreoffice
        liferea
        meld
        pandoc
        pass
        pdf2svg
        pdftk
        pymol
        shutter
        spotify
        vlc
        wavebox
      ];
    in
      core-packages
      ++ crypt-packages
      ++ development-packages
      ++ haskell-packages
      ++ lua-packages
      ++ nix-packages
      ++ python-packages
      ++ texlive-packages
      ++ user-packages;

    gnome3.excludePackages = with pkgs.gnome3; [ epiphany evolution totem vino yelp accerciser ];
    variables.EDITOR = "emacs";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    fish.enable = true;
    #slock.enable = true;
    tmux.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
