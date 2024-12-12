#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "12.txt"
if arg[1] then
	file = arg[1]
end

local function key(r, c)
	return tostring(r) .. ":" .. tostring(c)
end

local R, C = 0, 0
local map = {}
do -- init
	local r = 1
	for line in io.lines(file) do
		local c = 1
		for char in string.gmatch(line, ".") do
			local k = key(r, c)
			map[k] = {char, false}
			C = math.max(c, C)
			c = c + 1
		end
		R = math.max(r, R)
		r = r + 1
	end
end

local dirs = { {-1, 0, "u" }, {1, 0, "d"}, {0, -1, "l"}, {0, 1, "r"} }

local function vFence(r, ca, cb)
	assert(tonumber(ca) < tonumber(cb))
	return r .. "," .. ca .. "|" .. cb
end

local function hFence(ra, rb, c)
	assert(tonumber(ra) < tonumber(rb))
	return ra .. "_" .. rb .. "," .. c
end

local function insertFence(fences, r, c, d)
	-- d is the direction we were going to arrive at r,c, so if we went up, we are coming from down
	local fence
	if d == "d" then
		fence = hFence(r-1, r, c)
	elseif d == "u" then
		fence = hFence(r, r+1, c)
	elseif d == "r" then
		fence = vFence(r, c-1, c)
	elseif d == "l" then
		fence = vFence(r, c, c+1)
	end
	fences[fence] = true
end

local function flood(char, r, c, d, fences)
	if not map[key(r, c)] then
		insertFence(fences, r, c, d)
		return 0
	end
	local ch, visited = table.unpack(map[key(r,c)])
	if ch ~= char then
		insertFence(fences, r, c, d)
		return 0
	elseif visited then
		return 0
	end
	map[key(r,c)] = {char, true}

	local area = 1
	for _, dir in ipairs(dirs) do
		local dr, dc, dd = table.unpack(dir)
		local a = flood(char, r+dr, c+dc, dd, fences)
		area = area + a
	end
	return area
end

local function len(fences)
	local l = 0
	for f in pairs(fences) do
		l = l + 1
		-- print("	f", f)
	end
	return l
end

local function plant(r, c)
	local k = key(r,c)
	return map[k] and map[k][1]
end

local function countSides(fences)
	local sides = 0
	for fence in pairs(fences) do
		-- print("new side with fence", fence)
		fences[fence] = nil
		local ra, rb, c = string.match(fence, "(%d+)_(%d+),(%d+)")
		if ra then
			local cc = c + 1
			local pa, pb = plant(ra, c), plant(rb, c)
			while fences[hFence(ra, rb, cc)] and (plant(ra,cc) == pa or plant(rb,cc) == pb) do
				fences[hFence(ra, rb, cc)] = nil
				cc = cc + 1
			end
			cc = c - 1
			while fences[hFence(ra, rb, cc)] and (plant(ra,cc) == pa or plant(rb,cc) == pb) do
				fences[hFence(ra, rb, cc)] = nil
				cc = cc - 1
			end
		else
			local r, ca, cb = string.match(fence, "(%d+),(%d+)|(%d+)")
			local rr = r + 1
			local pa, pb = plant(r, ca), plant(r, cb)
			while fences[vFence(rr, ca, cb)] and (plant(rr, ca) == pa or plant(rr, cb) == pb) do
				fences[vFence(rr, ca, cb)] = nil
				rr = rr + 1
			end
			rr = r - 1
			while fences[vFence(rr, ca, cb)] and (plant(rr, ca) == pa or plant(rr, cb) == pb) do
				fences[vFence(rr, ca, cb)] = nil
				rr = rr - 1
			end

		end
		sides = sides + 1
	end
	return sides
end

for r = 1, R do
	for c = 1, C do
		local char, visited = table.unpack(map[key(r, c)])
		if visited then
			goto continue
		end

		local fences = {}
		local area = flood(char, r, c, nil, fences)
		local peri = len(fences)
		local sides = countSides(fences)
		-- print(char, area, peri, sides)
		p1 = p1 + area*peri
		p2 = p2 + area*sides
	    ::continue::
	end
end

print("p1", p1)
print("p2", p2)
