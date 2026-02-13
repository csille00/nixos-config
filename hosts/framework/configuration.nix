{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
    ../../modules/gnome-i3-desktop.nix
    ../../modules/redo-dev.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "connor-framework";

  services.ollama.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    steam-run
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries here
  ];

  services.envfs.enable = true;

  hardware.graphics.enable = true;

  users.users.connor-framework = {
    isNormalUser = true;
    description = "connor-framework";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192; # MB -> 8 GiB
    }
  ];

  security.lsm = lib.mkForce [ ];

  # Do not change - tracks initial NixOS install version for stateful data compatibility
  system.stateVersion = "25.11";
}
