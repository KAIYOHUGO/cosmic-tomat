{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];
      systems = [ "x86_64-linux" ];
      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          devShells.default =
            with pkgs;
            mkShell {
              nativeBuildInputs = [
                libcosmicAppHook
                libxkbcommon
                rustc
                cargo
                rustfmt
                just
              ];
            };
          packages.default = pkgs.callPackage (
            {
              lib,
              just,
              rustPlatform,
              libcosmicAppHook,
              libxkbcommon,
            }:
            rustPlatform.buildRustPackage {
              pname = "cosmic-tomat";
              version = "1.0.0";
              src = ./.;
              cargoHash = "sha256-yMLrxT0aSRYe5RMxASjzkaVRddq90spIN/tl3t1RC5g=";

              buildPhase = ''
                just prefix=$out build-release
              '';
              installPhase = ''
                just prefix=$out install
              '';

              nativeBuildInputs = [
                libcosmicAppHook
                libxkbcommon
                just
              ];
              # env.RUSTFLAGS = "-C link-arg=-Wl,-rpath,${nixpkgs.lib.makeLibraryPath dlopenLibraries}";
            }
          ) { };
        };
      flake = {
      };
    };
}
