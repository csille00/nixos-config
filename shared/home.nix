{ config, pkgs, ... }:

{
  # home.username and home.homeDirectory are set per-host in hosts/*/home.nix

  home.file = {
    ".config/ghostty/config".source = ../dotfiles/ghostty/config;
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ghostty
    vscode
    gh
    cascadia-code
    typescript-go
  ];
  
  home.stateVersion = "25.05";
}
