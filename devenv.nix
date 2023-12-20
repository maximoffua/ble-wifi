{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce;
  inherit (inputs) android-nixpkgs flutter-nix;
  flutterSdk = flutter-nix.packages.${pkgs.stdenv.system};
  sdk = (import android-nixpkgs {}).sdk (sdkPkgs:
    with sdkPkgs; [
      build-tools-34-0-0
      build-tools-30-0-3
      cmdline-tools-latest
      emulator
      platform-tools
      platforms-android-34
      platforms-android-33
      platforms-android-31
      platforms-android-30
      platforms-android-29
      platforms-android-28
      system-images-android-34-google-apis-playstore-x86-64
    ]);
in {
  # https://devenv.sh/basics/
  dotenv.enable = false;
  dotenv.disableHint = true;
  env.SUPPORT_EMAIL = mkDefault "support@grovero.com";
  env.SUPPORT_PHONE = mkDefault "+311112233456";
  env.ANDROID_AVD_HOME = "${config.env.DEVENV_ROOT}/.android/avd";
  env.ANDROID_SDK_ROOT = "${sdk}/share/android-sdk";
  env.ANDROID_HOME = config.env.ANDROID_SDK_ROOT;
  env.FLUTTER_SDK = "${pkgs.flutter}";
  env.GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdk}/share/android-sdk/build-tools/34.0.0/aapt2 "
    + "-Dorg.gradle.project.buildDir=/tmp/gradle-build";

  # https://devenv.sh/packages/
  packages = [
    pkgs.cmake
    pkgs.pkg-config
    pkgs.libsecret
    pkgs.jsoncpp
  ];

  # https://devenv.sh/scripts/
  # Create the initial AVD that's needed by the emulator
  scripts.create-avd.exec = "avdmanager create avd --force --name phone --package 'system-images;android-34;google_apis_playstore;x86_64'";

  # https://devenv.sh/processes/
  # These processes will all run whenever we run `devenv run`
  processes.emulator.exec = "emulator -avd phone -skin 720x1280";
  processes.generate.exec = "dart run build_runner watch || true";
  # processes.grovero-app.exec = "flutter run lib/main.dart";

  enterShell = ''
    mkdir -p $ANDROID_AVD_HOME
    export PATH="${sdk}/bin:$FLUTTER_SDK/bin:$PATH"
    export FLUTTER_PLUGIN_BUILD_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/flutter/gradle-plugin";
    export LD_LIBRARY_PATH="$DEVENV_ROOT/build/linux/x64/debug/bundle/lib:$LD_LIBRARY_PATH"

    if [ ! -f .env ]; then
      env | grep -E '(SUPABASE|GOOGLE|SUPPORT)_' > .env
    fi
  '';

  # https://devenv.sh/languages/
  languages.dart = {
    enable = true;
    package = flutterSdk.flutter;
  };

  languages.java = {
    enable = true;
    gradle.enable = false;
    jdk.package = pkgs.jdk;
  };

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
