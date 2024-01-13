local border = require("tmux.hosts.tmux.border")
local execute = require("tmux.hosts.tmux.execute")

local log = require("tmux.log")

local M = {}

---Returns true if the host is tmux.
---@return boolean
function M.detect()
    return os.getenv("TMUX") ~= nil
end

---@return integer pane_id
local function get_current_pane_id()
    local pane = os.getenv("TMUX_PANE")
    if not pane then
        error("couldn't detect pane")
    end
    local id = tonumber(pane:sub(2))
    if not id then
        error("pane id is invalid")
    end
    return id
end

---@param direction NavDirection
---@return boolean
function M.is_border(direction)
    log.debug("is_border: ", direction or "nil")

    local id = get_current_pane_id()
    local result = border.check(id, direction)

    log.debug("is_border > ", result or "false")

    return result
end

---@return boolean
function M.is_zoomed()
    return execute.cmd("display-message -p '#{window_zoomed_flag}'"):find("1")
end

local tmux_directions = {
    left = "L",
    down = "D",
    up = "U",
    right = "R",
}

---@return string
local function get_tmux_pane()
    return os.getenv("TMUX_PANE") or ""
end

---@param direction NavDirection
function M.change_pane(direction)
    execute.cmd(string.format("select-pane -t '%s' -%s", get_tmux_pane(), tmux_directions[direction]))
end

---@param direction NavDirection
---@param step integer
function M.resize(direction, step)
    execute.cmd(string.format("resize-pane -t '%s' -%s %d", get_tmux_pane(), tmux_directions[direction], step))
end

return M
