{ config, lib, pkgs, ... }:

{
  home.activation.installObsidianPlugins = let
    pluginScript = pkgs.writeShellScript "install-obsidian-plugins" ''
      echo "Setting up Obsidian plugins..."
      
      OBSIDIAN_PLUGINS_DIR="$HOME/Library/Application Support/obsidian/plugins"
      mkdir -p "$OBSIDIAN_PLUGINS_DIR"
      
      install_plugin() {
        local plugin_name=$1
        local plugin_id=$2
        local plugin_url=$3
        local plugin_dir="$OBSIDIAN_PLUGINS_DIR/$plugin_name"
        
        if [ ! -d "$plugin_dir" ]; then
          echo "Installing $plugin_name..."
          mkdir -p "$plugin_dir"
          ${pkgs.curl}/bin/curl -L "$plugin_url" -o "$plugin_dir/main.js"
          
          # Create proper manifest.json with correct plugin ID
          cat > "$plugin_dir/manifest.json" << EOF
{
  "id": "$plugin_id",
  "name": "$plugin_name",
  "version": "1.0.0",
  "minAppVersion": "0.15.0",
  "description": "Automatically installed plugin",
  "author": "Community Developer",
  "authorUrl": "https://obsidian.md",
  "isDesktopOnly": false
}
EOF
        else
          echo "$plugin_name already installed"
        fi
      }
      
      # Community plugins with correct IDs
      install_plugin "obsidian-tasks-plugin" "obsidian-tasks-plugin" "https://github.com/obsidian-tasks-group/obsidian-tasks-plugin/releases/latest/download/main.js"
      install_plugin "calendar" "calendar" "https://github.com/liamcain/obsidian-calendar-plugin/releases/latest/download/main.js"
      install_plugin "templater-obsidian" "templater-obsidian" "https://github.com/SilentVoid13/Templater/releases/latest/download/main.js"
      install_plugin "remotely-save" "remotely-save" "https://github.com/remotely-save/remotely-save/releases/latest/download/main.js"
      install_plugin "periodic-notes" "periodic-notes" "https://github.com/liamcain/obsidian-periodic-notes/releases/latest/download/main.js"
      install_plugin "highlightr-plugin" "highlightr-plugin" "https://github.com/chetachiezikeuzor/Highlightr-Plugin/releases/latest/download/main.js"
      
      echo "Obsidian plugins installed successfully!"
      
      # Also create community-plugins.json to force Obsidian to recognize them
      cat > "$OBSIDIAN_PLUGINS_DIR/community-plugins.json" << EOF
[
  "obsidian-tasks-plugin",
  "calendar",
  "templater-obsidian",
  "remotely-save",
  "periodic-notes",
  "highlightr-plugin"
]
EOF
    '';
  in lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "/Applications/Obsidian.app" ]; then
      ${pluginScript}
    else
      echo "Obsidian not installed yet. Run 'brew install --cask obsidian' first."
    fi
  '';
}
