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
      rev = "d43786fc6c5856e5f47d7f66c110853adc87dc0f";
      sha256 = sha256:jZFzNwBQPat3GvwCM1AaRnMbOOMtqCkoCUJTFIDCP8o=;
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
