#!/usr/bin/env lua

local map = {}
local r = 1
local gr, gc = nil, nil -- guard position
local sr, sc = nil, nil -- original start of guard
local gd = "^"
for line in io.lines("06.txt") do
	map[r] = {}
	local c = 1
	for char in string.gmatch(line, ".") do
		if char == "^" then
			sr, gr = r, r
			sc, gc = c, c
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

local function walk()
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
			-- print("walked out", nr, nc)
			return visited, false
		elseif string.find(map[nr][nc], gd, 1, true) then
			-- print("loop", nr, nc, map[nr][nc], gd)
			return visited, true
		elseif map[nr][nc] == "#" or map[nr][nc] == "O" then
			gd = rotateRight(gd)
		else
			gr, gc = nr, nc
			if map[gr][gc] == "." then
				visited = visited + 1
				map[gr][gc] = gd
			else
				map[gr][gc] = map[gr][gc] .. gd
			end
		end
	end
end

local function dumpMap()
	for _, row in ipairs(map) do
		local line = ""
		for _, char in ipairs(row) do
			line = line .. char
		end
		print(line)
	end
end

local function reset()
	for _, row in pairs(map) do
		for c = 1, #row do
			if row[c] ~= "#" then
				row[c] = "."
			end
		end
	end
	map[sr][sc] = "^"
	gr, gc = sr, sc
	gd = "^"
end

local visited = walk()
print("p1", visited)

local loops = 0
for r = 1, #map do
	for c = 1, #map[r] do
		if r == sr and c == sc then
			-- skip guard start position for additional obstacle
			goto continue
		elseif map[r][c] == "#" then
			-- skip original obstacles
			goto continue
		end
		reset()
		map[r][c] = "O"
		local _, loop = walk()
		if loop then
			loops = loops + 1
		end
		::continue::
	end
end

print("p2", loops)
