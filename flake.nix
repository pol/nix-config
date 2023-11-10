{
  # cribbed heavily from https://github.com/zmre/nix-config

  description = "Pol's Okta Macbook";
  inputs = {
    # Nix
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # defaulting to unstable these days

    # Mac Stuff
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Nix Flake Utils
    flake-utils.url = "github:numtide/flake-utils";

    # Poached from github.com/zmre
    nur.url = "github:nix-community/NUR"; # firefox extensions
    pwnvim.url = "github:zmre/pwnvim"; # super-charged neovim
    pwneovide.url = "github:zmre/pwneovide"; # neovim gui
    devenv.url = "github:cachix/devenv/latest"; # dev project shells (TRIAL)
    mkalias.url = "github:reckenrode/mkalias"; # mac aliases w/o finder script permssions
    mkalias.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nps.url = "github:OleMussmann/Nix-Package-Search"; # use nps to quick search packages (gnugrep req)
    nps.inputs.nixpkgs.follows = "nixpkgs";
    #TODO try these out
    ironhide.url = "github:IronCoreLabs/ironhide?ref=1.0.5"; # encryption tools
    enola.url = "github:TheYahya/enola"; # sister to sherlock osint recon tool
    enola.flake = false;

    # Voice commands
    # Add back once it supports aarch64-darwin, use brew for now
    #talon.url = "github:nix-community/talon-nix";
    #talon.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    darwin,
    home-manager,
    ...
  }: let
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        inherit
          (import ./nixpkgs-overlays.nix {
            inherit inputs nixpkgs-unstable nixpkgs-stable;
          })
          overlays
          ;
        config = import ./configuration.nix;
      };

    mkHome = username: modules: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {inherit inputs username;};
        users."${username}".imports = modules;
      };
    };
  in {
    darwinConfigurations = let
      username = "pol.llovet";
    in {
      XXQ1GC06N4 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = mkPkgs "aarch64-darwin";
        specialArgs = {
          inherit inputs nixpkgs-stable nixpkgs-unstable username;
        };
        modules = [
          ./darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            homebrew.brewPrefix = "/opt/homebrew/bin";
          }
          (mkHome username [
            ./home/default.nix
            ./home/darwin.nix
            # ./home/security.nix   # pile of sec tools, when needed
          ])
        ];
      };
    };
  };
}
