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
    ffmpeg prismlauncher
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
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      image = "${./dotfiles/sway/bg.jpg}";
      clock = true;
      fade-in = 0.5;

      indicator-radius = 120;
      indicator-thickness = 20;
      ring-color = "89b4fa";
      inside-color = "1e1e2e88";
      key-hl-color = "a6e3a1";
      text-color = "cdd6f4";
    };
  };
  home.activation.larpgymConfig =
  config.lib.dag.entryAfter [ "writeBoundary" ] ''
    config_dir="${config.xdg.configHome}/larpgym"

    run mkdir -p "$config_dir"
    run chmod 700 "$config_dir"

    if [ ! -e "$config_dir/client.toml" ] &&
       [ ! -L "$config_dir/client.toml" ]; then
      run install -m 600 ${
        pkgs.writeText "larpgym-client-template.toml" ''
          timezone = "America/Mazatlan"
          sync_interval_secs = 60
          token_file = "${config.xdg.configHome}/larpgym/client.token"

          # Descomenta y reemplaza con la URL raíz de tu backend.
          # server_url = "https://TU-SERVIDOR"
        ''
      } "$config_dir/client.toml"
    fi

    if [ ! -e "$config_dir/client.token" ] &&
       [ ! -L "$config_dir/client.token" ]; then
      run install -m 600 /dev/null "$config_dir/client.token"
    fi

    if [ -f "$config_dir/client.toml" ]; then
      run chmod 600 "$config_dir/client.toml"
    fi

    if [ -f "$config_dir/client.token" ]; then
      run chmod 600 "$config_dir/client.token"
    fi
  '';
  xdg.configFile."sway".source = ./dotfiles/sway;
  xdg.configFile."swappy".source = ./dotfiles/swappy;
  xdg.configFile."alacritty".source = ./dotfiles/alacritty;
  xdg.configFile."swaynag".source = ./dotfiles/swaynag;
  xdg.configFile."nvim".source = ./dotfiles/nvim;
  programs.home-manager.enable = true;
}
