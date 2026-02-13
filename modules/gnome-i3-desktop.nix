{ config, pkgs, ... }:

{
  programs.nm-applet.enable = true;

  # Desktop environments
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager.i3.enable = true;

  # Remove default GNOME apps
  environment.gnome.excludePackages = with pkgs; [
    epiphany      # web browser
    geary         # email client
    evince        # document viewer
    totem         # video player
    gnome-music
    gnome-photos
    gnome-tour
    gnome-contacts
    gnome-calendar
    gnome-maps
    gnome-weather
    gnome-clocks
    gnome-connections
    gnome-console
    gnome-text-editor
    simple-scan
    yelp          # help viewer
    cheese        # webcam
  ];

  # i3 dependencies
  environment.systemPackages = with pkgs; [
    i3blocks
    i3lock
    rofi
    dex
    xss-lock
    feh
    pavucontrol
    gnome-tweaks
  ];

  # GNOME Keyring
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Fractional scaling
  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';
  };
}
