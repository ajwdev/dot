return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      {
        'leoluz/nvim-dap-go',
        ft = 'go',
        config = function ()
          require('dap-go').setup()
        end,
      }
    },
    keys = {
      {"<F8>", function() require'dap'.toggle_breakpoint() end, desc = "Toggle breakpoint"},
    },
    config = function ()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup {}

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end
  },
}
