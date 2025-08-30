{ _config, _pkgs, lib, specialArgs, ... }:

{
  home.username = specialArgs.username;
  home.homeDirectory = lib.mkForce "/Users/${specialArgs.username}";
  home.stateVersion = specialArgs.stateVersion;

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
      format = "\n[](fg:#7287fd)[$directory](bg:#7287fd)[](fg:#7287fd bg:#313244)$git_branch[](fg:#313244 bg:#45475a)$git_status[](#45475a bg:#585b70)$time[](fg:#585b70 bg:none) $all$character ";

      add_newline = true;

      directory.style = "bg:#7287fd fg:#ffffff";

      git_branch.format = "[ $symbol$branch ]($style)";
      git_branch.style = "bg:#313244 fg:#ffffff";

      git_status.format = "[ $all_status$ahead_behind ]($style)";
      git_status.style = "bg:#45475a fg:#ffffff";

      time.disabled = false;
      time.format = "[ $time ]($style)";
      time.style = "bg:#585b70 fg:#ffffff";
    };
  };

  programs.zsh = {
    defaultKeymap = "emacs";
  };
}
