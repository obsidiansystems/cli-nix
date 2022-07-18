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
    cli-extras = self.callCabal2nix "cli-extras" (nixos2003.fetchFromGitHub {
      owner = "obsidiansystems";
      repo = "cli-extras";
      rev = "7a81d23776a1b992005cb74b2934992e03582670";
      sha256 = sha256:iSo88gSAFkkBf6b1rswF0y/Wd/NeDff9O39L6S7QdgM=;
    }) {};
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
