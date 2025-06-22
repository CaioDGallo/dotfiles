local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Define the languages and core utils lists
local languages = {
  "golang",
  "lua",
  "typescript",
  "javascript",
  "nodejs",
  "php",
  "bash",
}

local core_utils = {
  "xargs",
  "find",
  "mv",
  "sed",
  "awk",
  "grep",
  "curl",
  "wget",
  "tar",
  "zip",
  "unzip",
  "ssh",
  "scp",
  "rsync",
}

-- Combine both lists
local all_options = vim.list_extend(languages, core_utils)

-- Function to create floating window
function M.create_floating_window(content)
  -- Calculate window size and position
  local width = math.min(120, vim.o.columns - 4)
  local height = math.min(30, vim.o.lines - 4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Window options
  local opts = {
    relative = "editor",
    style = "minimal",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  -- Create terminal buffer
  local buf = vim.api.nvim_create_buf(false, true)
  local chan = vim.api.nvim_open_term(buf, {})

  -- Create the window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Write the content to terminal buffer
  vim.api.nvim_chan_send(chan, content)

  -- Set window options
  vim.wo[win].wrap = true
  vim.wo[win].cursorline = true

  -- Add keymapping to close window
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", {
    noremap = true,
    silent = true,
  })

  return buf, win
end

function M.fetch_cheat(selected, query)
  local url
  if vim.tbl_contains(languages, selected) then
    url = string.format("curl -s cht.sh/%s/%s", selected, query:gsub(" ", "+"))
  else
    url = string.format("curl -s cht.sh/%s~%s", selected, query)
  end

  local handle = io.popen(url)
  if not handle then
    return "Error: Could not execute curl command"
  end

  local result = handle:read("*a")
  if not result then
    handle:close()
    return "Error: No response from cht.sh"
  end

  handle:close()
  return result
end

-- Main function to show Telescope picker
function M.show_cheat()
  local opts = {}

  pickers
    .new(opts, {
      prompt_title = "Select Language/Tool",
      finder = finders.new_table({
        results = all_options,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          -- Prompt for query
          vim.ui.input({
            prompt = "Enter query: ",
          }, function(query)
            if query then
              local content = M.fetch_cheat(selection[1], query)
              M.create_floating_window(content)
            end
          end)
        end)
        return true
      end,
    })
    :find()
end

-- Command to call the function
vim.api.nvim_create_user_command("Cheat", function()
  M.show_cheat()
end, {})

M.setup = function()
  vim.api.nvim_set_keymap("n", "<leader>ts", ":Cheat<CR>", {
    noremap = true,
    silent = true,
    desc = "Show cheat sheet",
  })
end

return M
