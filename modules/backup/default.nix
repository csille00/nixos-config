{ config, pkgs, lib, ... }:

{
  imports = [
    ./secrets.nix
    ./on-change-watcher.nix
    ./level-1-critical.nix
    ./level-2-sensitive.nix
    ./level-3-photos.nix
    ./level-4-recoverable.nix
  ];

  # Create backup data directories
  systemd.tmpfiles.rules = [
    "d /home/ellisserver/backup-data 0755 ellisserver users -"
    "d /home/ellisserver/backup-data/level-1-critical 0700 ellisserver users -"
    "d /home/ellisserver/backup-data/level-1-critical/passwords 0700 ellisserver users -"
    "d /home/ellisserver/backup-data/level-1-critical/tax-documents 0700 ellisserver users -"
    "d /home/ellisserver/backup-data/level-2-sensitive 0700 ellisserver users -"
    "d /home/ellisserver/backup-data/level-2-sensitive/journals 0700 ellisserver users -"
  ];

  # Initialize USB borg directories when drive is mounted
  systemd.services.usb-borg-init = {
    description = "Initialize USB borg directories";
    requires = [ "usb-drive-mount.service" ];
    after = [ "usb-drive-mount.service" ];
    wantedBy = [ "usb-drive-mount.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "init-usb-borg.sh" ''
        mkdir -p /mnt/usb/borg-backups/level-1
        mkdir -p /mnt/usb/borg-backups/level-2
      '';
    };
  };
}
