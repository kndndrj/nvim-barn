local M = {}

---@class NavigateConfig
---@field enable_default_keybindings boolean enables default keybindings
---@field cycle_navigation boolean cycles to opposite pane while navigating into the border
---@field persist_zoom boolean prevents unzoom tmux when navigating beyond vim border

---@class ResizeConfig
---@field enable_default_keybindings boolean enables default keybindings
---@field resize_step_x integer sets resize steps for x axis
---@field resize_step_y integer sets resize steps for y axis

---@class Config
---@field navigate NavigateConfig
---@field resize ResizeConfig

---@type Config
local current_config = {
  navigate = {
    enable_default_keybindings = false, --TODO check if this is actually needed
    cycle_navigation = true,
    persist_zoom = false,
  },
  resize = {
    enable_default_keybindings = false, --TODO check if this is actually needed
    resize_step_x = 1,
    resize_step_y = 1,
  },
}

---@package
---@param cfg Config
function M.set(cfg)
  if not cfg then
    return
  end

  ---@type Config
  current_config = vim.tbl_deep_extend("force", current_config, cfg)
end

---@package
---@return Config
function M.get()
  return current_config
end

return M
