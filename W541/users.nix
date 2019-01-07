{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.andrej = {
    description = "Andrej Rode";
    extraGroups = [
      "adm"
      "audio"
      "cdrom"
      "disk"
      "docker"
      "networkmanager"
      "root"
      "systemd-journal"
      "users"
      "video"
      "wheel"
    ];
    home = "/home/andrej";
    createHome = true;
    isNormalUser = true;
    uid = 1001;
    shell = "/run/current-system/sw/bin/zsh";
  };

  users.extraUsers.cel = {
    description = "CEL User";
    extraGroups = [
      "adm"
      "wheel"
    ]
    home = "/home/cel";
    createHome = true;
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/bash";
  }
}
