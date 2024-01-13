local navigate = require("barn.navigate")
local resize = require("barn.resize")
local hosts = require("barn.hosts")
local config = require("barn.config")

---@class NavHost
---@field detect fun(): boolean
---@field is_border fun(dir: NavDirection): boolean
---@field is_zoomed fun(): boolean
---@field change_pane fun(dir: NavDirection)
---@field resize fun(dir: NavDirection, step: integer)

---@type NavHost?
local host

local M = {}

---@param cfg? Config
function M.setup(cfg)
  config.set(cfg or {})

  host = hosts.get()
end

-- Navigation
function M.move_left()
  if not host then
    return
  end
  navigate.to(host, "left")
end
function M.move_down()
  if not host then
    return
  end
  navigate.to(host, "down")
end
function M.move_up()
  if not host then
    return
  end
  navigate.to(host, "up")
end
function M.move_right()
  if not host then
    return
  end
  navigate.to(host, "right")
end

-- Resizing
function M.resize_left()
  if not host then
    return
  end
  resize.to(host, "left")
end
function M.resize_down()
  if not host then
    return
  end
  resize.to(host, "down")
end
function M.resize_up()
  if not host then
    return
  end
  resize.to(host, "up")
end
function M.resize_right()
  if not host then
    return
  end
  resize.to(host, "right")
end

return M
