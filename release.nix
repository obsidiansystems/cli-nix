{ }:
let
  nixpkgsSets = import ./.ci/nixpkgs.nix;
  inherit (nixpkgsSets) nixos1809 nixos2003 unstable;
  inherit (nixos2003) lib;
  inherit (nixos2003.haskell.lib) doJailbreak dontCheck;
  commonOverrides = self: super: {
    which = self.callHackageDirect {
      pkg = "which";
      ver = "0.2";
      sha256 = "1g795yq36n7c6ycs7c0799c3cw78ad0cya6lj4x08m0xnfx98znn";
    } {};
    cli-extras = self.callHackageDirect {
      pkg = "cli-extras";
      ver = "0.1.0.1";
      sha256 = "1hnmk8jm9zrhcv8vz9raj0p26svc0rd47zc7nz58sja6jsakcaq2";
    } {};
  };
  ghcs = rec {
    ghc865 = nixos2003.haskell.packages.ghc865.override {
      overrides = commonOverrides;
    };
    ghc884 = nixos2003.haskell.packages.ghc884.override {
      overrides = commonOverrides;
    };
  };
in
  lib.mapAttrs (_: ghc: ghc.callCabal2nix "cli-nix" ./. {}) ghcs
