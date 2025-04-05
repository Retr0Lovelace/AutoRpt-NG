#!/bin/bash

# === CONFIGURATION ===
USER_HOME="$HOME/.autorpt-ng"
TEMPLATE_ROOT="$USER_HOME/templates"
REPORTS_ROOT="$USER_HOME/reports"

list_templates() {
    local templates=($(find "$TEMPLATE_ROOT" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))
    if [ ${#templates[@]} -eq 0 ]; then
        echo "[-] No templates found in $TEMPLATE_ROOT."
    else
        echo "📂 Available templates:"
        printf "%s\n" "${templates[@]}"
    fi
    read -p "↩ Press Enter to continue..."
}

create_report() {
    local templates=($(find "$TEMPLATE_ROOT" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))
    [ ${#templates[@]} -eq 0 ] && echo "[-] No templates found." && return

    local selected=$(printf "%s\n" "${templates[@]}" | fzf --prompt="📚 Choose a template > ")
    [ -z "$selected" ] && echo "[-] Canceled." && return

    read -p "Report name (e.g., thm-Ignite) : " report_name
    dest_dir="$REPORTS_ROOT/$report_name"

    [ -d "$dest_dir" ] && echo "[-] This report already exists." && return
    cp -r "$TEMPLATE_ROOT/$selected" "$dest_dir"
    echo "[+] Report created in: $dest_dir"
    read -p "↩ Press Enter to continue..."
}

list_reports() {
    local selected=$(ls "$REPORTS_ROOT" | fzf --prompt="📁 Choose a report > ")
    [ -z "$selected" ] && echo "[-] Canceled." && return
    local target="$REPORTS_ROOT/$selected"
    echo "[📂] Accessing the report: $target"
    cd "$target" || { echo "[-] Unable to access the folder."; return; }
    bash
}

delete_report() {
    report_name="$1"
    dest_dir="$REPORTS_ROOT/$report_name"
    [ ! -d "$dest_dir" ] && echo "[-] The report '$report_name' does not exist." && return
    rm -rf "$dest_dir"
    echo "[+] Report '$report_name' deleted."
}

archive_report() {
    report_name="$1"
    report_dir="$REPORTS_ROOT/$report_name"
    [ ! -d "$report_dir" ] && echo "[-] The report '$report_name' does not exist." && return
    zip -r "$REPORTS_ROOT/$report_name.zip" "$report_dir"
    echo "[+] Report '$report_name' archived as '$report_name.zip'."
}

main_menu() {
    while true; do
        choice=$(printf "📂 List templates\n📄 Create a new report\n📁 List reports\n🗑️ Delete a report\n📦 Archive a report\n🚪 Quit" | fzf --prompt="📜 Menu > " --height=10 --border --ansi)
        case "$choice" in
            "📂 List templates") list_templates ;;
            "📄 Create a new report") create_report ;;
            "📁 List reports") list_reports ;;
            "🗑️ Delete a report") 
                report_name=$(ls "$REPORTS_ROOT" | fzf --prompt="📁 Choose a report to delete > ")
                delete_report "$report_name" ;;
            "📦 Archive a report") 
                report_name=$(ls "$REPORTS_ROOT" | fzf --prompt="📁 Choose a report to archive > ")
                archive_report "$report_name" ;;
            "🚪 Quit") echo "Bye 👋" && exit 0 ;;
            *) echo "Invalid choice." && sleep 1 ;;
        esac
    done
}

# === BATCH MODE ===
if [ $# -gt 0 ]; then
    case "$1" in
        --help)
            echo "Usage : $0 <action> <template> <report_name>"
            echo "Available actions:"
            echo "  create   Create a report from a template."
            echo "  list     List templates or reports."
            echo "  delete   Delete a report."
            echo "  archive  Archive a report as .zip."
            exit 0
            ;;
        create)
            template_name="$2"
            report_name="$3"
            if [ -z "$template_name" ] || [ -z "$report_name" ]; then
                echo "[-] Error: Missing parameters."
                exit 1
            fi
            dest_dir="$REPORTS_ROOT/$report_name"
            [ -d "$dest_dir" ] && echo "[-] The report already exists: $dest_dir" && exit 1
            [ ! -d "$TEMPLATE_ROOT/$template_name" ] && echo "[-] Template not found: $template_name" && exit 1
            cp -r "$TEMPLATE_ROOT/$template_name" "$dest_dir"
            echo "[+] Report '$report_name' created from '$template_name'."
            exit 0
            ;;
        delete)
            report_name="$2"
            [ -z "$report_name" ] && echo "[-] Missing report name to delete." && exit 1
            delete_report "$report_name"
            exit 0
            ;;
        archive)
            report_name="$2"
            [ -z "$report_name" ] && echo "[-] Missing report name to archive." && exit 1
            archive_report "$report_name"
            exit 0
            ;;
        list)
            if [ "$2" == "template" ]; then
                list_templates
            elif [ "$2" == "report" ]; then
                list_reports
            else
                echo "[-] Missing or incorrect argument."
                exit 1
            fi
            exit 0
            ;;
        *)
            echo "[-] Unknown command: $1"
            exit 1
            ;;
    esac
fi

main_menu