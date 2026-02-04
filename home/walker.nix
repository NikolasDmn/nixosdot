
{ pkgs, ... }:

let
  themeName = "tui";
in
{
  home.packages = [ pkgs.walker ];

  xdg.configFile."walker/config.toml".text = ''
    # Minimal config; Walker will read this from ~/.config/walker/config.toml
    theme = "${themeName}"

    # Optional QoL
    # close_on_select = true
    # fuzzy = true
  '';

  # GTK CSS theme: ~/.config/walker/themes/tui/style.css
  xdg.configFile."walker/themes/${themeName}/style.css".text = ''
    /* TUI-ish: compact, mono, sharp borders */
    window {
      border: 2px solid rgba(235, 219, 178, 0.65); /* gruvbox-ish light */
      border-radius: 6px;
    }

    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 13px;
    }

    /* Main container padding */
    .root, .container, box {
      padding: 6px;
    }

    /* Search entry */
    entry {
      background: rgba(38, 38, 38, 0.95);
      color: rgba(235, 219, 178, 1.0);
      border: 1px solid rgba(148, 148, 148, 0.35);
      border-radius: 4px;
      padding: 6px 8px;
      caret-color: rgba(255, 175, 0, 1.0);
    }

    /* List */
    list, .list {
      background: transparent;
      padding: 4px 0;
    }

    /* Rows/items */
    row, .item {
      background: transparent;
      border-radius: 4px;
      padding: 5px 8px;
    }

    /* Selected row */
    row:selected, .item:selected, row:hover, .item:hover {
      background: rgba(58, 58, 58, 0.85);
      color: rgba(235, 219, 178, 1.0);
    }

    /* Subtle separators if present */
    separator {
      background: rgba(148, 148, 148, 0.18);
      margin: 4px 0;
    }
  '';
}
