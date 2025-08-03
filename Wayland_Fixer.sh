#!/bin/bash

TARGET_LINE='export SDL_VIDEODRIVER=x11'
missing_count=0

for dir in */; do
    [ -d "$dir" ] || continue
    for file in "$dir"*.sh; do
        [ -f "$file" ] || continue

        # Check if target line exists in the first 10 lines
        if ! head -n 10 "$file" | grep -qF "$TARGET_LINE"; then
            echo "Missing SDL_VIDEODRIVER in: $file"
            read -rp "Add line to $file? [Y/N]: " response
            case "$response" in
                [Yy]* )
                    tmpfile=$(mktemp)
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
                    mv "$tmpfile" "$file"
                    chmod +x "$file"
                    echo "✅ Added to $file"
                    ;;
                * )
                    echo "❌ Skipped $file"
                    ;;
            esac
            ((missing_count++))
        fi
    done
done

if [ "$missing_count" -eq 0 ]; then
    echo "✅ All .sh files already contain SDL_VIDEODRIVER in the first 10 lines. Nothing to do."
fi

