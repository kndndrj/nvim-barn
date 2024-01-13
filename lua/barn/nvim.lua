local M = {}

---@param movement? string
---@return integer _ window number
local function winnr(movement)
    return vim.api.nvim_call_function("winnr", { movement })
end

local nvim_directions = {
    left = "h",
    down = "j",
    up = "k",
    right = "l",
}

---@param direction NavDirection
---@return boolean
function M.is_border(direction)
    return winnr() == winnr("1" .. nvim_directions[direction])
end

---@type table<NavDirection, fun(step: integer)>
local resize_commands = {
    left = function(step)
        vim.api.nvim_command("vertical resize +" .. step)
    end,
    down = function(step)
        vim.api.nvim_command("resize -" .. step)
    end,
    up = function(step)
        vim.api.nvim_command("resize +" .. step)
    end,
    right = function(step)
        vim.api.nvim_command("vertical resize -" .. step)
    end,
}

---@param direction NavDirection
---@param step integer
function M.resize(direction, step)
    local cmd = resize_commands[direction]
    if not cmd then
        error("invalid direction: " .. direction)
    end

    cmd(step)
end

---@param direction NavDirection
---@param count? integer how many panes to jump
---@return boolean
function M.change_pane(direction, count)
    return vim.api.nvim_command((count or 1) .. "wincmd " .. nvim_directions[direction])
end

---Return true if there is no other nvim window in the specified direction.
---@param direction NavDirection
---@return boolean
function M.is_only_window(direction)
    if direction == "left" or direction == "right" then
        --check for other horizontal window
        return (winnr("1h") == winnr("1l"))
    elseif direction == "down" or direction == "up" then
        --check for other vertical window
        return (winnr("1j") == winnr("1k"))
    end

    error("unknown axis: " .. direction)
end

return M
