self@{ config, pkgs, inputs, ... }:

{
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nixUnstable;

  # Enable Flakes
  nix.settings.experimental-features = "nix-command flakes";
  
  # Allow closed source packages
  pkgs.config.allowUnfree = true;

  # Enable automatic GC and optimization of nix store
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = inputs.system;

  security.pam.enableSudoTouchIdAuth = true;
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
  };

  environment.shellAliases = {
    "gt" = "git-tool";
  };

  environment.systemPackages = with pkgs; [
    #_1password-gui
    #azure-cli
    #firefox
    _1password
    atuin
    android-tools
    cachix
    caddy
    deno
    dotnet-sdk
    git
    gitoxide
    go
    jq
    nomad
    powershell
    protobuf
    python312Full
    python312Packages.httpie
    python312Packages.pip
    rustup
    shellcheck
    speedtest-cli
    starship
    tailscale
    terraform
    vault
    vim
  ] ++ inputs.extraPackages;

  home.username = inputs.username;
  home.homeDirectory = "/Users/${inputs.username}";

  programs.git = {
    enable = true;

    userName = "Benjamin Pannell";
    userEmail = "benjamin@pannell.dev";

    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";

      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILps0qzyssGwA6UyIxBOgHg1RhA92zlY4GKdASmERLUl";
      commit.gpgsign = true;

      gpg.format = "ssh";
      gpg.sshprogram = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "\n[](fg:#1C4961)[$directory](bg:#1C4961)[](fg:#1C4961 bg:#2F79A1)$git_branch[](fg:#2F79A1 bg:#3A95C7)$git_status[](#3A95C7 bg:#40A9E0)$time[](#40A9E0 bg:none) $all$character ";

      add_newline = true;

      directory.style = "bg:#1C4961 fg:white";

      git_branch.format = "[ $symbol$branch ]($style)";
      git_branch.style = "bg:#2F79A1 fg:white";

      git_status.format = "[ $all_status$ahead_behind ]($style)";
      git_status.style = "bg:#3A95C7 fg:white";

      time.disabled = false;
      time.format = "[ $time ]($style)";
      time.style = "bg:#40A9E0 fg:white";
    };
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "emacs";

    interactiveShellInit = ''
      export GITTOOL_CONFIG="$HOME/dev/git-tool.yml"
    
      eval "$(atuin init zsh)"
      eval "$(starship init zsh)"
      eval "$(git-tool shell-init zsh)"
    '';
  };
}
