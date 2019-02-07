{fetchFromGitHub, libgit2, ...}:

libgit2.overrideAttrs (oldAttrs: rec {
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
    rev = "12f5b3e79b55c72d1f9f3b751193e36df72784ac";
    sha256 = "05qx0v1r49nn74ibs5sc1n3r6wwh2329nhvvy1xkm8lhgp1zx4zk";
  };
})
