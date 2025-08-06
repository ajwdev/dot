local servers = {
  gopls = {
    cmd = { 'gopls', '--remote=auto' },
    filetypes = { "go", "gomod" },
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
    capabilties = {
      textDocuemnt = {
        completion = {
          completionItem = {
            snippetSupport = true
          }
        }
      }
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true
    }
  },

  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "by_self",
        },
        cargo = {
          loadOutDirsFromCheck = true
        },
        procMacro = {
          enable = true
        },
      }
    }
  },

  lua_ls = {
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
  },

  nil_ls = {
    settings = {
      ['nil'] = {
        formatting = {
          command = { "nixfmt" },
        },
      },
    },
  },

  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ["https://api.spinnaker.mgmt.netflix.net/managed/delivery-configs/schema"] = "spinnaker.yml",
        },
      }
    }
  },

  clangd = {},
  solargraph = {},
  bashls = {},
  racket_langserver = {},
  tilt_ls = {},
  ruby_lsp = {},
  zls = {},
}

vim.lsp.enable('kotlin_lsp')

local lspconfig = require('lspconfig')
for lsp, config in pairs(servers) do
  config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
  lspconfig[lsp].setup(config)
end

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
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, keymap_opts("Goto previous diagnostic"))
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, keymap_opts("Goto next diagnostic"))

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
      '<cmd>lua require("telescope.builtin").lsp_references()<CR>',
      keymap_opts("List all references in Telescope")
    )
    vim.keymap.set('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<CR>',
      keymap_opts("List all implementations in quickfix"))
    vim.keymap.set(
      'n',
      'gO',
      '<cmd>lua require("telescope.builtin").lsp_document_symbols({symbol_width=0.4, symbol_type_width = 0.1})<CR>',
      keymap_opts("List document symbols")
    )
    -- TODO Deprecate these and move to default bindings above
    vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts("Execute LSP code action"))
    vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts("Rename symbol under cursor"))
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
      keymap_opts("List all implementations in quickfix"))

    vim.keymap.set("n", "<leader>F", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", keymap_opts("Format buffer"))
  end
})
