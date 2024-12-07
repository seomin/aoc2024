#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local enabled = true
for line in io.lines("03.txt") do
	local i = 1
	while true do
		local j, _, a, b = string.find(line, "mul%((%d%d?%d?),(%d%d?%d?)%)", i)
		local k = string.find(line, "do()", i, true)
		local l = string.find(line, "don't()", i, true)

		if j == nil and k == nil and l == nil then
			break
		end
		local min = math.min(j or math.maxinteger, k or math.maxinteger, l or math.maxinteger)
		if k == min then
			enabled = true
		elseif l == min then
			enabled = false
		elseif enabled then
			local sum = tonumber(a) * tonumber(b)
			p1 = p1 + sum
			p2 = p2 + sum
		else
			local sum = tonumber(a) * tonumber(b)
			p1 = p1 + sum
		end
		i = min + 1
	end
end

print("p1", p1)
print("p2", p2)
