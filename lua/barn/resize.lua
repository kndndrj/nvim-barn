local nvim = require("barn.nvim")
local config = require("barn.config")

---@param host NavHost
---@param direction NavDirection
---@return boolean
local function is_host_target(host, direction)
  return not host.is_border(direction) or nvim.is_only_window(direction)
end

---@type table<NavDirection, fun(host: NavHost?)>
local actions = {}

---@param host? NavHost
function actions.left(host)
  local cfg = config.get()

  local is_border = nvim.is_border("right")
  if host and is_border and is_host_target(host, "right") then
    host.resize("left", cfg.resize.resize_step_x)
  elseif is_border then
    nvim.resize("left", cfg.resize.resize_step_x)
  else
    vim.fn.win_move_separator(0, -cfg.resize.resize_step_x)
  end
end

---@param host? NavHost
function actions.down(host)
  local cfg = config.get()

  local is_border = nvim.is_border("down")
  if host and is_border and is_host_target(host, "down") then
    host.resize("down", cfg.resize.resize_step_y)
  elseif is_border then
    nvim.resize("down", cfg.resize.resize_step_y)
  else
    vim.fn.win_move_statusline(0, cfg.resize.resize_step_y)
  end
end

---@param host? NavHost
function actions.up(host)
  local cfg = config.get()

  local is_border = nvim.is_border("down")
  if host and is_border and is_host_target(host, "down") then
    host.resize("up", cfg.resize.resize_step_y)
  elseif is_border then
    nvim.resize("up", cfg.resize.resize_step_y)
  else
    vim.fn.win_move_statusline(0, -cfg.resize.resize_step_y)
  end
end

---@param host? NavHost
function actions.right(host)
  local cfg = config.get()

  local is_border = nvim.is_border("right")
  if host and is_border and is_host_target(host, "right") then
    host.resize("right", cfg.resize.resize_step_x)
  elseif is_border then
    nvim.resize("right", cfg.resize.resize_step_x)
  else
    vim.fn.win_move_separator(0, cfg.resize.resize_step_x)
  end
end

local M = {}

---@param host? NavHost
---@param direction NavDirection
function M.to(host, direction)
  local action = actions[direction]
  if not action then
    error("invalid direction: " .. direction)
  end

  action(host)
end

return M
