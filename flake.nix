{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            just
            catppuccin-whiskers
            catppuccin-catwalk
            ruby
            rubocop
          ];
          buildInputs = with pkgs; [
            libjpeg
            libpng
            libtiff
            libwebp
          ];
        };
      }
    );
}
