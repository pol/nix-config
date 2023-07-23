 
Do this stuff: 
1. Install Nix: 
Use the Declarative Nix Installer: https://github.com/DeterminateSystems/nix-installer
I used the platform binary: https://github.com/DeterminateSystems/nix-installer/releases/download/v0.10.0/nix-installer-aarch64-darwin
I bet the shortcut works great.
2. Build
cd ~/.config/nixpkgs
nix run nix-darwin -- switch --flake ~/.config/nix-darwin

this fails, and you need to fix the certs
NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt
sudo vim /Library/LaunchDaemons/org.nixos.nix-daemon.plist
add the env var into the env var section

reboot.


3. Install nix-darwin
 nix --extra-experimental-features "nix-command flakes"  run nix-darwin -- switch --flake ~/.config/nix

4. darwin-build switch

