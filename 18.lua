#!/usr/bin/env lua

local p2 = 0
local file = "18.txt"
D = 70
C = 1024
if arg[1] then
	file = arg[1]
	D = tonumber(arg[2])
	C = tonumber(arg[3])
end
assert(D)
assert(C)

local function nums(str)
	local result = {}
	for n in string.gmatch(str, "-?%d+") do
		table.insert(result, tonumber(n))
	end
	return table.unpack(result)
end

G = {}
for y = 0, D do
	G[y] = {}
	for x = 0, D do
		G[y][x] = "."
	end
end

local c = 0
for line in io.lines(file) do
	if c == C then
		break
	end
	local x, y = nums(line)
	G[y][x] = "#"
	c = c + 1
end

local function key(x, y, d)
	return x .. ":" .. y .. "/" .. d
end
local function key2(x, y)
	return x .. ":" .. y
end

Q = { key(0, 0, 0) }
SEEN = {}
DIRS = {{1,0}, {0,1}, {-1, 0}, {0, -1}}

local k = table.remove(Q, 1)
while k do
	Q[k] = nil
	local x, y, d = nums(k)
	if SEEN[key2(x, y)] then
		k = table.remove(Q, 1)
		goto continue
	end
	if x == D and y == D then
		print("p1", d)
		break
	end
	SEEN[key2(x, y)] = true

	for _, dir in pairs(DIRS) do
		local dx, dy = table.unpack(dir)
		local nx, ny = x+dx, y+dy
		if G[ny] and G[ny][nx] == "." then
			if not SEEN[key2(nx, ny)] then
				Q[#Q+1] = key(nx, ny, d+1)
			end
		end
	end

	k = table.remove(Q, 1)
    ::continue::
end

print("p2", p2)
