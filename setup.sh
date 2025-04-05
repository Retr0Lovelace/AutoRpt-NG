#!/bin/bash

# === CONFIGURATION ===
PROJECT_NAME="AutoRpt-NG"
USER_HOME="$HOME/.autorpt-ng"
TEMPLATE_DIR="$USER_HOME/templates"
REPORTS_DIR="$USER_HOME/reports"
BIN_DIR="/usr/local/bin"   # Binary installation directory
SCRIPT_FILE="$PWD/src/autorpt-ng.sh" # Main script to install

# Dependency check
check_dep() {
    command -v "$1" &>/dev/null || {
        echo "[-] '$1' is required. Install it with: sudo apt install $1"
        return 1
    }
}

# Install necessary dependencies
install_deps() {
    echo "[+] Checking dependencies..."
    
    check_dep "fzf" || {
        echo "[+] Installing fzf..."
        sudo apt install -y fzf
    }

    check_dep "zip" || {
        echo "[+] Installing zip..."
        sudo apt install -y zip
    }

    check_dep "date" || {
        echo "[+] Installing date..."
        sudo apt install -y coreutils
    }
}

# Create necessary directories
init_dirs() {
    echo "[+] Initializing directories..."

    # Templates folder
    if [ ! -d "$TEMPLATE_DIR" ]; then
        echo "[+] Creating templates folder: $TEMPLATE_DIR"
        mkdir -p "$TEMPLATE_DIR"
    fi

    # Reports folder
    if [ ! -d "$REPORTS_DIR" ]; then
        echo "[+] Creating reports folder: $REPORTS_DIR"
        mkdir -p "$REPORTS_DIR"
    fi
}

# Create basic templates
init_templates() {
    echo "[+] Initializing templates..."

    # Create default templates
    mkdir -p "$TEMPLATE_DIR"/{tryhackme,hackthebox,certif}

    echo "# TryHackMe Report

## Enum
## Exploit
## Post
" > "$TEMPLATE_DIR/tryhackme/README.md"
    mkdir -p "$TEMPLATE_DIR/tryhackme/images"

    echo "# Hack The Box Report

## Recon
## Initial Access
## Privesc
" > "$TEMPLATE_DIR/hackthebox/README.md"
    mkdir -p "$TEMPLATE_DIR/hackthebox/images"

    echo "# Certification Report

## Intro
## Targets
## Findings
" > "$TEMPLATE_DIR/certif/README.md"
    mkdir -p "$TEMPLATE_DIR/certif/images"

    echo "[+] Templates created in: $TEMPLATE_DIR"
}

# Start installation
install() {
    echo "[+] Starting installation for $PROJECT_NAME"

    # Check and install dependencies
    install_deps

    # Create working directories if necessary
    init_dirs

    # Create templates if the folder is empty
    if [ ! -d "$TEMPLATE_DIR" ] || [ -z "$(ls -A "$TEMPLATE_DIR")" ]; then
        init_templates
    fi

    # Check if the main script exists
    if [ ! -f "$SCRIPT_FILE" ]; then
        echo "[-] The script file '$SCRIPT_FILE' was not found."
        exit 1
    fi

    # Move the script to the global binary directory
    echo "[+] Moving the main script to $BIN_DIR/autorpt-ng"
    sudo cp "$SCRIPT_FILE" "$BIN_DIR/autorpt-ng"

    # Add execute permissions
    sudo chmod +x "$BIN_DIR/autorpt-ng"

    echo "[+] Installation completed!"
    echo "[+] You can now use the script with: autorpt-ng"
}

# Run installation
install