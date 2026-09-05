{
  description = "AngelPwG NixOS Config con JES";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
    
    jes.url = "github:AngelPwG/just_enough_shell"; 

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, jes, home-manager, ... }: {
    nixosConfigurations = {
      
      pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./pc.nix
	  ./hardware-pc.nix
          jes.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./laptop.nix
	  ./hardware-laptop.nix
          jes.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };

    };
  };
}
