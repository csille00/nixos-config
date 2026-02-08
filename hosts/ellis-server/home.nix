{ config, pkgs, lib, ... }:

{
  imports = [../../shared/home.nix];

  # User-specific settings for this host
  home.username = "ellisserver";
  home.homeDirectory = "/home/ellisserver";

  home.packages = lib.mkAfter (with pkgs; [
    claude-code
  ]);
}
