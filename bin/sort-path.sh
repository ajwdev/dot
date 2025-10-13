#!/usr/bin/env bash
set -eo pipefail

sort_and_dedupe_path() {
    local path_string="${1:-$PATH}"
    
    # Convert PATH to array, removing empty entries
    IFS=':' read -ra path_array <<< "$path_string"
    
    # Use multiple passes for deduplication and priority-based sorting
    local seen_paths=""
    local sorted_path=""

    # Pass 1: Home directories (highest user priority)
    for path in "${path_array[@]}"; do
        [[ -z "$path" ]] && continue
        if [[ ":$seen_paths:" == *":$path:"* ]]; then
            continue
        fi

        if [[ "$path" == "$HOME"* ]]; then
            seen_paths="$seen_paths:$path"
            sorted_path="${sorted_path:+$sorted_path:}$path"
        fi
    done

    # Pass 2: /opt/* (excluding homebrew)
    for path in "${path_array[@]}"; do
        [[ -z "$path" ]] && continue
        if [[ ":$seen_paths:" == *":$path:"* ]]; then
            continue
        fi

        if [[ "$path" =~ ^/opt/ && "$path" != *"/opt/homebrew"* ]]; then
            seen_paths="$seen_paths:$path"
            sorted_path="${sorted_path:+$sorted_path:}$path"
        fi
    done

    # Pass 3: /run/wrappers/bin (wrapped executables - must come before other system paths)
    for path in "${path_array[@]}"; do
        [[ -z "$path" ]] && continue
        if [[ ":$seen_paths:" == *":$path:"* ]]; then
            continue
        fi

        if [[ "$path" == "/run/wrappers/bin" ]]; then
            seen_paths="$seen_paths:$path"
            sorted_path="${sorted_path:+$sorted_path:}$path"
        fi
    done

    # Pass 4: Other Nix/NixOS system paths
    for path in "${path_array[@]}"; do
        [[ -z "$path" ]] && continue
        if [[ ":$seen_paths:" == *":$path:"* ]]; then
            continue
        fi

        if [[ "$path" =~ /nix/ ]] || [[ "$path" =~ \.nix-profile ]] || \
           [[ "$path" == "/run/current-system/sw/bin" ]] || [[ "$path" =~ ^/etc/profiles/per-user/ ]]; then
            seen_paths="$seen_paths:$path"
            sorted_path="${sorted_path:+$sorted_path:}$path"
        fi
    done

    # Final pass: add all remaining paths in their original order
    for path in "${path_array[@]}"; do
        [[ -z "$path" ]] && continue
        if [[ ":$seen_paths:" == *":$path:"* ]]; then
            continue
        fi

        seen_paths="$seen_paths:$path"
        sorted_path="${sorted_path:+$sorted_path:}$path"
    done
    
    echo "$sorted_path"
}

# Main execution
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [--dry-run|-p|--help]"
        echo ""
        echo "Default: Output export statement to eval"
        echo ""
        echo "Options:"
        echo "  --dry-run    Show before/after comparison"
        echo "  -p           Print sorted PATH only (no export)"
        echo "  --help       Show this help message"
        echo ""
        echo "Priority order: Home directories > /opt/* (non-homebrew) > /run/wrappers/bin > Nix paths > [rest in original order]"
        echo "Uses stable sort to preserve existing order for non-priority paths"
        ;;
    --dry-run)
        echo "Current PATH:"
        echo "$PATH" | tr ':' '\n' | nl
        echo ""
        echo "Sorted and deduplicated PATH would be:"
        sort_and_dedupe_path "$PATH" | tr ':' '\n' | nl
        ;;
    -p)
        sort_and_dedupe_path "$PATH"
        ;;
    "")
        # Default: output export statement
        new_path=$(sort_and_dedupe_path "$PATH")
        echo "export PATH=\"$new_path\""
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
