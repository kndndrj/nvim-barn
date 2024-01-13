local M = {}

local hosts = {
    require("tmux.hosts.tmux"),
}

-- Returns a detected host
---@return NavHost?
function M.get()
    for _, h in ipairs(hosts) do
        if h.detect() then
            return h
        end
    end
end

return M
