{ stdenv, imagemagick, qt5, fetchFromGitHub, makeDesktopItem, lib }: stdenv.mkDerivation rec {

  name = "Coil64";

  version = "2.1.29";

  src = fetchFromGitHub {
    owner = "radioacoustick";
    repo = "Coil64";
    rev = "v" + version;
    sha256 = "sha256-AvUPFuJoifhWHvN0bXsS97GBJDtC4GfKHDncKpJcpzQ=";
  };

  qmakeFlags = [ "Coil64.pro" ];

  nativeBuildInputs = with qt5; [ imagemagick qmake wrapQtAppsHook ];
  buildInputs = with qt5; [ qtbase ];

  desktopItem = makeDesktopItem rec {
    inherit name;
    desktopName = name;
    icon = name;
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    cp Coil64 $out/bin/
    cp -r ${desktopItem}/share $out/
    function icon() {
      mkdir -p $out/share/icons/hicolor/''${1}x''${1}/apps
      convert "res/Coil64_Icon.ico" -thumbnail ''${1}x''${1} -alpha on -background none -flatten "$out/share/icons/hicolor/''${1}x''${1}/apps/${name}.png"
    }
    icon 16
    icon 32
    icon 64
    icon 256
  '';

  meta = {
    mainProgram = "Coil64";
    license = lib.licenses.gpl3Only;
    description = ''Coil64 is inductance coil calculator, that allows to calculate the single-layer and multi-layer air core inductors, the ferrite core inductors or chokes, planar coils on PCB etc.'';
  };
}
