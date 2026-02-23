{ config, pkgs, lib, ... }:
# ssh://kgea792b@kgea792b.repo.borgbase.com/./repo
let
  backupPaths = [ "/home/ellisserver/backup-data/level-1-critical" ];
  borgbaseRepo = "ssh://q7b12i95@q7b12i95.repo.borgbase.com/./repo";
  usbRepo = "/mnt/usb/borg-backups/level-1";
in
{
  services.borgbackup.jobs = {
    # BorgBase (offsite) - triggered by on-change watcher
    level-1-borgbase = {
      paths = backupPaths;
      repo = borgbaseRepo;

      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.age.secrets.borg-passphrase.path}";
      };

      environment = {
        BORG_RSH = "ssh -i ${config.age.secrets.borgbase-ssh-key.path}";
      };

      compression = "auto,zstd";

      # Disable timer - triggered by path watcher
      startAt = [ ];

      # Keep recent history for critical data
      prune.keep = {
        within = "1d";
        daily = 7;
        weekly = 4;
        monthly = 6;
      };

      # Don't auto-init - manual setup required for BorgBase
      doInit = false;
    };

    # USB drive backup
    level-1-usb = {
      paths = backupPaths;
      repo = usbRepo;

      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.age.secrets.borg-passphrase.path}";
      };

      compression = "auto,zstd";

      # Disable timer - triggered by path watcher
      startAt = [ ];

      # Only run if USB is mounted
      preHook = ''
        if ! ${pkgs.util-linux}/bin/mountpoint -q /mnt/usb; then
          echo "USB drive not mounted, skipping backup"
          exit 0
        fi
      '';

      prune.keep = {
        within = "1d";
        daily = 7;
        weekly = 4;
        monthly = 12;
      };

      doInit = true;
    };
  };
}
