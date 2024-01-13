local M = {}

--- Execute wezterm cli command
---@param cmd string
function M.cmd(cmd)
  local command = string.format("wezterm cli %s", cmd)

  local handle = assert(io.popen(command), string.format("unable to execute: [%s]", command))
  local result = handle:read("*a")
  handle:close()

  return result
end

return M
