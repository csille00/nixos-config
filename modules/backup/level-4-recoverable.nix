{ config, pkgs, lib, ... }:

let
  backupPaths = [ "/var/lib/audiobookshelf" ];
  usbRepo = "/mnt/usb/borg-backups/level-4";
in
{
  services.borgbackup.jobs = {
    # USB only - weekly
    level-4-usb = {
      paths = backupPaths;
      repo = usbRepo;

      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.age.secrets.borg-passphrase.path}";
      };

      compression = "auto,zstd";

      # Weekly on Sunday at 4 AM
      startAt = "Sun 04:00";
      persistentTimer = true;

      preHook = ''
        if ! ${pkgs.util-linux}/bin/mountpoint -q /mnt/usb; then
          echo "USB drive not mounted, skipping backup"
          exit 0
        fi
      '';

      prune.keep = {
        weekly = 4;
        monthly = 3;
      };

      doInit = true;
    };
  };
}
