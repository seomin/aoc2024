#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "15.txt"
if arg[1] then
	file = arg[1]
end

local f = io.open(file)
assert(f)
local line = f:read()

local map = {}
local R, C = 0, 0
local rr, rc
repeat
	map[R] = {}
	C = 0
	for char in string.gmatch(line, ".") do
		map[R][C] = char
		if char == "@" then
			rr, rc = R, C
		end
		C = C + 1
	end
	R = R + 1
	line = f:read()
until string.len(line) == 0
assert(rr)
assert(rc)
R, C = R - 1, C - 1
-- print(R, C)

local function go(r, c, d)
	local nr, nc = r, c
	if d == "^" then
		nr = nr - 1
	elseif d == "v" then
		nr = nr + 1
	elseif d == "<" then
		nc = nc - 1
	elseif d == ">" then
		nc = nc + 1
	end
	return nr, nc
end

local moveThing
moveThing = function(r, c, d, thing)
	local nr, nc = go(r, c, d)
	local char = map[nr] and map[nr][nc]
	if char == "." then
		map[nr][nc] = thing
		return true
	elseif char == "O" then
		local res = moveThing(nr, nc, d, "O")
		if res then
			map[nr][nc] = thing
		end
		return res
	else
		return false
	end
end

local function dump()
	for r = 0, R do
		local line = ""
		for c = 0, C do
			line = line .. map[r][c]
		end
		print(line)
	end
end

line = f:read()
repeat
	for d in string.gmatch(line, ".") do
		if moveThing(rr, rc, d, "@") then
			map[rr][rc] = "."
			rr, rc = go(rr, rc, d)
		end
		-- print("after", d)
		-- dump()
	end
	line = f:read()
until not line
f:close()

for r, row in pairs(map) do
	for c, char in pairs(row) do
		if char == "O" then
			p1 = p1 + 100 * r + c
		end
	end
end

print("p1", p1)
print("p2", p2)
