{fetchFromGitHub, libgit2_0_27, ...}:

libgit2_0_27.overrideAttrs (oldAttrs: rec {
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DUSE_BUNDLED_ZLIB=ON"
    "-DUSE_ICONV=OFF"
    "-DBUILD_CLAR=OFF"
    "-DUSE_SSH=OFF"
    "-DUSE_HTTPS=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DUSE_EXT_HTTP_PARSER=OFF"
  ];
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "libgit2";
    rev = "17cda36f6eff39fbccbc1340343a3c89c9a2217c";
    sha256 = "1dhwg7fwdwxm2z8nx168l2lg86vd2pmz6izrgrwl2xfbj842dwjd";
  };
})
