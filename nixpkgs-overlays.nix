{
  inputs,
  nixpkgs-stable,
  ...
}: {
  overlays = [
    # channels
    (final: prev: {
      # expose other channels via overlays
      stable = import nixpkgs-stable {
        inherit (prev) system;
        config = import ./configuration.nix;
        #nix.package = inputs.nixos-stable.nixVersions.nix_2_11;
        nix.package = inputs.nixos-unstable.nix;
      };
    })
    (final: prev: {
      enola = prev.buildGoModule {
        name = "enola";
        pname = "enola";
        src = inputs.enola;
        # just have to manually update this each time it fails, I guess
        # vendorSha256 = prev.lib.fakeSha256;
        vendorSha256 = "sha256-UA4AoO9yDgufZrABJImo+580aaye4jp7qRevj3Efkrg=";
      };
    })
    # (final: prev: {
    #   kubernetes-yaml-formatter = prev.vscode-utils.buildVscodeExtension {
    #     name = "kubernetes-yaml-formatter";
    #     src = inputs.kubernetes-yaml-formatter;
    #     vscodeExtUniqueId = "kennylong.kubernetes-yaml-formatter";
    #     vscodeExtPublisher = "kennylong";
    #     vscodeExtName = "kubernetes-yaml-formatter";
    #     version = "1.1.0";
    #   };
    # })

    (final: prev: {
      # inherit (inputs.gtm-okr.packages.${final.system}) gtm-okr;
      # inherit (inputs.babble-cli.packages.${final.system}) babble-cli;
      inherit (inputs.mkalias.packages.${final.system}) mkalias;
      inherit (inputs.ironhide.packages.${final.system}) ironhide;
      inherit (inputs.pwnvim.packages.${final.system}) pwnvim;
      inherit (inputs.pwneovide.packages.${final.system}) pwneovide;
      inherit (inputs.nps.packages.${final.system}) nps;
      inherit (inputs.devenv.packages.${final.system}) devenv;
    })
    inputs.nur.overlay
  ];
}