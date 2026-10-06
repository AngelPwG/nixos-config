{ config, inputs, pkgs, ... }:
let
  sung = pkgs.symlinkJoin {
    name = "sung";

    paths = [
      inputs.sung.packages.${pkgs.system}.default
    ];

    nativeBuildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/sung \
        --set QT_QUICK_BACKEND software
    '';
  };
in
{
  imports = [
    inputs.silentSDDM.nixosModules.default
    ./jes-bar-fix.nix
  ];
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
   enable = true;
   enable32Bit = true;
  };
  home-manager.backupFileExtension = "backup";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.networkmanager.enable = true;
  time.timeZone = "America/Mazatlan";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
  };
  programs.silentSDDM = {
    enable = true;
    
    theme = "catppuccin-mocha"; 
    
    settings = {
      LoginScreen = {
        background = "${./dotfiles/sway/bg.jpg}";
      };
      LockScreen = {
        background = "${./dotfiles/sway/bg.jpg}";
      };
    };
  };

  services.flatpak.enable = true;
  services.tailscale.enable = true;

  services.xserver.xkb = {
    layout = "latam";
    variant = "nodeadkeys";
  };
  console.keyMap = "la-latin1";

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;

    wlr = {
      enable = true;

      settings = {
        screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
        };
      };
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    config.sway = {
      default = [ "gtk" ];

      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    };
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."angelpwg" = {
    isNormalUser = true;
    description = "AngelPwG";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.sway.enable = true;
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  }; 
  services.xserver.wacom.enable = true;
  security.polkit.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    neovim git wl-clipboard alacritty
    zellij gnumake cargo wget
    cisco-packet-tracer_9 gamescope
    sung
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  services.jes = {
    enable = true;
    users = [ "angelpwg" ];
  };

  system.stateVersion = "26.05";
  home-manager.users.angelpwg = import ./home.nix;
}
