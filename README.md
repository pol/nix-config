 
Do this stuff: 
1. Install Nix: 
2. Build

3. Install nix-darwin
   nix --extra-experimental-features "nix-command flakes"  run nix-darwin -- switch --flake ~/.config/nixpkgs

4. Apply Changes
   darwin-rebuild switch --flake ~/.config/nixpkgs

NOTES
2023-10-19
New computer.  Notes here about setup. :)

On the new machine, you will: 

1. Install nix using the determinate installer.  Either use the scary curl command, or just download the latest built installer for the platform (what I did) and run it.  Use the defaults. 
2. Copy over your ssh keys. 
   TODO: figure out a way to safely store your ssh keys.
   - https://github.com/ryantm/agenix
	 - pro: just uses ssh keys to do the encrypting
	 - con: doesn't work with password protected keys very well
3. Clone the nixpkgs repo into ~/.config/nixpkgs
   mkdir ~/.config
   git clone git@github.com:pol/nix-config ~/.config/nixpkgs

   This will trigger the installation of the xcode cli tools, which you need to install.
   After it is done, run the command again.
4. Open a new terminal window to get the nix binary in your path
5. The nix build will choke on two existing files, so do this: 
   sudo mv /etc/shells /etc/shells.before-nix-darwin
   sudo mv /etx/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin 
   this will wipe out our nix.conf which means we need to declare using experimental features.
5. Run: nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/.config/nixpkgs
   This will take a very long time.  There are many GB of things to retrieve/build.

2023-09-26
After beating my head against the [home-manager method](https://github.com/nix-community/nix-doom-emacs/blob/master/docs/reference.md#with-flakes) of installing doom-emacs, I am switching to using the [imperative method](https://github.com/hlissner/dotfiles/blob/master/modules/editors/emacs.nix). 
- I went even less awesome and just used the home-manager program install and the boring normal doom install.  I should integrate the imperative install into my nix setup, but I have spent way too much time messing with this at this point. :)
