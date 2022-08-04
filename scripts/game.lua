local format  = string.format
local tinsert = table.insert
local vec2    = require "scripts/vector2"

print("Lua vector math")

-- elapsed time: 0.089
do
  local t = {}
  local a = vec2(1, 2)
  local s = os.clock()
  for i = 1, 1000000 do t[i] = vec2(i * 2, i * 3) + a end
  print(string.format("elapsed time: %.3f\n", os.clock() - s))
end

-- elapsed time: 0.096
do
  local t = {}
  local a = vec2(1, 2)
  local s = os.clock()
  for i = 1, 1000000 do tinsert(t, vec2(i * 2, i * 3) + a) end
  print(string.format("elapsed time: %.3f\n", os.clock() - s))
end

-- for i,v in ipairs(t) do
--   print(v)
-- end

-- sequential table
-- elapsed time: 0.180
do
  local t = {}
  local a = { 1, 2 }
  local s = os.clock()
  for i = 1, 1000000 do t[i] = { a[1]+i*2, a[2]+i*3 } end
  print(string.format("elapsed time: %.3f\n", os.clock() - s))
end

-- hashmap table
-- elapsed time: 0.228
do
  local t = {}
  local a = { x=1, y=2 }
  local s = os.clock()
  for i = 1, 1000000 do t[i] = { x=a.x+i*2, y=a.y+i*3 } end
  print(string.format("elapsed time: %.3f\n", os.clock() - s))
end

Game = {}

function Game:update()
  print("Hello, world!")
end
