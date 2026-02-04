# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  stylix,
  lib,
  inputs,
  ...
}:

{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.kernelParams = [ "quiet" "splash" ];

  networking.hostName = "chonker"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = {
      base00 = "262626"; # ----
      base01 = "3a3a3a"; # ---
      base02 = "4e4e4e"; # --
      base03 = "8a8a8a"; # -
      base04 = "949494"; # +
      base05 = "dab997"; # ++
      base06 = "d5c4a1"; # +++
      base07 = "ebdbb2"; # ++++
      base08 = "d75f5f"; # red
      base09 = "ff8700"; # orange
      base0A = "ffaf00"; # yellow
      base0B = "afaf00"; # green
      base0C = "85ad85"; # aqua/cyan
      base0D = "83adad"; # blue
      base0E = "d485ad"; # purple
      base0F = "d65d0e";
    };
    polarity = "dark";
    image = ./style/gruvbox/01.jpg;
    fonts = {
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Serif CJK JP";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
  environment.etc."stylix/palette.lua".source =
    let
      c = config.lib.stylix.colors.withHashtag;
    in
    pkgs.writeText "stylix-palette.lua" ''
      return {
        base00 = "${c.base00}",
        base01 = "${c.base01}",
        base02 = "${c.base02}",
        base03 = "${c.base03}",
        base04 = "${c.base04}",
        base05 = "${c.base05}",
        base06 = "${c.base06}",
        base07 = "${c.base07}",
        base08 = "${c.base08}",
        base09 = "${c.base09}",
        base0A = "${c.base0A}",
        base0B = "${c.base0B}",
        base0C = "${c.base0C}",
        base0D = "${c.base0D}",
        base0E = "${c.base0E}",
        base0F = "${c.base0F}",
      }
    '';
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd start-hyprland";
        user = "greeter";
      };
    };
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  /*
      hardware.opengl = {
      enable = true;
        driSupport = true;
        driSupport32Bit = true;
        };
  */

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nikanel = {
    isNormalUser = true;
    description = "Nikolas";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowunfree = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nikanel" ];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    gh
    kitty
    impala
    chromium
    neovim
    networkmanager
    bluetui
    naps2
    xclip
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true; # sets EDITOR=nvim automatically
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome

  ];
  /*
      home-manager = {
                 	extraSpecialArgs = {inherit inputs;};
                 	users = {
                          		"nikanel" = import ../home/home.nix;
                 	};
        };
  */
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
