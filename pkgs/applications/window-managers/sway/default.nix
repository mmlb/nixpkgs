{ stdenv, fetchFromGitHub, makeWrapper
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk_pixbuf
, wlroots, wayland-protocols, swaybg
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-2019-06-05g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "b4b274cdcea5269fc39ef9c846157d211f79eec9";
    sha256 = "1j4zkgwknlh28x48gf0c9i7hgwr2c7fip9l07rpkgnghk6sb6vk1";
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
