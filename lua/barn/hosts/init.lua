local M = {}

local hosts = {
    require("barn.hosts.tmux"),
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
