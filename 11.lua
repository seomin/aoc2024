#!/usr/bin/env lua

local file = "11.txt"
if arg[1] then
	file = arg[1]
end

local stones = {}
for line in io.lines(file) do
	for n in string.gmatch(line, "%d+") do
		table.insert(stones, n)
	end
end

local newStones = {}
for i = 1, 75 do
	print("blink", i)
	for _, stone in ipairs(stones) do
		if tonumber(stone) == 0 then
			table.insert(newStones, "1")
		elseif math.fmod(#stone, 2) == 0 then
			table.insert(newStones, tostring(tonumber(string.sub(stone, 1, math.floor(#stone / 2)))))
			table.insert(newStones, tostring(tonumber(string.sub(stone, math.floor(#stone / 2) + 1, #stone))))
		else
			table.insert(newStones, tostring(2024 * tonumber(stone)))
		end
	end
	stones = newStones
	newStones = {}
	if i == 25 then
		print("p1", #stones)
	end
end

print("p2", #stones)
