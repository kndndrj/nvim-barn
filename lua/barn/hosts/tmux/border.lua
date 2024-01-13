local execute = require("barn.hosts.tmux.execute")

---@return string layout
local function get_window_layout()
    return execute.cmd("display-message -p '#{window_layout}'")
end

---@param layout string
local function parse_window_layout(layout)
    if layout == "" or layout == nil then
        return nil
    end

    local panes = {}
    for pane in layout:gmatch("(%d+x%d+,%d+,%d+,%d+)") do
        table.insert(panes, {
            id = tonumber(pane:match("%d+x%d+,%d+,%d+,(%d+)")),
            x = tonumber(pane:match("%d+x%d+,(%d+),%d+,%d+")),
            y = tonumber(pane:match("%d+x%d+,%d+,(%d+),%d+")),
            width = tonumber(pane:match("(%d+)x%d+")),
            height = tonumber(pane:match("%d+x(%d+)")),
        })
    end
    if #panes == 0 then
        return nil
    end

    local width = layout:match("^%w+,(%d+)x%d+")
    local height = layout:match("^%w+,%d+x(%d+)")

    if width == nil and height == nil then
        return nil
    end

    local result = {
        width = tonumber(width),
        height = tonumber(height),
        panes = panes,
    }

    return result
end

local direction_checks = {
    left = function(_, pane)
        return pane.x == 0
    end,
    down = function(layout, pane)
        return pane.y + pane.height == layout.height
    end,
    up = function(_, pane)
        return pane.y == 0
    end,
    right = function(layout, pane)
        return pane.x + pane.width == layout.width
    end,
}

local M = {}

local function get_pane(id, panes)
    for _, pane in pairs(panes) do
        if pane.id == id then
            return pane
        end
    end
    return nil
end

---Check if border is present in direction.
---@param pane_id number
---@param direction NavDirection
---@return boolean
function M.check(pane_id, direction)
    local layout = parse_window_layout(get_window_layout())
    if layout == nil then
        return false
    end

    local pane = get_pane(pane_id, layout.panes)
    if pane == nil then
        return false
    end

    local check = direction_checks[direction]
    if check ~= nil then
        return check(layout, pane)
    end

    return false
end

return M
