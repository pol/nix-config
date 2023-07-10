{
  description = "Pol's Okta Macbook";
  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22.11

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # nix shell run shortcut
    comma.url  = "github:nix-community/comma";
  };
  outputs = inputs: {
    darwinConfigurations.NHDQ60QHJQ =
      inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; };
        modules = [
          ({ pkgs, ... }: {
            # here go the darwin preferences and config items
            programs.zsh.enable = true;
            environment.shells = [ pkgs.bash pkgs.zsh pkgs.dash pkgs.ksh pkgs.tcsh ];
            environment.loginShell = pkgs.zsh;
            environment.systemPackages = [ pkgs.coreutils ];

            nix.extraOptions = ''
              auto-optimise-store = true
              experimental-features = nix-command flakes
              extra-platforms = x86_64-darwin aarch64-darwin
            '';
            system.keyboard.enableKeyMapping = true;
            system.keyboard.remapCapsLockToEscape = true;
            # fonts.fontDir.enable = true; # DANGER
            fonts.fonts =
              [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];
            services.nix-daemon.enable = true;
            system.defaults.finder.AppleShowAllExtensions = true;
            system.defaults.finder._FXShowPosixPathInTitle = true;
            system.defaults.dock.autohide = true;
            system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
            system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
            system.defaults.NSGlobalDomain.KeyRepeat = 1;
            # backwards compat; don't change
            system.stateVersion = 4;
            users.users.pol = { home = "/Users/pol"; };
          })
          inputs.home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.pol = import ./home.nix;
            };
          }
        ];
      };
      overlays = {
        comma = final: prev: {
          comma = import inputs.comma { inherit (prev) pkgs;};
        };
    };
  };
}