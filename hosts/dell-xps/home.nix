{ config, pkgs, lib, ... }:

{
  imports = [../../shared/home.nix];

  home.file = {
    ".config/i3".source = ../../dotfiles/i3;
  };

  # User-specific settings for this host
  home.username = "connor-dell";
  home.homeDirectory = "/home/connor-dell";

  home.packages = lib.mkAfter (with pkgs; [
    claude-code
    slack
    spotify
    
    mongodb-compass
    dbeaver-bin

    docker
    lsof
    valkey # I don't think this does anything
    yarn

    firefox
    caddy
  ]);
}
