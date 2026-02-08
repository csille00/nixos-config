{ config, pkgs, ... }:

{
  # home.username and home.homeDirectory are set per-host in hosts/*/home.nix

  home.file = {
    ".config/ghostty/config".source = ../dotfiles/ghostty/config;
    ".config/nvim".source = ../dotfiles/nvim;
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ghostty
    vscode
    gh
    cascadia-code
    typescript-go

    # LazyVim dependencies
    fd
    lazygit
    lua-language-server
    stylua
  ];
  
  home.stateVersion = "25.05";
}
