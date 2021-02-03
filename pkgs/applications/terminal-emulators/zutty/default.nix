{ lib, stdenv, fetchFromGitHub, pkgconfig, python, wafHook
, freetype, libglvnd, xorg}:

stdenv.mkDerivation rec {
  pname = "zutty";
  version = "unstable-2021-01-30g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub rec {
    owner = "tomszilagyi";
    repo = "${pname}";
    rev = "f3fcf8e92b22e58b30947cf2585e361106dbcf9d";
    sha256 = "1zvfaayx0v0w2gdd1qiz894x9f665k6y2yqhgfm7mj04vl3f3wzl";
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
