#!/bin/bash

TARGET_LINE='export SDL_VIDEODRIVER=x11'
PATCHED=0

CURRENT_PATH="$PWD"

# Asks if u wanna use installed path or select a custom directory
zenity --question --title="Ren'Py Wayland Patcher" \
  --text="Use current path?\n\n$CURRENT_PATH" --modal
response=$?

if [ $response -eq 0 ]; then
  DIR="$CURRENT_PATH"
else
  DIR=$(zenity --file-selection --directory --title="Select directory to scan" --filename="$CURRENT_PATH/" --modal)
  if [[ $? -ne 0 || -z "$DIR" ]]; then
    exit 0
  fi
fi

# Find all .sh scripts recursively
mapfile -t ALL_SH < <(find "$DIR" -type f -name "*.sh")

if [ ${#ALL_SH[@]} -eq 0 ]; then
    zenity --error --title="Ren'Py Wayland Patcher" --text="No valid .sh files found at location." --modal
    exit 1
fi

# Checks if they have da fukkin x11 export
MISSING=()
for file in "${ALL_SH[@]}"; do
    if ! head -n 10 "$file" | grep -qF "$TARGET_LINE"; then
        MISSING+=("$file")
    fi
done

if [ ${#MISSING[@]} -eq 0 ]; then
    zenity --info --title="Ren'Py Wayland Patcher" --text=" All Ren'Py scripts are already patched." --modal
    exit 0
fi

ZENITY_ENTRIES=("FALSE" "Select All")
for file in "${MISSING[@]}"; do
    ZENITY_ENTRIES+=("FALSE" "$file")
done

# Shows a checklist of the unpatched shit
SELECTED=$(zenity --list --title="Ren'Py Wayland Patcher" \
    --text="Select scripts to patch (check 'Select All' to patch all):" \
    --checklist \
    --column="Select" --column="Script Path" \
    "${ZENITY_ENTRIES[@]}" \
    --width=900 --height=450 --modal --window-icon="utilities-terminal")

if [[ -z "$SELECTED" ]]; then
    exit 0
fi

IFS='|' read -ra SELECTED_ARR <<< "$SELECTED"

# If Select All is selected, patch all missing scripts
PATCH_ALL=false
FILES=()

for item in "${SELECTED_ARR[@]}"; do
    if [[ "$item" == "Select All" ]]; then
        PATCH_ALL=true
        break
    fi
done

if $PATCH_ALL; then
    FILES=("${MISSING[@]}")
else
    for item in "${SELECTED_ARR[@]}"; do
        if [[ "$item" != "Select All" ]]; then
            FILES+=("$item")
        fi
    done
fi

for file in "${FILES[@]}"; do
    echo "Patching: $file" >&2  # debug output to stderr

    # Check write permission
    if [ ! -w "$file" ]; then
        echo "Warning: no write permission for $file" >&2
        continue
    fi

    tmpfile=$(mktemp) || { echo "Failed to create temp file" >&2; exit 1; }
    first_line=$(head -n 1 "$file")

    if [[ "$first_line" == \#!* ]]; then
        {
            echo "$first_line"
            echo "$TARGET_LINE"
            tail -n +2 "$file"
        } > "$tmpfile"
    else
        {
            echo "$TARGET_LINE"
            cat "$file"
        } > "$tmpfile"
    fi

    mv -f "$tmpfile" "$file" || { echo "Failed to overwrite $file" >&2; exit 1; }
    chmod +x "$file"
    ((PATCHED++))
done

if [ $PATCHED -gt 0 ]; then
    zenity --info --title="Ren'Py Wayland Patcher" --text="Successfully patched $PATCHED script(s)!" --modal
else
    zenity --error --title="Ren'Py Wayland Patcher" --text="No scripts were patched." --modal
fi
