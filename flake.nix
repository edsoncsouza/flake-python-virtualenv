{
  description = "Python virtualenv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.python3
            pkgs.python3Packages.virtualenv
          ];

          shellHook = ''
            if [ ! -d ".venv" ]; then
              python -m venv .venv
              source .venv/bin/activate
              pip install --upgrade pip
              [[ -e requirements.txt ]] && pip install -r requirements.txt
            else
              source .venv/bin/activate
            fi
          '';
        };
      }
    );
}
