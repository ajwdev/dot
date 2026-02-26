# Java Development Setup with Neovim

This document describes the Java development setup using nvim-jdtls in Neovim.

## Overview

The setup uses [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) to provide Java LSP functionality in Neovim. It's configured to work with multiple installation methods and is optimized for Gradle projects like tn-nftitus.

## Installation

### Current Status
You currently have jdtls installed via Homebrew at `/opt/homebrew/opt/jdtls/libexec/`.

### Option 1: Continue Using Homebrew (Current Setup)
```bash
# Already installed - no action needed
brew list jdtls
```

### Option 2: Switch to Nix (Recommended)
To manage jdtls via Nix home-manager:

1. Copy the example config:
   ```bash
   cd ~/dot/home-manager
   cp work-config.nix.example work-config.nix
   ```

2. Edit `home-manager/home.nix` and add to imports:
   ```nix
   imports = [
     ./config.nix
     ./dotfiles.nix
     ./devtools.nix
     ./gui.nix
     ./work-config.nix  # Add this line
   ];
   ```

3. The work-config.nix file will enable Java tools:
   ```nix
   devtools.java.enable = true;
   ```

4. Rebuild your home-manager configuration:
   ```bash
   home-manager switch --flake ~/dot#andrew
   ```

This will install:
- JDK (Java Development Kit)
- jdt-language-server (Eclipse JDT Language Server)
- Gradle
- Maven

## Configuration Files

- **Plugin declaration**: `dotfiles/nvim/lua/plugins/lsp.lua`
  - Adds nvim-jdtls as a lazy-loaded plugin for Java files

- **Java filetype plugin**: `dotfiles/nvim/after/ftplugin/java.lua`
  - Configures jdtls when opening Java files
  - Sets Java-specific options (4-space indentation)
  - Detects jdtls installation (Homebrew → Nix → Mason)
  - Configures LSP with blink.cmp integration
  - Sets up Java-specific keymaps

## Features

### Code Intelligence
- **Completion**: Context-aware code completion via blink.cmp
- **Go to definition**: `gd` to jump to symbol definition
- **Find references**: `grr` to list all references
- **Hover documentation**: `K` to show documentation
- **Signature help**: `<C-k>` to show function signatures
- **Rename**: `grn` to rename symbol across project
- **Code actions**: `gra` for quick fixes and refactorings

### Java-Specific Keymaps
All Java-specific keymaps use the `<leader>j` prefix:

- `<leader>jo` - Organize imports
- `<leader>jv` - Extract variable (normal/visual mode)
- `<leader>jc` - Extract constant (normal/visual mode)
- `<leader>jm` - Extract method (visual mode)
- `<leader>jt` - Run nearest test method
- `<leader>jT` - Run all tests in class

### Code Formatting
- Uses Google Java Style Guide
- Format on save can be enabled via LSP
- Manual format: Use standard LSP format command

### Advanced Features
- **Inlay hints**: Shows parameter names and types inline
  - Toggle with `<leader>th`
- **Code lenses**: Shows test run options and implementations
- **Decompiler**: Can view source of external dependencies
- **Auto-import**: Suggests imports for unresolved symbols

## Project-Specific Configuration

### Gradle Projects (like tn-nftitus)
The configuration automatically detects Gradle projects by looking for:
- `gradlew` in project root
- `build.gradle` files
- `.git` directory

Each project gets its own workspace at:
```
~/.local/share/eclipse/<project-name>/
```

### Multi-Module Projects
The setup supports Gradle multi-module projects. JDTLS will:
- Detect all submodules automatically
- Provide cross-module navigation
- Handle inter-module dependencies

## Common Issues

### "Couldn't retrieve source path settings" or Module Errors

This error occurs when jdtls can't properly sync the Gradle project. **Fix it:**

```bash
# Quick fix - clears workspace and rebuilds
~/dot/bin/fix-jdtls-workspace

# Or manually:
cd ~/src/github.netflix.net/corp/tn-nftitus
./gradlew build -x test  # Build project first
rm -rf ~/.local/share/eclipse/tn-nftitus  # Clear workspace
# Then restart Neovim
```

**In Neovim:**
```vim
:JdtClearWorkspace   " Clear workspace and restart
:JdtUpdateConfig     " Force jdtls to resync project
```

**Why this happens:**
- jdtls needs Gradle to resolve the project structure first
- Multi-module Gradle projects require all modules to be built
- Workspace cache can become stale

## Troubleshooting

### JDTLS Not Starting
1. Check if jdtls is installed:
   ```bash
   # Homebrew
   brew list jdtls

   # Nix
   which jdtls
   ```

2. Check Neovim logs:
   ```vim
   :messages
   :LspLog
   ```

3. Verify Java installation:
   ```bash
   java -version  # Should show Java 21+
   echo $JAVA_HOME  # Should point to JDK
   ```

### Performance Issues
- JDTLS can be memory-intensive for large projects
- Workspace is cached per-project in `~/.local/share/eclipse/`
- Clear workspace to reset: `rm -rf ~/.local/share/eclipse/<project>/`

### Import Issues
- Use `<leader>jo` to organize imports
- Check that Gradle sync completed successfully
- Verify `build.gradle` doesn't have errors

### Code Completion Not Working
1. Ensure blink.cmp is loaded: `:checkhealth blink`
2. Verify LSP attached: `:LspInfo`
3. Check capabilities: `:lua =vim.lsp.get_active_clients()[1].server_capabilities`

## Testing

To test the setup:
1. Open a Java file in the tn-nftitus project:
   ```bash
   cd ~/src/github.netflix.net/corp/tn-nftitus
   nvim nftitus-gateway/src/main/java/com/netflix/titus/gateway/service/v2/V2EngineTitusServiceGateway.java
   ```

2. Wait for JDTLS to initialize (watch statusline)
3. Try hovering over a symbol with `K`
4. Try go-to-definition with `gd`
5. Try code completion by typing and waiting for suggestions

## Additional Resources

- [nvim-jdtls GitHub](https://github.com/mfussenegger/nvim-jdtls)
- [Eclipse JDT.LS Documentation](https://github.com/eclipse/eclipse.jdt.ls)
- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
