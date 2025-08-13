#!/usr/bin/env bash
set -eo pipefail

sort_and_dedupe_path() {
    local path_string="${1:-$PATH}"
    
    # Convert PATH to array, removing empty entries
    IFS=':' read -ra path_array <<< "$path_string"
    
    # Use a simple approach for deduplication and stable sorting
    local seen_paths=""
    local sorted_path=""
    
    # First pass: collect priority paths (home, opt non-homebrew, nix) in order
    for path in "${path_array[@]}"; do
        # Skip empty paths
        [[ -z "$path" ]] && continue
        
        # Skip if already seen (deduplication)
        if [[ ":$seen_paths:" == *":$path:"* ]]; then
            continue
        fi
        
        # Only add high priority paths in this pass
        if [[ "$path" =~ ^~/ ]] || [[ "$path" =~ ^\$HOME/ ]] || [[ "$path" == "$HOME"* ]] || \
           [[ "$path" =~ ^/opt/ && ! "$path" =~ /opt/homebrew ]] || \
           [[ "$path" =~ /nix/ ]] || [[ "$path" =~ \.nix-profile ]] || \
           [[ "$path" == "/run/current-system/sw/bin" ]] || [[ "$path" =~ ^/etc/profiles/per-user/ ]]; then
            seen_paths="$seen_paths:$path"
            sorted_path="${sorted_path:+$sorted_path:}$path"
        fi
    done
    
    # Second pass: add remaining paths in their original order (stable sort)
    for path in "${path_array[@]}"; do
        # Skip empty paths
        [[ -z "$path" ]] && continue
        
        # Skip if already seen (deduplication)
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
        echo "Priority order: Home directories > /opt/* (non-homebrew) > Nix paths > [rest in original order]"
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
