require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
  require("menu.utils").delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})

map("n", "<leader>ft", "<cmd>FloatermToggle<CR>", { desc = "Floaterm toggle" })
map({ "n", "t" }, "<F12>", "<cmd>FloatermToggle<CR>", { desc = "Floaterm toggle" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>gr", require("telescope.builtin").lsp_references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

vim.keymap.set("n", "<leader>dj", function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>dk", function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Prev diagnostic" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Git diff" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
