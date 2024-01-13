local M = {}

local function get_socket()
  local tmux = os.getenv("TMUX")
  if not tmux then
    error("Not in tmux")
  end

  return vim.split(tmux, ",")[1]
end

--- Execute tmux command
---@param cmd string
function M.cmd(cmd)
  local command = string.format("tmux -S %s %s", get_socket(), cmd)

  local handle = assert(io.popen(command), string.format("unable to execute: [%s]", command))
  local result = handle:read("*a")
  handle:close()

  return result
end

return M
