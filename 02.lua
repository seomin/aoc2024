#!/usr/bin/env lua

local function is_safe(ds)
	if ds[1] < ds[2] then
		-- print("inc")
		for i = 1, (#ds - 1) do
			local d = ds[i + 1] - ds[i]
			if d < 1 or d > 3 then
				return false
			end
		end
	else
		-- print("decr")
		for i = 1, (#ds - 1) do
			local d = ds[i] - ds[i + 1]
			if d < 1 or d > 3 then
				return false
			end
		end
	end
	return true
end

local function is_safe_2(ds)
	if is_safe(ds) then
		return true
	end
	for i = 1, #ds do
		local dss = {}
		table.move(ds, 1, i - 1, 1, dss)
		table.move(ds, i + 1, #ds, i, dss)
		if is_safe(dss) then
			return true
		end
	end
	return false
end

local safes = 0
local safes_2 = 0
for l in io.lines("02.txt") do
	local ds = {}
	for d in string.gmatch(l, "%d+") do
		table.insert(ds, tonumber(d))
	end

	if is_safe(ds) then
		-- print("safe", l)
		safes = safes + 1
	else
		-- print("unsafe", l)
	end
	if is_safe_2(ds) then
		-- print("safe 2", l)
		safes_2 = safes_2 + 1
	else
		-- print("unsafe 2", l)
	end
end

print("p1", safes)
print("p2", safes_2)
