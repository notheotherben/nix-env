self@{ config, pkgs, lib, inputs, ... }:

{
  nix.enable = true;
  # nix.package = pkgs.nixUnstable;

  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-users = [
    "@admin"
  ];

  ids.gids.nixbld = 350;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Allow closed source packages
  nixpkgs.config.allowUnfree = true;

  # Enable automatic GC and optimization of nix store
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; };
    options = "--delete-older-than 15d";
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = inputs.system;

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pki.certificates = [''
  -----BEGIN CERTIFICATE-----
  MIIDajCCAlKgAwIBAgIUBcvhyQMulV+3D7VJH7IYSQZ1pAwwDQYJKoZIhvcNAQEL
  BQAwJzElMCMGA1UEAxMcaW50ZXJuYWwuc2llcnJhc29mdHdvcmtzLmNvbTAeFw0y
  MjA1MTcxNzU1MjNaFw0zMjA1MTQxNzU1NTNaMCcxJTAjBgNVBAMTHGludGVybmFs
  LnNpZXJyYXNvZnR3b3Jrcy5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
  AoIBAQC/K0Mb5NGuTmknshuZ3J1f4W7UYnbppPyBDjHJPcK+plx9AR6jR85uoZe8
  rT5LzekYXN8aqTl3GEoqFwYkmChAZYXHwqNJG98J8OG1zR0No/XnbcTTOqSLSZTs
  pfwbqRSzq67lVbtVX4ZMNEjVvWoD9yESNfVSwRwwcLA0CAwnJguPfeVPBPaI+fJk
  OCzDV+DHnmChPW9A6T0agYfDXVUgO+KpUpIqf+Ci55JnK/FvUTkCLLZ9hajkOVen
  YaK/9ThiwvTIRYNIceQEybvj2L4+MikQ0pdf1uv0GNEVY303ADwnpyqrNDincyXn
  e0bQ2cDXWFndzs3vSvDdciq1X5nPAgMBAAGjgY0wgYowDgYDVR0PAQH/BAQDAgEG
  MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFBfDqVBlL1jf1X02K5Dj5DtpvKyM
  MB8GA1UdIwQYMBaAFBfDqVBlL1jf1X02K5Dj5DtpvKyMMCcGA1UdEQQgMB6CHGlu
  dGVybmFsLnNpZXJyYXNvZnR3b3Jrcy5jb20wDQYJKoZIhvcNAQELBQADggEBAFMG
  oG7l+NNl9DG9nUgX+QX4um6mG7rIRxpfQh8PuAUMHYFDyRhsjoE9S2idBsTPJ7ZU
  TPB0oOkkn3PwCmELTZctZbI7WdhUrKtXbHSLoyTJqxQkvhEY+WLmy4Db9x3TQ9rh
  crmbRMdYSMkNjwH4LSBMdIKThHhYq305tq6NsN8TU4QF47WYe/XfOtlLFN+Vro0/
  bS4Z9OsNljsR6/Bv/oaaAfJinopNP92zzpddESKcEg86M3c6MuNr199ff3BVI3LA
  CLCLTFozxAF62IKp1ebj82jjYfjNNfN2S34o4EaSQLqQfdzXRxp7UjMorGMWx2px
  qNbiMDISwlE2TWq8xMw=
  -----END CERTIFICATE-----
  ''];

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.CreateDesktop = false;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  environment.variables = {
    "VAULT_ADDR" = "https://vault.sierrasoftworks.com";
    "VAULT_SSH_ROLE" = "admin";

    "ATUIN_SYNC_ADDRESS" = "https://atuin.raptor-perch.ts.net";
  };

  environment.shellAliases = {
    "gt" = "git-tool";
    "http" = "xh";
    "direnv-init" = "nix flake new -t github:nix-community/nix-direnv";
  };

  environment.systemPackages = with pkgs; [
    #_1password-gui
    #azure-cli
    #firefox
    _1password-cli
    ansible
    ansible-language-server
    ansible-lint
    android-tools
    atuin
    caddy
    cargo-binstall
    deno
    docker
    dotnet-sdk_8
    git
    gitoxide
    go
    gotools
    gopls
    go-outline
    gopkgs
    gocode-gomod
    godef
    golint
    grpcurl
    jq
    nil
    nixd
    nodejs
    openjdk
    powershell
    protobuf
    python312Full
    python312Packages.pip
    rustup
    shellcheck
    speedtest-cli
    starship
    terraform
    uv
    vault
    vim
    xh
  ] ++ inputs.extraPackages;

  programs.direnv.enable = true;

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableSyntaxHighlighting = true;

    interactiveShellInit = ''
      export GITTOOL_CONFIG="$HOME/dev/git-tool.yml"

      eval "$(atuin init zsh)"
      eval "$(starship init zsh)"
      eval "$(git-tool shell-init zsh)"
    '';
  };

  services.tailscale.enable = true;
  services.tailscale.package = pkgs.tailscale;
}
