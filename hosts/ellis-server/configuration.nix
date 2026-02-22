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
    ACTION=="add", ENV{ID_FS_UUID}=="${chinese-tb-drive-from-shopify}", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-drive-mount.service"
  '';

  systemd.services.usb-drive-mount = {
    description = "Mount USB drive";
    bindsTo = [ "dev-disk-by\\x2duuid-${chinese-tb-drive-from-shopify}.device" ];
    after = [ "dev-disk-by\\x2duuid-${chinese-tb-drive-from-shopify}.device" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/mount -t ntfs3 -o rw,uid=1000,gid=1000 /dev/disk/by-uuid/${chinese-tb-drive-from-shopify} /mnt/usb";
      ExecStop = "${pkgs.util-linux}/bin/umount /mnt/usb";
      RemainAfterExit = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/usb 0755 root root -"
  ];

  # Immich backup to USB drive (runs automatically when drive is plugged in)
  systemd.services.immich-backup = {
    description = "Backup Immich photos to USB drive";
    requires = [ "usb-drive-mount.service" ];
    after = [ "usb-drive-mount.service" ];
    wantedBy = [ "usb-drive-mount.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.rsync}/bin/rsync -av --progress --delete /var/lib/immich/ /mnt/usb/immich/";
    };
  };

  # Do not change - tracks initial NixOS install version for stateful data compatibility
  system.stateVersion = "25.11";
}
