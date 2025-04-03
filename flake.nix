{
  description = "ZaneyOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix.url = "github:musnix/musnix";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs =
    { nixpkgs, home-manager, rust-overlay, musnix, zen-browser, ... }@inputs:
    let
      system = "x86_64-linux";
      host = "bubbles";
      username = "ada";
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
	          inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            musnix.nixosModules.musnix
            ./config/sound.nix
            ./hosts/${host}/config.nix
            inputs.stylix.nixosModules.stylix

            ({ pkgs, ... }: {
              nixpkgs.overlays = [ 
                rust-overlay.overlays.default 
                (final: prev: {
                  zen-browser = inputs.zen-browser.packages."${system}".default;
                })
              ];
              environment.systemPackages = with pkgs; [ 
                rust-bin.stable.latest.default 
                inputs.zen-browser.packages.${system}.default
              ];
            })

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./hosts/${host}/home.nix;
            }
          ];
        };
      };
    };
}
