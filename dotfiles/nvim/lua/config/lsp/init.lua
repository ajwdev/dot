local Snacks = require("snacks")

-- Configure LSP servers using the modern vim.lsp.config() + vim.lsp.enable() API
local capabilities = require('blink.cmp').get_lsp_capabilities({
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true
      }
    }
  }
})

-- Configure diagnostics display
vim.diagnostic.config({
  virtual_text = true, -- Enable virtual text
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Configure floating windows (hover, signature help, etc.)
vim.api.nvim_create_autocmd("FileType", {
  -- pattern = "markdown",
  callback = function()
    -- Check if we're in a floating window
    local config = vim.api.nvim_win_get_config(0)
    if config.relative ~= "" then
      -- Always conceal markdown markers in floating windows
      vim.wo.concealcursor = "nvic"

      -- Skip over code fence markers when moving
      local function skip_fences(direction)
        return function()
          local line = vim.fn.line(".")
          local max_line = vim.fn.line("$")

          -- Move in the specified direction
          if direction == "down" then
            vim.cmd("normal! j")
          else
            vim.cmd("normal! k")
          end

          -- Skip lines that are just code fence markers
          local new_line = vim.fn.line(".")
          local content = vim.fn.getline(new_line)
          while new_line ~= line and content:match("^```") do
            if direction == "down" and new_line < max_line then
              vim.cmd("normal! j")
            elseif direction == "up" and new_line > 1 then
              vim.cmd("normal! k")
            else
              break
            end
            new_line = vim.fn.line(".")
            content = vim.fn.getline(new_line)
          end
        end
      end

      vim.keymap.set("n", "j", skip_fences("down"), { buffer = true, silent = true })
      vim.keymap.set("n", "k", skip_fences("up"), { buffer = true, silent = true })
    end
  end,
})

-- Configure each server
vim.lsp.config('gopls', {
  cmd = { 'gopls', '--remote=auto' },
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      codelenses = {
        generate = false, -- Don't show the `go generate` lens.
        gc_details = true -- Show a code lens toggling the display of gc's choices.
      },
      staticcheck = true,
    },
  },
  capabilities = capabilities,
  init_options = {
    usePlaceholders = true,
    completeUnimported = true
  }
})

vim.lsp.config('rust_analyzer', {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      -- Imports
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      -- NOTE: Uncomment if using proc macros or build.rs heavy projects (e.g., lalrpop)
      -- This can cause rust-analyzer to restart on every save, so only enable when needed
      -- cargo = {
      -- 	buildScripts = {
      -- 		enable = true,
      -- 	},
      -- },
      -- Enable checking on save (default: true)
      checkOnSave = true,
      -- Proc macro support (recommended)
      procMacro = {
        enable = true,
      },
      -- Inlay hints are configured via the LspAttach autocmd below
    },
  },
})

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      telemetry = {
        enable = false,
      },
      format = {
        enable = true,
        -- Put format options here
        -- NOTE: the value should be STRING!!
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
    }
  }
})

vim.lsp.config('nil_ls', {
  capabilities = capabilities,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

vim.lsp.config('yamlls', {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://api.spinnaker.mgmt.netflix.net/managed/delivery-configs/schema"] = "spinnaker.yml",
      },
    }
  }
})

-- Configure servers with just capabilities (using nvim-lspconfig defaults for everything else)
vim.lsp.config('clangd', {
  capabilities = capabilities,
})

vim.lsp.config('solargraph', {
  capabilities = capabilities,
})

vim.lsp.config('bashls', {
  capabilities = capabilities,
})

vim.lsp.config('racket_langserver', {
  capabilities = capabilities,
})

vim.lsp.config('tilt_ls', {
  capabilities = capabilities,
})

vim.lsp.config('ruby_lsp', {
  capabilities = capabilities,
})

vim.lsp.config('zls', {
  capabilities = capabilities,
})

-- Enable all configured servers at once
vim.lsp.enable({
  'gopls',
  'rust_analyzer',
  'lua_ls',
  'nil_ls',
  'yamlls',
  'clangd',
  'solargraph',
  'bashls',
  'racket_langserver',
  'tilt_ls',
  'ruby_lsp',
  'zls',
  'kotlin_lsp',
})

local function keymap_opts(desc)
  return {
    buffer = true,
    noremap = true,
    silent = true,
    desc = desc,
  }
end
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts("Open floating diagnostic window"))
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, keymap_opts("Goto previous diagnostic"))
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, keymap_opts("Goto next diagnostic"))

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf })
      end, keymap_opts('[T]oggle Inlay [H]ints'))
      -- TODO Add a message when the LSP doesn't support inlay hints
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', keymap_opts("Goto definition"))
    vim.keymap.set('n', '<leader>gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', keymap_opts("Goto declaration"))
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', keymap_opts("Goto type definition"))
    -- Same as above but in a vertical split
    vim.keymap.set('n', '<c-w>gd', '<Cmd>vsp<CR><Cmd>lua vim.lsp.buf.definition()<CR>',
      keymap_opts("Goto definition in vertical split"))
    vim.keymap.set('n', '<c-w>gD', '<Cmd>vsp<CR><cmd>lua vim.lsp.buf.type_definition()<CR>',
      keymap_opts("Goto type definition in vertical split"))

    vim.keymap.set('n', 'K',
      function() vim.lsp.buf.hover() end,
      keymap_opts("Show symbol information under cursor in floating window")
    )
    vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
      keymap_opts("List all references in quickfix"))

    vim.keymap.set('n', '<leader>Wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', keymap_opts())
    vim.keymap.set('n', '<leader>Wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', keymap_opts())
    vim.keymap.set('n', '<leader>Wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
      keymap_opts())

    vim.keymap.set('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts("Rename symbol under cursor"))
    vim.keymap.set('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts("Execute LSP code action"))
    vim.keymap.set(
      'n',
      'grr',
      function() Snacks.picker.lsp_references() end,
      keymap_opts("List all references in Picker")
    )
    vim.keymap.set('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<CR>',
      keymap_opts("List all implementations in quickfix"))
    vim.keymap.set(
      'n',
      'gO',
      function() Snacks.picker.lsp_symbols() end,
      keymap_opts("List document symbols")
    )
    -- TODO Deprecate these and move to default bindings above
    vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts("Execute LSP code action"))
    vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts("Rename symbol under cursor"))
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
      keymap_opts("List all implementations in quickfix"))

    -- vim.keymap.set("n", "<leader>F", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", keymap_opts("Format buffer"))
  end
})
