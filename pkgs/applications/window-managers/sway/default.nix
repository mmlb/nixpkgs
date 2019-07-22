{ stdenv, fetchFromGitHub, makeWrapper
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf
, wlroots, wayland-protocols, swaybg
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-2019-07-18g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "36aa67e549609ce6c786c382f14ab866536cac47";
    sha256 = "0k220ni52z5jgj2n9jh68xal0ph6l0hxxgvzr23bbdrh8rcmb02f";
  };

  nativeBuildInputs = [ pkgconfig meson ninja scdoc makeWrapper ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk-pixbuf
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Ddefault-wallpaper=false" "-Dxwayland=enabled" "-Dgdk-pixbuf=enabled"
    "-Dtray=enabled" "-Dman-pages=enabled"
    "-DSWAY_VERSION=${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/sway --prefix PATH : "${swaybg}/bin"
  '';

  postPatch = ''
    sed -i "s/version: '1.0'/version: '${version}'/" meson.build
  '';

  meta = with stdenv.lib; {
    description = "i3-compatible tiling Wayland compositor";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
