{ config, pkgs, ... }:

let
  chinese-tb-drive-from-shopify = "06489CBC489CABC5";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
    ../../modules/immich.nix
    ../../modules/audiobookshelf.nix
    ../../modules/libation.nix
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

  # USB drive auto-mount
  services.udev.extraRules = ''
    ACTION=="add", ENV{ID_FS_UUID}=="${chinese-tb-drive-from-shopify}", RUN+="${pkgs.util-linux}/bin/mount -o uid=1000,gid=1000 /dev/%k /mnt/usb"
    ACTION=="remove", ENV{ID_FS_UUID}=="${chinese-tb-drive-from-shopify}", RUN+="${pkgs.util-linux}/bin/umount /mnt/usb"
  '';

  systemd.tmpfiles.rules = [
    "d /mnt/usb 0755 root root -"
  ];

  # Do not change - tracks initial NixOS install version for stateful data compatibility
  system.stateVersion = "25.11";
}
