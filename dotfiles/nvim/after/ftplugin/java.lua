-- Java filetype configuration with jdtls setup

-- Set Java-specific options
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

-- Only proceed with jdtls setup if the plugin is available
local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
  return
end

-- Determine OS for jdtls config
local home = os.getenv("HOME")
local jdtls_path = nil
local launcher_jar = ""

-- Function to find jdtls installation
local function find_jdtls()
  -- Try homebrew path on macOS
  local homebrew_jdtls = "/opt/homebrew/opt/jdtls/libexec"
  if vim.fn.isdirectory(homebrew_jdtls) == 1 then
    local jar = vim.fn.glob(homebrew_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    if jar ~= "" then
      return homebrew_jdtls, jar
    end
  end

  -- Try nix profile path (jdt-language-server package)
  local nix_jdtls = home .. "/.nix-profile/share/java"
  if vim.fn.isdirectory(nix_jdtls) == 1 then
    local jar = vim.fn.glob(nix_jdtls .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
    if jar ~= "" then
      return nix_jdtls .. "/jdtls", jar
    end
    -- Also try the jdt-language-server structure
    jar = vim.fn.glob(nix_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    if jar ~= "" then
      return nix_jdtls, jar
    end
  end

  -- Try mason installation
  local mason_jdtls = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  if vim.fn.isdirectory(mason_jdtls) == 1 then
    local jar = vim.fn.glob(mason_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    if jar ~= "" then
      return mason_jdtls, jar
    end
  end

  return nil, ""
end

jdtls_path, launcher_jar = find_jdtls()

if not jdtls_path or launcher_jar == "" then
  vim.notify(
    "jdtls not found. Install via homebrew (brew install jdtls) or enable in home-manager (devtools.java.enable = true)",
    vim.log.levels.WARN
  )
  return
end

-- Determine platform config directory
local platform
if vim.fn.has("mac") == 1 then
  platform = "mac"
elseif vim.fn.has("unix") == 1 then
  platform = "linux"
elseif vim.fn.has("win32") == 1 then
  platform = "win"
else
  platform = "linux"
end

local config_dir = jdtls_path .. "/config_" .. platform

-- Data directory - separate workspace per project
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

-- Get capabilities from blink.cmp (same as other LSP servers)
local capabilities = require("blink.cmp").get_lsp_capabilities({
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
      },
    },
  },
})

-- Determine Java version in use and JAVA_HOME
local java_cmd = "java"
local java_home = os.getenv("JAVA_HOME")

-- If JAVA_HOME is not set, try to detect it
if not java_home or java_home == "" then
  -- On macOS, use java_home utility
  if vim.fn.has("mac") == 1 then
    local handle = io.popen("/usr/libexec/java_home 2>/dev/null")
    if handle then
      java_home = handle:read("*l")
      handle:close()
    end
  elseif vim.fn.has("unix") == 1 then
    -- On Linux, try to find via readlink
    local handle = io.popen("readlink -f $(which java) 2>/dev/null")
    if handle then
      local java_path = handle:read("*l")
      handle:close()
      if java_path then
        -- Remove /bin/java to get JAVA_HOME
        java_home = java_path:gsub("/bin/java$", "")
      end
    end
  end
end

if java_home and java_home ~= "" then
  java_cmd = java_home .. "/bin/java"
end

-- Extended client capabilities for jdtls
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Main jdtls configuration
local config = {
  -- Command to start jdtls
  cmd = {
    java_cmd,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher_jar,
    "-configuration",
    config_dir,
    "-data",
    workspace_dir,
  },

  -- Language server root directory detection
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

  -- Add handlers to suppress common noise
  handlers = {
    ["language/status"] = function(_, result)
      -- Suppress status messages to reduce noise
    end,
  },

  -- Settings for jdtls
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        -- Detect runtimes automatically
        runtimes = java_home and {
          {
            name = "JavaSE-25",
            path = java_home,
            default = true,
          },
        } or nil,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          -- Use Google Java Style Guide
          url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" }, -- Decompiler
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.Assert.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
          "org.assertj.core.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
        importOrder = {
          "#", -- static imports
          "", -- blank line
          "java",
          "javax",
          "org",
          "com",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
      -- Inlay hints (Java 21+)
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
    },
  },

  -- Flags
  flags = {
    allow_incremental_sync = true,
  },

  -- Initialize jdtls specific options
  init_options = {
    bundles = {},
    extendedClientCapabilities = extendedClientCapabilities,
  },

  -- Capabilities (from blink.cmp)
  capabilities = capabilities,

  -- Keymaps and commands will be set up via on_attach
  on_attach = function(client, bufnr)
    -- Note: Regular LSP keybindings (gd, K, grr, etc.) are set up via the global
    -- LspAttach autocmd in config/lsp/init.lua - that autocmd will fire automatically
    -- Here we only add jdtls-specific keybindings

    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Debug: Verify jdtls attached
    vim.notify("jdtls attached to buffer " .. bufnr, vim.log.levels.INFO)

    -- jdtls specific commands
    vim.keymap.set("n", "<leader>jo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
    vim.keymap.set("n", "<leader>jv", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
    vim.keymap.set("v", "<leader>jv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
    vim.keymap.set("n", "<leader>jc", "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
    vim.keymap.set("v", "<leader>jc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
    vim.keymap.set("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
    vim.keymap.set("n", "<leader>jt", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
    vim.keymap.set("n", "<leader>jT", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)

    -- Enable inlay hints if supported
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Add user commands for jdtls management
    vim.api.nvim_buf_create_user_command(bufnr, "JdtClearWorkspace", function()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local ws_dir = home .. "/.local/share/eclipse/" .. project_name
      vim.notify("Clearing jdtls workspace: " .. ws_dir, vim.log.levels.INFO)
      vim.fn.system("rm -rf " .. vim.fn.shellescape(ws_dir))
      vim.notify("Workspace cleared. Restart Neovim to reinitialize.", vim.log.levels.INFO)
    end, {
      desc = "Clear jdtls workspace cache and restart",
    })

    vim.api.nvim_buf_create_user_command(bufnr, "JdtUpdateConfig", function()
      require("jdtls").update_project_config()
    end, {
      desc = "Update jdtls project configuration",
    })
  end,
}

-- Start or attach to jdtls
jdtls.start_or_attach(config)
