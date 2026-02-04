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
    clang-tools
    gcc
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

    walker

    pavucontrol
    blueman
    networkmanagerapplet
    playerctl

  ];
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake /etc/nixos";
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
      };
      commit = {
        gpgsign = true;
      };

      user = {
        signingKey = "...";
      };
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
