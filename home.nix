{ config, pkgs, ... }: {

  home.username = "angelpwg";
  home.homeDirectory = "/home/angelpwg";
  home.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
    alacritty zed-editor btop jdk21 gcc git wl-clipboard ffmpeg
    mpvpaper mako wofi waybar swappy sway findutils vesktop
    coreutils lxqt.lxqt-policykit udiskie grim slurp
    pulseaudio libnotify firefox-devedition 
    thunar zip unzip p7zip vesktop
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

  xdg.configFile."wofi/config".force = true;
  xdg.configFile."wofi/style.css".force = true;
  programs.wofi = {
    enable = true;
    settings = {
      xoffset = 710;
      yoffset = 275;
      show = "drun";
      width = 500;
      height = 500;
      always_parse_args = true;
      show_all = true;
      print_command = true;
      layer = "overlay";
      insensitive = true;
      prompt = "";
    };
    style = ''
      window {
        margin: 0px;
        border: 2px solid #414868;
        border-radius: 5px;
        background-color: #24283b;
        font-family: monospace;
        font-size: 12px;
      }
      #input { margin: 5px; border: 1px solid #24283b; color: #c0caf5; background-color: #24283b; }
      #input image { color: #c0caf5; }
      #inner-box { margin: 5px; border: none; background-color: #24283b; }
      #outer-box { margin: 5px; border: none; background-color: #24283b; }
      #scroll { margin: 0px; border: none; }
      #text { margin: 5px; border: none; color: #c0caf5; } 
      #entry:selected { background-color: #414868; font-weight: normal; }
      #text:selected { background-color: #414868; font-weight: normal; }
    '';
  };

  xdg.configFile."sway".source = ./dotfiles/sway;
  xdg.configFile."waybar".source = ./dotfiles/waybar;
  xdg.configFile."swappy".source = ./dotfiles/swappy;
  xdg.configFile."alacritty".source = ./dotfiles/alacritty;
  xdg.configFile."mako".source = ./dotfiles/mako;
  xdg.configFile."swaylock".source = ./dotfiles/swaylock;
  xdg.configFile."swaynag".source = ./dotfiles/swaynag;
  programs.home-manager.enable = true;

}
