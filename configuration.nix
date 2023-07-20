{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-users = [
    "@admin"
  ];
  nix.configureBuildUsers = true;

  programs.zsh.enable = true;
  programs.nix-index.enable = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # fonts.fontDir.enable = true; # DANGER
  fonts.fonts = with pkgs; [ 
    (nerdfonts.override { fonts = [ "Meslo" ]; }) 
  ];

  services.nix-daemon.enable = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder._FXShowPosixPathInTitle = true;
  system.defaults.dock.autohide = true;
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  security.pam.enableSudoTouchIdAuth = true;

  # backwards compat; don't change
  system.stateVersion = 4;
  users.users.pol = { 
    home = "/Users/pol";
    description = "Pol Llovet";
    shell = pkgs.zsh; 
  };
}