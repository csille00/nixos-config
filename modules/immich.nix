{ config, pkgs, ... }:

{
  # Immich - self-hosted photo backup (Tailscale-only access)
  services.immich = {
    enable = true;
    host = "127.0.0.1";
  };

  # Expose Immich through Tailscale
  services.tailscale.permitCertUid = "immich";
  systemd.services.tailscale-serve-immich = {
    description = "Tailscale serve for Immich";
    after = [ "network.target" "tailscaled.service" "immich-server.service" ];
    wants = [ "tailscaled.service" "immich-server.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=443 http://127.0.0.1:2283";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
