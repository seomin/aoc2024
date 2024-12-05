#!/usr/bin/env lua

local safes = 0
for l in io.lines("02.txt") do
	local ds = {}
	for d in string.gmatch(l, "%d+") do
		table.insert(ds, tonumber(d))
	end

	local safe = true
	if ds[1] < ds[2] then
		-- print("inc")
		for i = 1, (#ds - 1) do
			local d = ds[i + 1] - ds[i]
			if d < 1 or d > 3 then
				safe = false
				break
			end
		end
	else
		-- print("decr")
		for i = 1, (#ds - 1) do
			local d = ds[i] - ds[i + 1]
			if d < 1 or d > 3 then
				safe = false
				break
			end
		end
	end
	if safe then
		print("safe", l)
		safes = safes + 1
	else
		print("unsafe", l)
	end
end

print("p1", safes)
