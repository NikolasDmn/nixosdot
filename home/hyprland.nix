{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;

        # --- MODULE ORDER ---
        modules-left = [ "clock" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "network"
          "pulseaudio"
          "bluetooth"
          "cpu"
          "tray"
          "battery"
        ];

        # --- MODULE CONFIGURATION ---
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "default" = "";
            "active" = "";
            "urgent" = "";
          };
          on-click = "activate";
          persistent-workspaces = {
            "*" = 5; # Show at least 5 workspaces
          };
        };

        clock = {
          format = "{:%H:%M  %a %d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname} ";
          format-disconnected = "Disconnected ⚠";
          on-click = "impala";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = " Muted";
          format-icons = {
            default = [
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} ({power}W)";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        bluetooth = {
          format = " {status}";
          format-disabled = "";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        tray = {
          spacing = 10;
        };
      }
    ];
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 0;
        no_fade_in = false;
      };
      background = {
        blur_passes = 3;
        blur_size = 8;
      };
      label = {
        text = "Locked";
        font_size = 32;
        position = "0, 80";
        halign = "center";
        valign = "center";
      };
      input-field = {
        size = "300, 50";
        position = "0, 0";
        halign = "center";
        valign = "center";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "${pkgs.hyprlock}/bin/hyprlock";
        after_sleep_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 900;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
    settings = {
      env = [
          "NVD_BACKEND,direct"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        ];
      monitor = [
        "HDMI-A-1,1920x1080@60,-1920x0,1"
        "eDP-1,1920x1080@60,0x682,1,sdrbrightness,1.0"
      ];
      input = {
        kb_options = [
          "caps:swapescape"
        ];
      };
      "$mod" = "SUPER";
    bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    bind = [

      "$mod, RETURN, exec, kitty"
      "$mod, W, killactive"
      "$mod, B, exec, chromium-browser"
      "$mod, SPACE, exec, walker"
      "$mod, M, exec, ~/.config/hypr/scripts/toggle-mirror.sh"
      "$mod, V, togglefloating"

      # Workspaces on primary display

      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"

      # Workspaces on secondary display (11-15)
      "$mod CTRL, 1, workspace, 11"
      "$mod CTRL, 2, workspace, 12"
      "$mod CTRL, 3, workspace, 13"
      "$mod CTRL, 4, workspace, 14"
      "$mod CTRL, 5, workspace, 15"

      # Cycle through workspaces with CTRL + $mod + h/l
      "$mod CTRL, h, workspace, e-1"
      "$mod CTRL, l, workspace, e+1"

      # Move window to workspace (primary)
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"

      # Move window to workspace (secondary)
      "$mod SHIFT CTRL, 1, movetoworkspace, 11"
      "$mod SHIFT CTRL, 2, movetoworkspace, 12"
      "$mod SHIFT CTRL, 3, movetoworkspace, 13"
      "$mod SHIFT CTRL, 4, movetoworkspace, 14"
      "$mod SHIFT CTRL, 5, movetoworkspace, 15"

      # Focus movement (vim keys)
      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"

      # Move windows (vim keys)
      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, L, movewindow, r"
      "$mod SHIFT, K, movewindow, u"
      "$mod SHIFT, J, movewindow, d"

      # Resize windows with $mod + arrow keys
      "$mod, left, resizeactive, -20 0"
      "$mod, right, resizeactive, 20 0"
      "$mod, up, resizeactive, 0 -20"
      "$mod, down, resizeactive, 0 20"

      # Volume + brightness controls
      "$mod, equal, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      "$mod, minus, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      "$mod SHIFT, equal, exec, brightnessctl s 10%+"
      "$mod SHIFT, minus, exec, brightnessctl s 10%-"
    ];
    workspace = [
        "1,monitor:HDMI-A-1"
        "2,monitor:HDMI-A-1"
        "3,monitor:HDMI-A-1"
        "4,monitor:HDMI-A-1"
        "5,monitor:HDMI-A-1"
        "6,monitor:HDMI-A-1"
        "7,monitor:HDMI-A-1"
        "8,monitor:HDMI-A-1"
        "9,monitor:HDMI-A-1"
        "10,monitor:HDMI-A-1"

        "11,monitor:eDP-1"
        "12,monitor:eDP-1"
        "13,monitor:eDP-1"
        "14,monitor:eDP-1"
        "15,monitor:eDP-1"
        "16,monitor:eDP-1"
        "17,monitor:eDP-1"
        "18,monitor:eDP-1"
        "19,monitor:eDP-1"
        "20,monitor:eDP-1"
      ];

      decoration = {
        rounding = 4;
        inactive_opacity = 0.7;
        blur = {
          enabled = true;
          size = 8;
          passes = 4;
        };
      };
    };
  };

}
