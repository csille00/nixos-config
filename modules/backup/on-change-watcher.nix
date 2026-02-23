{ config, pkgs, lib, ... }:

let
  backupDataDir = "/home/ellisserver/backup-data";
  triggerDir = "/run/backup-triggers";
in
{
  # Create trigger directory and files
  systemd.tmpfiles.rules = [
    "d ${triggerDir} 0755 root root -"
    "f ${triggerDir}/level-1-trigger 0644 root root -"
    "f ${triggerDir}/level-2-trigger 0644 root root -"
  ];

  # Increase inotify watch limit for recursive monitoring
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 65536;
  };

  # inotifywait watcher service
  systemd.services.backup-change-watcher = {
    description = "Watch backup directories for changes";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];

    path = [ pkgs.inotify-tools pkgs.coreutils ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "10s";
      ExecStart = pkgs.writeShellScript "backup-watcher.sh" ''
        #!/usr/bin/env bash

        # Wait for directories to exist
        while [ ! -d "${backupDataDir}/level-1-critical" ] || [ ! -d "${backupDataDir}/level-2-sensitive" ]; do
          sleep 5
        done

        inotifywait -m -r \
          -e modify,create,delete,move \
          --format '%w%f %e' \
          "${backupDataDir}/level-1-critical" \
          "${backupDataDir}/level-2-sensitive" \
          2>/dev/null | while read -r path event; do

          # Determine which level was modified and touch trigger file
          if [[ "$path" == "${backupDataDir}/level-1-critical"* ]]; then
            touch "${triggerDir}/level-1-trigger"
          elif [[ "$path" == "${backupDataDir}/level-2-sensitive"* ]]; then
            touch "${triggerDir}/level-2-trigger"
          fi
        done
      '';
    };
  };

  # Path units to trigger backups (watch trigger files)
  systemd.paths.backup-level-1-trigger = {
    description = "Watch for Level 1 backup trigger";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathModified = "${triggerDir}/level-1-trigger";
      Unit = "backup-level-1-debounce.service";
    };
  };

  systemd.paths.backup-level-2-trigger = {
    description = "Watch for Level 2 backup trigger";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathModified = "${triggerDir}/level-2-trigger";
      Unit = "backup-level-2-debounce.service";
    };
  };

  # Debounce services - wait 30s for activity to settle before running backup
  systemd.services.backup-level-1-debounce = {
    description = "Debounce Level 1 backup trigger";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/sleep 30";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl start borgbackup-job-level-1-borgbase.service borgbackup-job-level-1-usb.service";
    };
  };

  systemd.services.backup-level-2-debounce = {
    description = "Debounce Level 2 backup trigger";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/sleep 30";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl start borgbackup-job-level-2-borgbase.service borgbackup-job-level-2-usb.service";
    };
  };
}
