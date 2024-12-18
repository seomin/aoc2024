#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "16.txt"
if arg[1] then
	file = arg[1]
end

G = {}
local sr, sc
local R, C = 1, 1
for line in io.lines(file) do
	G[R] = {}
	C = 1
	for char in string.gmatch(line, ".") do
		G[R][C] = char
		if char == "S" then
			sr, sc = R, C
		end
		C = C + 1
	end
	R = R + 1
end
R, C = R - 1, C - 1
-- print(R, C)
assert(sr)
assert(sc)

DIRS = {
	E = { 0, 1, left = "N", right = "S" },
	S = { 1, 0, left = "E", right = "W" },
	W = { 0, -1, left = "S", right = "N" },
	N = { -1, 0, left = "W", right = "E" },
}

local function key(r, c, d)
	return r .. ":" .. c .. "/" .. d
end

local function fromKey(k)
	local r, c, d = string.match(k, "^(.+):(.+)/(.)$")
	return tonumber(r), tonumber(c), d
end

COST = { [key(sr, sc, "E")] = 0 }
Q = { [key(sr, sc, "E")] = true }
SEEN = {}

local function getMin()
	local minCost, minK = math.maxinteger, nil
	for k in pairs(Q) do
		local cost = COST[k]
		if cost < minCost then
			minCost, minK = cost, k
		end
	end
	assert(minK)
	Q[minK] = nil
	SEEN[minK] = true
	return minK, minCost
end

local function move(r, c, d, cost)
	local nr, nc = r + DIRS[d][1], c + DIRS[d][2]
	if G[nr][nc] ~= "#" then
		local k = key(nr, nc, d)
		if not COST[k] or COST[k] > cost then
			COST[k] = cost
		end
		if not SEEN[k] then
			Q[k] = true
		end
	end
end

local i = 1
while true do
	local k, cost = getMin()
	local r, c, d = fromKey(k)

	if G[r][c] == "E" then
		print("p1", cost)
		break
	end
	move(r, c, d, cost + 1)
	move(r, c, DIRS[d]["left"], cost + 1001)
	move(r, c, DIRS[d]["right"], cost + 1001)
	i = i + 1
end

print("p2", p2)
