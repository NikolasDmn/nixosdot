{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
    nixpkgs.config.allowUnfree = true;
  imports = [
    ./hyprland.nix
    ./walker.nix
    ./tmux.nix
  ];
  home.homeDirectory = "/home/nikanel";
  home.packages = with pkgs; [

    obsidian
    kid3
    calibre

    gnucash
    rclone

    aonsoku
    feishin
    whatsapp-electron


    # platformio
    platformio-core
    stm32cubemx

    htop
    neofetch

    firefox

    tree-sitter
    ripgrep
    fd

    nil
    nixpkgs-fmt
    alejandra

    rust-analyzer
    cargo
    rustfmt

    gnumake
    cmake
    pkg-config
    lua-language-server
    stylua
    shfmt
    shellcheck



    nodejs_20
    python3
    python3Packages.pynvim

    wl-clipboard

    vscode-langservers-extracted

    prettierd
     vscode
     discord

     libreoffice-qt-fresh


    walker

    pavucontrol
    blueman
    networkmanagerapplet
    playerctl

      modrinth-app


  ];
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

 programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      nixupdate = "sudo nixos-rebuild switch --flake /etc/nixos";
      nixedit = "nvim /etc/nixos";
    };
  };
 programs.atuin = {
    enable = true;
    enableBashIntegration = true;   # Ctrl+R override
  };
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
      IdentityAgent "~/.1password/agent.sock"
    '';
  };
   home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      mouse_hide_wait = "-1.0";
      window_padding_width = 5;
      background_opacity = "0.5";
      background_blur = 5;
      copy_on_select = true;
      clipboard_control = "write-clipboard read-clipboard write-primary read-primary";
    };
  };
   home.file.".ssh/1p_git_signing.pub".text = ''
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIAtQXViBCDOhvR8Lr4dsS3Z9pNNFeewlz/KKnMsFlO
  '';
  home.file.".config/git/allowed_signers".text = ''
  NikolasDmn ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIAtQXViBCDOhvR8Lr4dsS3Z9pNNFeewlz/KKnMsFlO
  '';
  programs.git = {
    enable = true;
    userName = "NikolasDmn";
    userEmail = "diamantonikolas@gmail.com";

    extraConfig = {
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";

      };
      commit = {
        gpgsign = true;
      };

      user.signingKey = "${config.home.homeDirectory}/.ssh/1p_git_signing.pub";
    };
  };
  programs.chromium = {
    enable = true;
    extensions = [
      "aomjjhallfgjeglblehebfpbcfeobpgk" # 1Password
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ];
  };


  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.src/dotfiles-nvim";

  
  home.stateVersion = "25.05"; # Did you read the comment?

}
