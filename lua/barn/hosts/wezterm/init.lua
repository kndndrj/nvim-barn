local execute = require("barn.hosts.wezterm.execute")

local M = {}

---Returns true if the host is tmux.
---@return boolean
function M.detect()
  return os.getenv("TERM_PROGRAM") == "WezTerm"
end

---@param direction NavDirection
---@return boolean
function M.is_border(direction)
  return execute.cmd("get-pane-direction " .. direction) == ""
end

---@return boolean
function M.is_zoomed()
  --TODO: not available yet
  return false
end

---@param direction NavDirection
function M.change_pane(direction)
  execute.cmd("activate-pane-direction " .. direction)
end

---@param direction NavDirection
---@param step integer
function M.resize(direction, step)
  execute.cmd(string.format("adjust-pane-size %s --amount %d", direction, step))
end

return M
