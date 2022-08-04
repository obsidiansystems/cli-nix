let
  cli-nix = pkgs: ghc: with pkgs.haskell.lib; overrideCabal (ghc.callCabal2nix "cli-nix" ./. {}) {
    librarySystemDepends = with pkgs; [
      nix
      nix-prefetch-git
    ];
  };
in {
  inherit cli-nix;
}
