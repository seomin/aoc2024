#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "09.txt"
if arg[1] then
	file = arg[1]
end

local mem = {}
local fileId = 0
local pos = 0
local free = false
local f = io.open(file)
assert(f)
local c = f:read(1)
repeat
	local len = tonumber(c)
	if free then
		for l = 1, len do
			mem[pos] = -1
			pos = pos + 1
		end
	else
		for l = 1, len do
			mem[pos] = fileId
			pos = pos + 1
		end
		fileId = fileId + 1
	end
	free = not free
	c = f:read(1)
until c == "\n"
assert(f:close())

-- print(fileId, pos)
local nextFree = 0
pos = pos - 1
while true do
	while mem[pos] == -1 do
		pos = pos - 1
	end
	while mem[nextFree] ~= -1 do
		nextFree = nextFree + 1
	end
	if nextFree >= pos then
		break
	end
	mem[nextFree] = mem[pos]
	mem[pos] = -1
end

for k, v in pairs(mem) do
	if v ~= -1 then
		p1 = p1 + k * v
	end
end

print("p1", p1)
print("p2", p2)
