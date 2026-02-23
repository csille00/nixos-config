{ config, pkgs, lib, ... }:

let
  backupPaths = [ "/var/lib/immich" ];
  borgbaseRepo = "ssh://gby8w41u@gby8w41u.repo.borgbase.com/./repo";
in
{
  services.borgbackup.jobs = {
    # BorgBase (offsite) - daily differential
    level-3-borgbase = {
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

      # Daily schedule at 3 AM
      startAt = "03:00";
      persistentTimer = true;

      doInit = false;

      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = 6;
      };

      # Exclude Immich cache/temp files
      exclude = [
        "/var/lib/immich/cache"
        "/var/lib/immich/*.log"
      ];
    };
  };

  # Note: USB rsync backup is already configured in configuration.nix
  # via systemd.services.immich-backup - no changes needed
}
