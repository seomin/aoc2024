#!/usr/bin/env lua

local map = {}
local r = 1
local gr, gc = nil, nil
local gd = "^"
for line in io.lines("06.txt") do
	map[r] = {}
	local c = 1
	for char in string.gmatch(line, ".") do
		if char == "^" then
			gr = r
			gc = c
			char = "X"
		end
		map[r][c] = char
		c = c + 1
	end
	r = r + 1
end

local function outOfBounds(r, c)
	return r < 1 or r > #map or c < 1 or c > #map[r]
end

local function rotateRight(dir)
	if dir == ">" then
		return "v"
	elseif dir == "v" then
		return "<"
	elseif dir == "<" then
		return "^"
	else
		return ">"
	end
end

local visited = 1
while true do
	local nr, nc = gr, gc
	if gd == "^" then
		nr = gr - 1
	elseif gd == "v" then
		nr = gr + 1
	elseif gd == "<" then
		nc = gc - 1
	else
		nc = gc + 1
	end

	if outOfBounds(nr, nc) then
		break
	elseif map[nr][nc] == "#" then
		gd = rotateRight(gd)
	else
		gr, gc = nr, nc
		if map[gr][gc] ~= "X" then
			visited = visited + 1
			map[gr][gc] = "X"
		end
	end
end

print("p1", visited)
