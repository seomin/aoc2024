#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "10.txt"
if arg[1] then
	file = arg[1]
end

local map = {}
for line in io.lines(file) do
	local row = {}
	for c in string.gmatch(line, ".") do
		table.insert(row, tonumber(c))
	end
	table.insert(map, row)
end

local function find9s(r, c, n, nines)
	if not map[r] or map[r][c] ~= n then
		return
	end
	if n == 9 then
		local k = tostring(r) .. ":" .. tostring(c)
		if not nines[k] then
			nines[k] = 1
		else
			nines[k] = nines[k] + 1
		end
		return
	end
	find9s(r + 1, c, n + 1, nines)
	find9s(r - 1, c, n + 1, nines)
	find9s(r, c + 1, n + 1, nines)
	find9s(r, c - 1, n + 1, nines)
end

for r, row in ipairs(map) do
	for c, n in ipairs(row) do
		if n == 0 then
			local nines = {}
			find9s(r, c, 0, nines)
			for _, count in pairs(nines) do
				p1 = p1 + 1
				p2 = p2 + count
			end
		end
	end
end

print("p1", p1)
print("p2", p2)
