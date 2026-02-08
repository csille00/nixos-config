{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "connor-dell";

  programs.nm-applet.enable = true;

  # Desktop environments
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager.i3.enable = true;

  # i3 dependencies
  environment.systemPackages = with pkgs; [
    i3blocks
    i3lock
    rofi
    dex
    xss-lock
    feh
    pavucontrol
  ];

  users.users.connor-dell = {
    isNormalUser = true;
    description = "connor-dell";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Do not change - tracks initial NixOS install version for stateful data compatibility
  system.stateVersion = "25.11";
}
