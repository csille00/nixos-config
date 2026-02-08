{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ellis-server";

  programs.nm-applet.enable = true;

  # Desktop environment
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;
  environment.lxqt.excludePackages = with pkgs.lxqt; [ qterminal ];

  users.users.ellisserver = {
    isNormalUser = true;
    description = "ellisserver";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Tailscale VPN
  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Do not change - tracks initial NixOS install version for stateful data compatibility
  system.stateVersion = "25.11";
}
