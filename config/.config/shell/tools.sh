# Standalone tools and fnm, shared by interactive Bash and Zsh.
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$HOME/.opencode/bin:$HOME/.local/share/fnm:$PATH"
# Omarchy's packaged bootstrap still adds this directory. Remove it locally.
PATH=$(printf '%s' "$PATH" | tr ':' '\n' | awk -v old="$HOME/.local/share/mise/shims" '$0 != old' | paste -sd: -)
export PATH
if command -v fnm >/dev/null 2>&1; then
    if [ -n "${ZSH_VERSION:-}" ]; then
        eval "$(fnm env --use-on-cd --version-file-strategy recursive --resolve-engines --shell zsh)"
    else
        eval "$(fnm env --use-on-cd --version-file-strategy recursive --resolve-engines --shell bash)"
    fi
    _user_fnm_switch() {
        local search_dir="$PWD" version
        while :; do
            if [ -f "$search_dir/.nvmrc" ] || [ -f "$search_dir/.node-version" ]; then
                fnm use --install-if-missing --silent-if-unchanged
                return
            fi
            if [ -f "$search_dir/.node_version" ]; then
                version=$(tr -d '[:space:]' < "$search_dir/.node_version")
                fnm use --install-if-missing --silent-if-unchanged "$version"
                return
            fi
            if [ -f "$search_dir/package.json" ] && /usr/bin/python -c 'import json,sys; sys.exit(not json.load(open(sys.argv[1])).get("engines",{}).get("node"))' "$search_dir/package.json" 2>/dev/null; then
                fnm use --install-if-missing --silent-if-unchanged
                return
            fi
            [ "$search_dir" = / ] && break
            search_dir=$(dirname "$search_dir")
        done
        fnm use --log-level error --silent-if-unchanged default
    }
    _fnm_autoload_hook() { _user_fnm_switch; }
    __fnm_use_if_file_found() { _user_fnm_switch; }
    _user_fnm_switch
fi
