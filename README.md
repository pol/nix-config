 
Do this stuff: 
1. Install Nix: 
2. Build

3. Install nix-darwin
   nix --extra-experimental-features "nix-command flakes"  run nix-darwin -- switch --flake ~/.config/nixpkgs

4. Apply Changes
   darwin-rebuild switch --flake ~/.config/nixpkgs

NOTES
2024-01-02

Upgrade to Sonoma
- nix volume still exists
- brew appears to be missing
- lots of broken symlinks

Going to re-install homebrew manually, then see if the magic works: 
  nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/.config/nixpkgs

no nix binary in the path... I think I can re-run the /nix/nix-installer to get it? Creating a plan is insteresting, it shows many steps as completed already, but some of the uncompleted ones look scary (like removing volumes).

the installer says it can only uninstall since there is a receipt present, but I really don't want to have to re-download the entire /nix store.  I am going to try to see if i can figure out which nix binary I used to use and go from there.

Let's see if there is anything in my ~/.config to go on.  Heh, in my emacs ~/.config/emacs/.local/env there is an autogenerated dump that doom created of my original shell env. 
My current $PATH is:

```
❯ echo $PATH
/usr/bin:/bin:/usr/sbin:/sbin
```

the doom path was: 

```
PATH=/opt/homebrew/bin:/Users/pol.llovet/.nix-profile/bin:/etc/profiles/per-user/pol.llovet/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin
```

This actually might be enough to make things work, since I see references to all the important bits in there.  The /opt/homebrew files are all there, I didn't need to reinstall it.  I think maybe all I need is to make sure this PATH gets cached somewhere between upgrades.

after setting the path, I try the long nix-darwin run but et this error: 
`error: unable to download 'https://api.github.com/repos/LnL7/nix-darwin/commits/HEAD': Problem with the SSL CA cert (path? access rights?) (77)`

A google search lands on this solution: https://github.com/NixOS/nix/issues/8771#issuecomment-1662633816

aaaaand that appeared to work, as now the flake build is proceeding.

Not so fast!  None of my nix-darwin com.apple preferences are working because my user isn't even allowed to sudo access the directories. Even though my user is the owner, and I shouldn't need sudo, but even sudo doesn't work. I suspect an extra layer of apple system security.  I will comment out all of that stuff from the darwin config, then remove it if it works.

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

Troubleshooting: 
- Homebrew didn't install on its own because there is a check that looks for a brew binary... I think this is a chicken/egg declarative problem.  You need brew to exist for the packages to get installed.  I tried a flake update to see if it is fixed in a later version, but the last time I did this, it broke nvim because I am using zmre's pwnvim version. If it breaks nvim again, I might just give up on pwnvim and use a different nvim (probably just steal what hlissner uses).


2023-09-26
After beating my head against the [home-manager method](https://github.com/nix-community/nix-doom-emacs/blob/master/docs/reference.md#with-flakes) of installing doom-emacs, I am switching to using the [imperative method](https://github.com/hlissner/dotfiles/blob/master/modules/editors/emacs.nix). 
- I went even less awesome and just used the home-manager program install and the boring normal doom install.  I should integrate the imperative install into my nix setup, but I have spent way too much time messing with this at this point. :)
