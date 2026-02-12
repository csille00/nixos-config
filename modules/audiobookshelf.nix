{ config, pkgs, ... }:

{
  # Audiobookshelf - self-hosted audiobook and podcast server
  services.audiobookshelf = {
    enable = true;
    host = "127.0.0.1";
    port = 8000;
  };

  # Expose Audiobookshelf through Tailscale
  systemd.services.tailscale-serve-audiobookshelf = {
    description = "Tailscale serve for Audiobookshelf";
    after = [ "network.target" "tailscaled.service" "audiobookshelf.service" ];
    wants = [ "tailscaled.service" "audiobookshelf.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=8000 http://127.0.0.1:8000";
      ExecStop = "${pkgs.tailscale}/bin/tailscale serve off";
    };
  };
}
