local navigate = require("tmux.navigate")
local resize = require("tmux.resize")
local hosts = require("tmux.hosts")

---@class NavHost
---@field detect fun(): boolean
---@field is_border fun(dir: NavDirection): boolean
---@field is_zoomed fun(): boolean
---@field change_pane fun(dir: NavDirection)
---@field resize fun(dir: NavDirection, step: integer)

---@type NavHost?
local host

local M = {}

function M.setup()
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
