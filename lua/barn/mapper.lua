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

---@class Mapper
---@field private timer table uv.timer
---@field private layer table libmodal.layer
local Mapper = {}

---@param host NavHost
---@return Mapper
function Mapper:new(host)
  if not host then
    error("no host provided")
  end

  ---@type Mapper
  local o = {
    timer = vim.loop.new_timer(),
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
  self:layer_timeout(800)
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
  self.timer:start(
    timeout,
    0,
    vim.schedule_wrap(function()
      self:layer_exit()
      self.timer:stop()
      self.timer:close()
    end)
  )
end

-- return to normal mode
local function nm()
  vim.api.nvim_input("<C-\\><C-N>")
end

---@private
---@param host NavHost
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
        self:layer_timeout(350)
        resize.to(host, "left")
      end,
      noremap = true,
      buffer = true,
    },
    J = {
      rhs = function()
        self:layer_timeout(350)
        resize.to(host, "down")
      end,
      noremap = true,
      buffer = true,
    },
    K = {
      rhs = function()
        self:layer_timeout(350)
        resize.to(host, "up")
      end,
      noremap = true,
      buffer = true,
    },
    L = {
      rhs = function()
        self:layer_timeout(350)
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
  vim.keymap.set("n", "<C-a>", function()
    self:layer_enter()
  end, map_options)
  vim.keymap.set("i", "<C-a>", function()
    self:layer_enter()
  end, map_options)
  vim.keymap.set("t", "<C-a>", function()
    self:layer_enter()
  end, map_options)
  vim.keymap.set("x", "<C-a>", function()
    self:layer_enter()
  end, map_options)
  vim.keymap.set("o", "<C-a>", function()
    self:layer_enter()
  end, map_options)
end

return Mapper
