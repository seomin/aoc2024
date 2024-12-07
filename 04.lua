#!/usr/bin/env lua

local m = {}
local i = 1
for line in io.lines("04.txt") do
	m[i] = {}
	local j = 1
	for c in string.gmatch(line, "[XMAS]") do
		m[i][j] = c
		j = j + 1
	end
	i = i + 1
end

local function charAt(r, c, char)
	if r > #m or r < 1 then
		return false
	end
	if c > #m[r] or c < 1 then
		return false
	end
	return m[r][c] == char
end

local function mas(r, c, dr, dc)
	if charAt(r + dr, c + dc, "M") and charAt(r + 2 * dr, c + 2 * dc, "A") and charAt(r + 3 * dr, c + 3 * dc, "S") then
		return 1
	end
	return 0
end

local function crossMas(r, c)
	if
		not (
			(charAt(r - 1, c - 1, "M") and charAt(r + 1, c + 1, "S"))
			or (charAt(r - 1, c - 1, "S") and charAt(r + 1, c + 1, "M"))
		)
	then
		-- print("no \\ at", r, c)
		return 0
	end
	if
		not (
			(charAt(r - 1, c + 1, "M") and charAt(r + 1, c - 1, "S"))
			or (charAt(r - 1, c + 1, "S") and charAt(r + 1, c - 1, "M"))
		)
	then
		-- print("no / at", r, c)
		return 0
	end
	return 1
end

local xmas = 0
local x_mas = 0
for r, row in pairs(m) do
	for c, char in pairs(row) do
		if char == "X" then
			xmas = xmas + mas(r, c, -1, -1)
			xmas = xmas + mas(r, c, -1, 0)
			xmas = xmas + mas(r, c, -1, 1)
			xmas = xmas + mas(r, c, 0, -1)
			xmas = xmas + mas(r, c, 0, 1)
			xmas = xmas + mas(r, c, 1, -1)
			xmas = xmas + mas(r, c, 1, 0)
			xmas = xmas + mas(r, c, 1, 1)
		elseif char == "A" then
			x_mas = x_mas + crossMas(r, c)
		end
	end
end

print("p1", xmas)
print("p2", x_mas)
