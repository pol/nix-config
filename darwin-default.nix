{pkgs, ...}: {
  imports = [
    ./common.nix
    ./darwin-pam.nix
    ./darwin-core.nix
    ./darwin-brew.nix
    ./darwin-preferences.nix
  ];
}
