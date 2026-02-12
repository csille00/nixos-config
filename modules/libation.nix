{ config, pkgs, ... }:

{
  imports = [ ./docker.nix ];

  # Libation container - downloads Audible books to Audiobookshelf library
  virtualisation.oci-containers.containers.libation = {
    image = "rmcrackan/libation:latest";
    environment = {
      SLEEP_TIME = "30m";
    };
    volumes = [
      "/var/lib/libation/config:/config"
      "/var/lib/audiobookshelf/audiobooks:/data"
    ];
    extraOptions = [ "--user=1001:1001" ];
  };

  # Create directories with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/libation 0755 1001 1001 -"
    "d /var/lib/libation/config 0755 1001 1001 -"
    "d /var/lib/audiobookshelf/audiobooks 0755 1001 1001 -"
  ];
}
