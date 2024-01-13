local navigate = require("barn.navigate")
local resize = require("barn.resize")
local libmodal = require("libmodal")

-- Mapper handles mappings and repeatable mappings.
-- For every prefix keypress it
-- creates a keymap layer with libmodal.
-- Exits the mode imediately for one-shot keymaps.
-- Exits the mode after a timeout for repeat keymaps.
--
-- examples:
--     switch panes with: <tmuxprefix>h
--     resize panes with: <tmuxprefix>HHHHHHHHHHHHHH

---@alias mapper_config { prefix_key: string, key_repeat_ms: integer, layer_timeout_ms: integer, disable: boolean }

---@class Mapper
---@field private timer? table uv.timer
---@field private layer table libmodal.layer
---@field private opts mapper_config
local Mapper = {}

---@param host? NavHost
---@param opts? mapper_config
---@return Mapper?
function Mapper:new(host, opts)
  opts = opts or {}

  if opts.disable then
    return nil
  end

  ---@type Mapper
  local o = {
    timer = nil,
    opts = {
      prefix_key = opts.prefix_key or "<C-b>",
      key_repeat_ms = opts.key_repeat_ms or 350,
      layer_timeout_ms = opts.layer_timeout_ms or 1000,
    },
  }
  setmetatable(o, self)
  self.__index = self

  o:create_layer(host)
  o:configure_mappings()

  return o
end

---@private
function Mapper:layer_enter()
  if self.layer:is_active() then
    return
  end

  -- exit layer automatically after timeout
  self:layer_timeout(self.opts.layer_timeout_ms)
  self.layer:enter()
end

-- exit libmodal layer
---@private
function Mapper:layer_exit()
  if self.layer:is_active() then
    self.layer:exit()
  end
end

-- return to normal mode if no key presssed for a while
---@private
function Mapper:layer_timeout(timeout)
  if not self.timer then
    self.timer = vim.loop.new_timer()
  end
  self.timer:start(
    timeout,
    0,
    vim.schedule_wrap(function()
      self:layer_exit()
      if self.timer then
        self.timer:stop()
        self.timer:close()
        self.timer = nil
      end
    end)
  )
end

-- return to normal mode
local function nm()
  vim.api.nvim_input("<C-\\><C-N>")
end

---@private
---@param host? NavHost
function Mapper:create_layer(host)
  local mappings = {
    -- moving
    h = {
      rhs = function()
        nm()
        self:layer_exit()
        navigate.to(host, "left")
      end,
      noremap = true,
      buffer = true,
    },
    j = {
      rhs = function()
        nm()
        self:layer_exit()
        navigate.to(host, "down")
      end,
      noremap = true,
      buffer = true,
    },
    k = {
      rhs = function()
        nm()
        self:layer_exit()
        navigate.to(host, "up")
      end,
      noremap = true,
      buffer = true,
    },
    l = {
      rhs = function()
        nm()
        self:layer_exit()
        navigate.to(host, "right")
      end,
      noremap = true,
      buffer = true,
    },

    -- resizing
    H = {
      rhs = function()
        self:layer_timeout(self.opts.key_repeat_ms)
        resize.to(host, "left")
      end,
      noremap = true,
      buffer = true,
    },
    J = {
      rhs = function()
        self:layer_timeout(self.opts.key_repeat_ms)
        resize.to(host, "down")
      end,
      noremap = true,
      buffer = true,
    },
    K = {
      rhs = function()
        self:layer_timeout(self.opts.key_repeat_ms)
        resize.to(host, "up")
      end,
      noremap = true,
      buffer = true,
    },
    L = {
      rhs = function()
        self:layer_timeout(self.opts.key_repeat_ms)
        resize.to(host, "right")
      end,
      noremap = true,
      buffer = true,
    },
  }

  self.layer = libmodal.layer.new {
    n = mappings,
    i = mappings,
    t = mappings,
    x = mappings,
    o = mappings,
  }
end

-- configure key mappings
function Mapper:configure_mappings()
  local map_options = { noremap = true, silent = true }

  -- enter the layer with tmux prefix in all modes
  vim.keymap.set("n", self.opts.prefix_key, function()
    self:layer_enter()
  end, map_options)
  vim.keymap.set("i", self.opts.prefix_key, function()
    self:layer_enter()
  end, map_options)
  vim.keymap.set("t", self.opts.prefix_key, function()
    self:layer_enter()
  end, map_options)
  vim.keymap.set("x", self.opts.prefix_key, function()
    self:layer_enter()
  end, map_options)
  vim.keymap.set("o", self.opts.prefix_key, function()
    self:layer_enter()
  end, map_options)
end

return Mapper
