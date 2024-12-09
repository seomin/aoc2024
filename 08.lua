#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "08.txt"
if arg[1] then
	file = arg[1]
end

local antennas = {}

local row = 1
local maxRow = row
local maxCol = 0
for line in io.lines(file) do
	local col = 1
	for char in string.gmatch(line, ".") do
		if char ~= "." then
			if not antennas[char] then
				antennas[char] = { { row, col } }
			else
				antennas[char][#antennas[char] + 1] = { row, col }
			end
		end
		maxCol = math.max(maxCol, col)
		col = col + 1
	end
	maxRow = math.max(maxRow, row)
	row = row + 1
end

local antinodes = {}
local antinodes2 = {}

local function inBounds(r, c)
	return r > 0 and r <= maxRow and c > 0 and c <= maxCol
end

local gcd
gcd = function(a, b)
	if b == 0 then
		return a
	end
	if a == b then
		return a
	end
	if a < b then
		return gcd(b, a)
	end
	return gcd(b, math.fmod(a, b))
end

for _, charAntennas in pairs(antennas) do
	for i = 1, #charAntennas - 1 do
		for j = i + 1, #charAntennas do
			-- for each pair of same antennas
			local antA, antB = charAntennas[i], charAntennas[j]
			local ar, ac = table.unpack(antA)
			local br, bc = table.unpack(antB)
			local dr, dc = br - ar, bc - ac

			local r1, c1 = ar - dr, ac - dc
			local antinode = tostring(r1) .. ":" .. tostring(c1)
			if inBounds(r1, c1) and not antinodes[antinode] then
				p1 = p1 + 1
				antinodes[antinode] = true
				-- print("new", r1, c1, ar, ac, br, bc)
			end

			local r2, c2 = br + dr, bc + dc
			antinode = tostring(r2) .. ":" .. tostring(c2)
			if inBounds(r2, c2) and not antinodes[antinode] then
				p1 = p1 + 1
				antinodes[antinode] = true
				-- print("new", r2, c2, ar, ac, br, bc)
			end

			-- part 2
			local g = gcd(math.abs(dr), math.abs(dc))
			dr = math.modf(dr / g)
			dc = math.modf(dc / g)
			local r, c = ar, ac
			while inBounds(r, c) do
				antinode = tostring(r) .. ":" .. tostring(c)
				if not antinodes2[antinode] then
					p2 = p2 + 1
					antinodes2[antinode] = true
				end
				r, c = r + dr, c + dc
			end
			r, c = ar - dr, ac - dc
			while inBounds(r, c) do
				antinode = tostring(r) .. ":" .. tostring(c)
				if not antinodes2[antinode] then
					p2 = p2 + 1
					antinodes2[antinode] = true
				end
				r, c = r - dr, c - dc
			end
		end
	end
end

print("p1", p1)
print("p2", p2)
