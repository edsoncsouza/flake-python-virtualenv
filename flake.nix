{
  description = "Python virtualenv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.python311Packages.virtualenv
            pkgs.python311
            pkgs.python311Packages.pip
            pkgs.python311Packages.setuptools
            pkgs.python311Packages.wheel
            pkgs.python311Packages.tkinter
            pkgs.ffmpeg
            pkgs.python311Packages.yt-dlp
            pkgs.python311Packages.flask
            pkgs.python311Packages.flask-cors
            pkgs.python311Packages.flask-socketio
          ];

          shellHook = ''
            export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib"
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
