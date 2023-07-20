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
    nur.url = "github:nix-community/NUR";                    # firefox extensions
    fenix.url = "github:nix-community/fenix";                # rustc (for hackernews-tui)
    fenix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    pwnvim.url = "github:zmre/pwnvim";                       # super-charged neovim
    pwneovide.url = "github:zmre/pwneovide";                 # neovim gui
    ironhide.url = "github:IronCoreLabs/ironhide?ref=1.0.5"; # encryption tools
    hackernews-tui.url = "github:aome510/hackernews-TUI";    # hn-tui
    hackernews-tui.flake = false;
    devenv.url = "github:cachix/devenv/latest";              # dev project shells (TRIAL)
    mkalias.url = "github:reckenrode/mkalias";               # mac aliases w/o finder script permssions
    mkalias.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nps.url = "github:OleMussmann/Nix-Package-Search";       # use nps to quick search packages (gnugrep req)
    nps.inputs.nixpkgs.follows = "nixpkgs";
    enola.url = "github:TheYahya/enola";                     # sister to sherlock osint recon tool
    enola.flake = false;
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    darwin,
    home-manager,
    sbhosts,
    nixos-hardware,
    ...
  }: let
    inherit (home-manager.lib) homeManagerConfiguration;
    inherit (darwin.lib) darwinSystem;

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        inherit
          (import ./modules/overlays.nix {
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
  in 
  {

    darwinConfigurations = let
      username = "pol";
    in {
      NHDQ60QHJQ = darwinSystem {
        system = "aarch64-darwin";
        pkgs = mkPkgs "aarch64-darwin";
        specialArgs = {
          inherit sbhosts inputs nixpkgs-stable nixpkgs-unstable username;
        };
        modules = [
          ./modules/darwin
          home-manager.darwinModules.home-manager {
            homebrew.brewPrefix = "/opt/homebrew/bin";
          }
          (mkHome username [
            ./modules/home-manager
            ./modules/home-manager/home-darwin.nix
            # ./modules/home-manager/home-darwin.nix   # pile of sec tools, when needed
          ])
        ];
      };
    };
    # overlays = {
    #   apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
    #     # Add access to x86 packages system is running Apple Silicon
    #     pkgs-x86 = import inputs.nixpkgs-unstable {
    #       system = "x86_64-darwin";
    #       inherit (nixpkgsConfig) config;
    #     };
    #   };
    #   security-pam = 
    #     # Upstream PR: https://github.com/LnL7/nix-darwin/pull/228
    #     { config, lib, pkgs, ... }:

    #     with lib;

    #     let
    #       cfg = config.security.pam;

    #       # Implementation Notes
    #       #
    #       # We don't use `environment.etc` because this would require that the user manually delete
    #       # `/etc/pam.d/sudo` which seems unwise given that applying the nix-darwin configuration requires
    #       # sudo. We also can't use `system.patchs` since it only runs once, and so won't patch in the
    #       # changes again after OS updates (which remove modifications to this file).
    #       #
    #       # As such, we resort to line addition/deletion in place using `sed`. We add a comment to the
    #       # added line that includes the name of the option, to make it easier to identify the line that
    #       # should be deleted when the option is disabled.
    #       mkSudoTouchIdAuthScript = isEnabled:
    #       let
    #         file   = "/etc/pam.d/sudo";
    #         option = "security.pam.enableSudoTouchIdAuth";
    #       in ''
    #         ${if isEnabled then ''
    #           # Enable sudo Touch ID authentication, if not already enabled
    #           if ! grep 'pam_tid.so' ${file} > /dev/null; then
    #             sed -i "" '2i\
    #           auth       sufficient     pam_tid.so # nix-darwin: ${option}
    #             ' ${file}
    #           fi
    #         '' else ''
    #           # Disable sudo Touch ID authentication, if added by nix-darwin
    #           if grep '${option}' ${file} > /dev/null; then
    #             sed -i "" '/${option}/d' ${file}
    #           fi
    #         ''}
    #       '';
    #     in

    #     {
    #       options = {
    #         security.pam.enableSudoTouchIdAuth = mkEnableOption ''
    #           Enable sudo authentication with Touch ID
    #           When enabled, this option adds the following line to /etc/pam.d/sudo:
    #               auth       sufficient     pam_tid.so
    #           (Note that macOS resets this file when doing a system update. As such, sudo
    #           authentication with Touch ID won't work after a system update until the nix-darwin
    #           configuration is reapplied.)
    #         '';
    #       };

    #       config = {
    #         system.activationScripts.extraActivation.text = ''
    #           # PAM settings
    #           echo >&2 "setting up pam..."
    #           ${mkSudoTouchIdAuthScript cfg.enableSudoTouchIdAuth}
    #         '';
    #       };
    #     };
    # };
  };
}