 
Do this stuff: 
1. Install Nix: 
2. Build

3. Install nix-darwin
   nix --extra-experimental-features "nix-command flakes"  run nix-darwin -- switch --flake ~/.config/nixpkgs

4. Apply Changes
   darwin-rebuild switch --flake ~/.config/nixpkgs

