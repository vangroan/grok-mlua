--[[
# Usage

  local vec2 = require "vector2"

  local a = vec2(1, 2)
  local b = vec2(3, 4)
  local c = a + b
--]]

local ffi = require "ffi"
local ffi_istype = ffi.istype
local ffi_metatype = ffi.metatype
local tostring = tostring

local vector2, vector2_index, vector2_mt

vector2_index = {
  -- add two vectors together
  add = function(a, b)
    return vector2(a.x+b.x, a.y+b.y)
  end,

  -- Add in-place
  iadd = function(a, b)
    a.x = a.x + b.x
    a.y = a.y + b.y
  end,

  tostring = function(v)
    return "(" .. tostring(v.x) .. ", " .. tostring(v.y) .. ")"
  end,
}

vector2_mt = {
  __add      = vector2_index.add,
  __tostring = vector2_index.tostring,
  __index    = vector2_index,
}

vector2 = ffi_metatype("struct { double x, y; }", vector2_mt)

return setmetatable(
  -- module level static functions
  {
    zero = function()
      return vector2(0, 0)
    end,
  },
  {
    -- Constructor
    __call = function(self, x, y)
      return vector2(x, y)
    end,
    -- Allows functions to be called using imported module table.
    __index = vector2_index,
  }
)
