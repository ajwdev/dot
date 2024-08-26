local Hydra = require('hydra')

Hydra({
   name = 'Window resize',
   mode = 'n',
   body = '<C-w>',
   -- TODO For extra credit, make incline.nvim refresh on every keypress. This
   -- fixes a small glitch where the incline buffer name floats across buffers
   heads = {
      { '+', '<C-w>+', { desc = "Increase height" } },
      { '-', '<C-w>+', { desc = "Decrease height" } },
      { '>', '<C-w>>', { desc = "Increase width" } },
      { '<', '<C-w><', { desc = "Decrease width" } },
   }
})
