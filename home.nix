{ config, pkgs, ... }: {

  home.username = "angelpwg";
  home.homeDirectory = "/home/angelpwg";
  home.stateVersion = "26.05";

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
    alacritty zed-editor btop jdk21 gcc git wl-clipboard ffmpeg
    mpvpaper swappy sway findutils vesktop
    coreutils lxqt.lxqt-policykit udiskie
    pulseaudio firefox-devedition 
    thunar zip unzip p7zip vesktop cava
    ffmpeg
  ];
  home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark-Cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  gtk.enable = true;

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 23.23;
    longitude = -106.41;
    temperature = {
      day = 6000;
      night = 3700;
    };
    settings = {
      general = {
        fade = 1;
      };
    };
  };

  xdg.configFile."sway".source = ./dotfiles/sway;
  xdg.configFile."swappy".source = ./dotfiles/swappy;
  xdg.configFile."alacritty".source = ./dotfiles/alacritty;
  xdg.configFile."swaylock".source = ./dotfiles/swaylock;
  xdg.configFile."swaynag".source = ./dotfiles/swaynag;
  programs.home-manager.enable = true;
}
