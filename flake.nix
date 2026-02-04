{
	description="NixOS Setup";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
                stylix.url = "github:danth/stylix";
		dotfiles-nvim = {
  			url = "github:NikolasDmn/dotfiles-nvim";
  			flake = false;
		};


		home-manager = {

			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

                
	};
	outputs = {self, nixpkgs, home-manager, stylix, ...}@inputs: {
		nixosConfigurations.chonker = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = {inherit inputs;};
			modules = [
#				nvf.homeManagerModules.default
                                stylix.nixosModules.stylix
				./nixos/configuration.nix
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
                                        home-manager.backupFileExtension = "backup";
					home-manager.users.nikanel = import ./home/home.nix;

					home-manager.extraSpecialArgs = { inherit inputs; };
				}
			];
		};
	};
}
