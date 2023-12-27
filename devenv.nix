{ pkgs, inputs, ... }:
let
  flutter = inputs.flutter-nix.packages.${pkgs.stdenv.system}.flutter;
  android = (import inputs.android-nixpkgs { }).sdk (sdkPkgs:
    with sdkPkgs; [
      build-tools-30-0-3
      build-tools-34-0-0
      cmdline-tools-latest
      emulator
      platform-tools
      platforms-android-30
      platforms-android-33
      platforms-android-34
      system-images-android-34-google-apis-x86-64
    ]);
    in
{
  languages.nix.enable = true;
  languages.dart.enable = true;
  languages.dart.package = flutter;
  languages.java.enable = true;
  packages = [ pkgs.git ];

  enterShell = ''
    export PATH="${android}/bin:${flutter}/bin:$PATH"
    export LD_LIBRARY_PATH="$DEVENV_ROOT/build/linux/x64/debug/bundle/lib:$DEVENV_ROOT/build/linux/x64/release/bundle/lib:$LD_LIBRARY_PATH"
    ${(builtins.readFile "${android}/nix-support/setup-hook")}
  '';
}
