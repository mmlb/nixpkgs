{ fetchFromGitHub, libgit2, ...}:

libgit2.overrideAttrs (oldAttrs: {
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DZERO_NSEC=ON"
    "-DTHREADSAFE=ON"
    "-DUSE_BUNDLED_ZLIB=ON"
    "-DREGEX_BACKEND=builtin"
    "-DUSE_HTTP_PARSER=builtin"  # overwritten from libgit2
    "-DUSE_SSH=OFF"
    "-DUSE_HTTPS=OFF"
    "-DBUILD_CLAR=OFF"
    "-DUSE_GSSAPI=OFF"
    "-DUSE_NTLMCLIENT=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
  ];
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "libgit2";
    rev = "005f77dca6dbe8788e55139fa1199fc94cc04f9a";
    sha256 = "1h5bnisk4ljdpfzlv8g41m8js9841xyjhfywc5cn8pmyv58c50il";
  };
})
