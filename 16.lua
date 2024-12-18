#!/usr/bin/env lua

local p2 = 0
local file = "16.txt"
if arg[1] then
	file = arg[1]
end

G = {}
local sr, sc, er, ec
local R, C = 1, 1
for line in io.lines(file) do
	G[R] = {}
	C = 1
	for char in string.gmatch(line, ".") do
		G[R][C] = char
		if char == "S" then
			sr, sc = R, C
		elseif char == "E" then
			er, ec = R, C
		end
		C = C + 1
	end
	R = R + 1
end
R, C = R - 1, C - 1
-- print(R, C)
assert(sr)
assert(sc)
assert(er)
assert(ec)

DIRS = {
	E = { 0, 1, left = "N", right = "S", opp = "W" },
	S = { 1, 0, left = "E", right = "W", opp = "N" },
	W = { 0, -1, left = "S", right = "N", opp = "E" },
	N = { -1, 0, left = "W", right = "E", opp = "S" },
}

local function key(r, c, d)
	return r .. ":" .. c .. "/" .. d
end

local function fromKey(k)
	local r, c, d = string.match(k, "^(.+):(.+)/(.)$")
	return tonumber(r), tonumber(c), d
end

COST = { [key(sr, sc, "E")] = { 0, {} } }
Q = { [key(sr, sc, "E")] = true }
SEEN = {}

local function getMin()
	local minCost, minK = math.maxinteger, nil
	for k in pairs(Q) do
		local cost = COST[k][1]
		if cost < minCost then
			minCost, minK = cost, k
		end
	end
	if not minK then
		return nil
	end
	Q[minK] = nil
	SEEN[minK] = true
	return minK, minCost
end

local function move(r, c, d, cost, prevD)
	local nr, nc = r + DIRS[d][1], c + DIRS[d][2]
	if G[nr][nc] ~= "#" then
		local k = key(nr, nc, d)
		if not COST[k] or cost < COST[k][1] then
			COST[k] = { cost, { { r, c, prevD } } }
		elseif cost == COST[k][1] then
			table.insert(COST[k][2], { r, c, prevD })
		end
		if not SEEN[k] then
			Q[k] = true
		end
	end
end

local i = 1
while true do
	local k, cost = getMin()
	if not k then
		break
	end
	local r, c, d = fromKey(k)

	move(r, c, d, cost + 1, d)
	move(r, c, DIRS[d]["left"], cost + 1001, d)
	move(r, c, DIRS[d]["right"], cost + 1001, d)
	i = i + 1
end

local minEndDs, minCost = {}, math.maxinteger
for _, d in pairs({ "N", "E", "S", "W" }) do
	local k = key(er, ec, d)
	if COST[k] and COST[k][1] < minCost then
		minEndDs = { d }
		minCost = COST[k][1]
	elseif COST[k] and COST[k][1] == minCost then
		minEndDs[#minEndDs + 1] = d
	end
end
print("p1", minCost)

W = {}

local function key2(r, c)
	return r .. ":" .. c
end

local path
path = function(keys)
	-- print("path")
	for _, k in pairs(keys) do
		local r, c, d = table.unpack(k)
		-- print(key(r, c, d))
		local k2 = key2(r, c)
		if not W[k2] then
			W[k2] = true
			p2 = p2 + 1
		end
		path(COST[key(r, c, d)][2])
	end
end

local keys = {}
for _, d in pairs(minEndDs) do
	table.insert(keys, { er, ec, d })
end

path(keys)

print("p2", p2)
