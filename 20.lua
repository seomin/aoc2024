#!/usr/bin/env lua

local file = "20.txt"
if arg[1] then
	file = arg[1]
end

G = {}
R, C = nil, nil
local sr, sc
do
	local r, c = 1, 1
	for line in io.lines(file) do
		G[r] = {}
		c = 1
		for char in string.gmatch(line, ".") do
			if char == "S" then
				sr, sc = r, c
			end
			G[r][c] = char
			c = c + 1
		end
		r = r + 1
	end
	R, C = r - 1, c - 1
end

local function key(r, c)
	return r .. ":" .. c
end

WAY = { [key(sr, sc)] = 0 }
L = 0
DIRS = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }

local r, c = sr, sc
while true do
	if G[r][c] == "E" then
		break
	end
	for _, dir in pairs(DIRS) do
		local dr, dc = dir[1], dir[2]
		local nr, nc = r + dr, c + dc
		if G[nr][nc] ~= "#" and not WAY[key(nr, nc)] then
			WAY[key(nr, nc)] = WAY[key(r, c)] + 1
			L = L + 1
			r, c = nr, nc
			break
		end
	end
end

print("L", L)

local function findCheats(r, c, d, MAX_CD)
	local cheats = 0
	for cr = r - MAX_CD, r + MAX_CD do
		for cc = c - MAX_CD, c + MAX_CD do
			if cr == r and cc == c then
				goto continue
			end
			if not WAY[key(cr, cc)] then
				goto continue
			end
			local manD = math.abs(cr - r) + math.abs(cc - c)
			if manD > MAX_CD then
				goto continue
			end
			local impr = WAY[key(cr, cc)] - d - manD
			if impr >= 100 then
				cheats = cheats + 1
			end
			::continue::
		end
	end
	return cheats
end

local function fromKey(k)
	local r, c = string.match(k, "(%d+):(%d+)")
	return tonumber(r), tonumber(c)
end

local p1 = 0
for w, d in pairs(WAY) do
	local r, c = fromKey(w)
	p1 = p1 + findCheats(r, c, d, 2)
end
print("p1", p1)

local p2 = 0
for w, d in pairs(WAY) do
	local r, c = fromKey(w)
	p2 = p2 + findCheats(r, c, d, 20)
end
print("p2", p2)
