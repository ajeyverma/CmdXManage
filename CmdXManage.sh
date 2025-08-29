#!/bin/bash
# ===================================================
# CmdXManage.sh - Custom Command Manager for Linux/Mac
# Author: Aarush Chaudhary
# Version: 1.0
# GitHub: https://github.com/AjeyVerma
# ===================================================

# --- Detect user shell and set profile file ---
if [ -n "$ZSH_VERSION" ]; then
    PROFILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    PROFILE="$HOME/.bashrc"
else
    PROFILE="$HOME/.profile"
fi

BACKUP_DIR="$HOME/.cmdxmanage_backups"
mkdir -p "$BACKUP_DIR"

# --- Functions ---

add_command() {
    read -p "Enter command name: " name
    read -p "Enter command to run: " cmd

    # Backup profile
    cp "$PROFILE" "$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)_profile.bak"

    # Check if alias already exists
    if grep -q "alias $name=" "$PROFILE"; then
        echo "❌ Alias '$name' already exists!"
        return
    fi

    echo "alias $name='$cmd'" >> "$PROFILE"
    echo "✅ Alias '$name' added."
    source "$PROFILE"
}

remove_command() {
    read -p "Enter command name to remove: " name

    # Backup
    cp "$PROFILE" "$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)_profile.bak"

    if grep -q "alias $name=" "$PROFILE"; then
        sed -i.bak "/alias $name=/d" "$PROFILE"
        echo "✅ Alias '$name' removed."
        source "$PROFILE"
    else
        echo "❌ Alias '$name' not found."
    fi
}

view_commands() {
    echo "📜 Saved aliases in $PROFILE:"
    grep "^alias " "$PROFILE" | sed 's/^alias //'
}

export_commands() {
    read -p "Enter folder path to export: " folder
    mkdir -p "$folder"
    grep "^alias " "$PROFILE" > "$folder/aliases.sh"
    echo "✅ Aliases exported to $folder/aliases.sh"
}

import_commands() {
    read -p "Enter folder path to import from: " folder
    if [ ! -f "$folder/aliases.sh" ]; then
        echo "❌ No aliases.sh found in $folder"
        return
    fi

    # Backup
    cp "$PROFILE" "$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)_profile.bak"

    while read -r line; do
        if [[ $line == alias* ]]; then
            name=$(echo "$line" | cut -d= -f1 | awk '{print $2}')
            # Remove duplicate if exists
            sed -i.bak "/alias $name=/d" "$PROFILE"
            echo "$line" >> "$PROFILE"
        fi
    done < "$folder/aliases.sh"

    echo "✅ Aliases imported successfully."
    source "$PROFILE"
}

# --- Menu ---
while true; do
    clear
    echo "=============================="
    echo "   CmdXManage - Linux/Mac"
    echo "=============================="
    echo "1. Add Command"
    echo "2. Remove Command"
    echo "3. View Commands"
    echo "4. Export Commands"
    echo "5. Import Commands"
    echo "6. Exit"
    echo "=============================="
    read -p "Choose an option: " choice

    case $choice in
        1) add_command ;;
        2) remove_command ;;
        3) view_commands ;;
        4) export_commands ;;
        5) import_commands ;;
        6) echo "👋 Goodbye!"; exit ;;
        *) echo "❌ Invalid choice"; sleep 1 ;;
    esac
    read -p "Press Enter to continue..."
done
