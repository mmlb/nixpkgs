{ lib, stdenv, fetchFromGitHub, pkgconfig, python, wafHook
, freetype, libglvnd, xorg}:

stdenv.mkDerivation rec {
  pname = "zutty";
  version = "unstable-2021-02-07g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub rec {
    owner = "tomszilagyi";
    repo = "${pname}";
    rev = "aea41a1353af38fb1c4a871a0c42a3d2c134da07";
    sha256 = "19ja9aj5wj8fz533zzf6ir7bn10rwr4d5fgwlbkc153shxphhmrz";
  };

  nativeBuildInputs = [
    pkgconfig
    python
    wafHook
  ];

  buildInputs = [
    xorg.libXaw
    freetype
    libglvnd
  ];

  meta = {
    homepage = "https://tomscii.sig7.se/zutty/";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ mmlb ];
    platforms = with lib.platforms; linux;
  };
}
