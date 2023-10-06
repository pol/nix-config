 
Do this stuff: 
1. Install Nix: 
2. Build

3. Install nix-darwin
   nix --extra-experimental-features "nix-command flakes"  run nix-darwin -- switch --flake ~/.config/nixpkgs

4. Apply Changes
   darwin-rebuild switch --flake ~/.config/nixpkgs

NOTES
2023-10-03
New computer.  Notes here about setup. :)


2023-09-26
After beating my head against the [home-manager method](https://github.com/nix-community/nix-doom-emacs/blob/master/docs/reference.md#with-flakes) of installing doom-emacs, I am switching to using the [imperative method](https://github.com/hlissner/dotfiles/blob/master/modules/editors/emacs.nix). 
- I went even less awesome and just used the home-manager program install and the boring normal doom install.  I should integrate the imperative install into my nix setup, but I have spent way too much time messing with this at this point. :)
