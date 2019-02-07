{ stdenv, fetchFromGitHub, makeWrapper
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk_pixbuf
, wlroots, wayland-protocols, swaybg
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-2019-06-09g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "2bccb387d81298ffd3b88a193deb3e32c0b6c494";
    sha256 = "1l74ps8qc88pwb6fzkffhvjw4gla2hy7jgmy2d324h6hdylw5k6y";
  };

  nativeBuildInputs = [ pkgconfig meson ninja scdoc makeWrapper ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk_pixbuf
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
