{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mangle";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mangle";
    rev = "v${version}";
    hash = "sha256-qRkLA8W7Leh7x/e9X+jXqPfsLkXkzEu+l3SLKsZP0f8=";
  };
  vendorHash = "sha256-pKKiCBK8ldL6lEdlbHrFpCOHvIscxJ9ckJaWBl9cZl8=";

  subPackages = [ "interpreter/mg" ];

  meta = with lib; {
    description = "Mangle is a programming language for deductive database programming";
    homepage = "https://github.com/google/mangle";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "mg";
  };
}
