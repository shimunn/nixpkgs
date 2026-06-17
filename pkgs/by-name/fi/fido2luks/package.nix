{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cryptsetup,
  udev,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fido2luks";
  version = "release-0.3.1";

  src = fetchFromGitHub {
    rev = finalAttrs.version;
    hash = "sha256-MJ0jsuNnfKU5j3s2cU8fzyjx7C/5Mt0cK/wTnRB8tmo=";
    repo = finalAttrs.pname;
    owner = "shimunn";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ cryptsetup udev ];

  cargoHash = "sha256-XwreoGU8ZT5G6nWhRaQqVnKS6Xb/W/AS98O8oE9HkT4=";

  meta = {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ shimun mmahut ];
    platforms = lib.platforms.linux;
  };
})
