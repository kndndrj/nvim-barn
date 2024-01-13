local nvim = require("barn.nvim")
local log = require("barn.log")
local options = require("barn.configuration.options")

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
    if host.is_zoomed() and options.navigation.persist_zoom then
        return false
    end
    if not host.is_border(direction) then
        return true
    end
    return options.navigation.cycle_navigation and not host.is_border(opposite_directions[direction])
end

---@param host NavHost
---@param direction NavDirection
function M.to(host, direction)
    log.debug("navigate_to: " .. direction)

    local is_nvim_border = nvim.is_border(direction)

    if is_nvim_border and has_target(host, direction) then
        host.change_pane(direction)
    elseif is_nvim_border and options.navigation.cycle_navigation then
        nvim.change_pane(opposite_directions[direction], 999)
    elseif not is_nvim_border then
        nvim.change_pane(direction)
    end
end

return M
