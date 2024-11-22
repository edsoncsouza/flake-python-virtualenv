{
  pkgs ?
    let
      lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
      nixpkgs = fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
        sha256 = lock.narHash;
      };
    in
    import nixpkgs { },
  ...
}:
pkgs.mkShell {
  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib"
    if [ ! -d ".venv" ]; then
      python -m venv .venv
      source .venv/bin/activate
      pip install --upgrade pip
      [[ -e requirements.txt ]] && pip install -r requirements.txt
    else
      source .venv/bin/activate
      [[ -e requirements.txt ]] && pip install -r requirements.txt
    fi
  '';
  packages = with pkgs; [
    (python3.withPackages (
      ps: with ps; [
        requests
        pyaml
        virtualenv
        pip
        setuptools
        wheel
      ]
    ))
    ffmpeg
  ];
}
