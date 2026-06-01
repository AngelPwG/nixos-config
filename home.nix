{ config, pkgs, ... }: {

  home.username = "angelpwg";
  home.homeDirectory = "/home/angelpwg";
  home.stateVersion = "26.05";
  
  home.packages = with pkgs; [
    alacritty zed-editor btop jdk21 gcc git wl-clipboard ffmpeg
    mpvpaper mako wofi waybar swappy sway findutils
    coreutils lxqt.lxqt-policykit udiskie
  ];

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
  xdg.configFile."wofi".source = ./dotfiles/wofi;
  xdg.configFile."waybar".source = ./dotfiles/waybar;
  xdg.configFile."swappy".source = ./dotfiles/swappy;
  xdg.configFile."alacritty".source = ./dotfiles/alacritty;
  xdg.configFile."mako".source = ./dotfiles/mako;
  xdg.configFile."swaylock".source = ./dotfiles/swaylock;
  xdg.configFile."swaynag".source = ./dotfiles/swaynag;
  
  programs.home-manager.enable = true;
}
