local log = require("barn.log")
local logging = require("barn.configuration.logging")
local options = require("barn.configuration.options")
local validate = require("barn.configuration.validate")
local tmux = require("barn.wrapper.tmux")

local M = {
    options = options,
    logging = logging,
}

function M.setup(opts, logs)
    M.logging.set(vim.tbl_deep_extend("force", {}, M.logging, logs or {}))

    log.debug("configuration injected: ", opts)
    M.options.set(vim.tbl_deep_extend("force", {}, M.logging, opts or {}))

    if tmux.is_tmux then
        validate.options(tmux.version, M.options)
    end
end

return M
