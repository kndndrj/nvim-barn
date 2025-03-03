local nvim = require("barn.nvim")
local config = require("barn.config")

---@alias NavDirection "left"|"down"|"up"|"right"

local M = {}

local opposite_directions = {
  left = "right",
  down = "up",
  up = "down",
  right = "left",
}

---@param host NavHost
---@param direction NavDirection
local function has_target(host, direction)
  local cfg = config.get()
  if host.is_zoomed() and cfg.navigate.persist_zoom then
    return false
  end
  if not host.is_border(direction) then
    return true
  end
  return cfg.navigate.cycle_navigation and not host.is_border(opposite_directions[direction])
end

---@param host? NavHost
---@param direction NavDirection
function M.to(host, direction)
  local is_nvim_border = nvim.is_border(direction)

  if host and is_nvim_border and has_target(host, direction) then
    host.change_pane(direction)
  elseif is_nvim_border and config.get().navigate.cycle_navigation then
    nvim.change_pane(opposite_directions[direction], 999)
  elseif not is_nvim_border then
    nvim.change_pane(direction)
  end
end

return M
