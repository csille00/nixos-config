{ config, pkgs, lib, ... }:

{
  imports = [../../shared/home.nix];

  home.file = {
    ".config/i3".source = ../../dotfiles/i3;
  };

  # User-specific settings for this host
  home.username = "connor-framework";
  home.homeDirectory = "/home/connor-framework";

  home.packages = lib.mkAfter (with pkgs; [
    claude-code
    slack
    spotify
    
    mongodb-compass
    dbeaver-bin

    # bazel builds
    distrobox
    awscli2
    bazelisk
    docker
    lsof
    valkey # I don't think this does anything
    yarn
    ruby

    nssTools
    firefox
    caddy
  ]);
}
