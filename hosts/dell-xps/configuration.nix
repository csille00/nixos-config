{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
    ../../modules/gnome-i3-desktop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "connor-dell";

  users.users.connor-dell = {
    isNormalUser = true;
    description = "connor-dell";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Do not change - tracks initial NixOS install version for stateful data compatibility
  system.stateVersion = "25.11";
}
