{
  lib,
  cargo,
  rustc,
  makeRustPlatform,
  fetchFromGitHub,
  pkg-config,
  clang,
  llvmPackages,
  tpm2-tss,
  makeWrapper,
  nix-update-script,
}:
let
  rustPlatform = makeRustPlatform {
    inherit rustc cargo; # ensure these resolve to >=1.85
  };
in
rustPlatform.buildRustPackage rec {
  pname = "fidorium";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "edg-l";
    repo = "fidorium";
    tag = "v${version}";
    # Run `nix-prefetch-github edg-l fidorium --rev v${version}`
    # or build once with lib.fakeHash and copy the real hash from the error.
    hash = "sha256-zGM3bnM+jW9jukGq30xdK3Jt8lvQBwhpUb/SEhf1sRs=";
  };

  # Run the build once with lib.fakeHash and copy the real hash from the error,
  # or use `nix run nixpkgs#cargo -- generate-lockfile` / `nix-prefetch`.
  cargoHash = "sha256-lSluigEITTmgeR2y2at1tSx2ApiSXV67utepg5zMkis=";

  nativeBuildInputs = [
    pkg-config
    clang
    makeWrapper
  ];

  buildInputs = [
    tpm2-tss
  ];

  # tss-esapi-sys uses bindgen against tpm2-tss headers
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # No TPM/uhid device is available in the sandbox, and the test suite
  # exercises the real TPM/CTAPHID stack.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/fidorium \
      --suffix PATH : ${lib.makeBinPath [ ]} # add a pinentry package here if desired, e.g. pinentry-curses
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FIDO2/CTAP2 authenticator daemon for Linux backed by TPM 2.0";
    homepage = "https://github.com/edg-l/fidorium";
    changelog = "https://github.com/edg-l/fidorium/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ ]; # add yourself here
    mainProgram = "fidorium";
    platforms = lib.platforms.linux;
  };
}
