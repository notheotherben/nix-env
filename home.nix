{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "bpannell";
  home.homeDirectory = "/Users/bpannell";
  home.packages = [
    pkgs._1password
    pkgs._1password-gui
    #pkgs.azure-cli
    pkgs.caddy
    pkgs.dotnet-sdk
    #pkgs.firefox
    pkgs.git
    pkgs.go
    pkgs.httpie
    pkgs.jq
    pkgs.nmap
    pkgs.nodejs
    pkgs.nomad
    pkgs.protobuf
    pkgs.rustup
    pkgs.shellcheck
    pkgs.speedtest-cli
    pkgs.starship
    pkgs.tailscale
    pkgs.terraform
    pkgs.vault
    pkgs.vim
    pkgs.vscode
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

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
    envExtra = "export GITTOOL_CONFIG=\"$HOME/dev/git-tool.yml\"";
    initExtra = "eval \"$(starship init zsh)\"\neval \"$(git-tool shell-init zsh)\"";
    shellAliases = {
      "gt" = "git-tool";
    };
  };
}
