-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>uB", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle inline blame" })

-- Quick chat keybinding
vim.keymap.set("n", "<leader>ccq", function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, {
      selection = require("CopilotChat.select").buffer,
    })
  end
end, { desc = "CopilotChat - Quick chat" })

-- Selection chat keybinding
vim.keymap.set("v", "<leader>ccs", function()
  local input = vim.fn.input("Selection Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, {
      selection = require("CopilotChat.select").visual,
    })
  end
end, { desc = "CopilotChat - Selection chat" })
