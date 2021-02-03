{ lib, stdenv, fetchFromGitHub, pkgconfig, python, wafHook
, freetype, libglvnd, xorg}:

stdenv.mkDerivation rec {
  pname = "zutty";
  version = "unsable-20210123";

  src = fetchFromGitHub rec {
    owner = "tomszilagyi";
    repo = "${pname}";
    rev = "cd0c93e68528818324fb24908947e1399a716718";
    sha256 = "1vhf12y7r6fmhg51hf14rw1hmd2sx0fln4c61ngz14rk6kmgpwxh";
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
