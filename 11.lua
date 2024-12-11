#!/usr/bin/env lua

local file = "11.txt"
if arg[1] then
	file = arg[1]
end

local stones = {}
for line in io.lines(file) do
	for n in string.gmatch(line, "%d+") do
		if stones[n] then
			stones[n] = stones[n] + 1
		else
			stones[n] = 1
		end
	end
end

local function blink(stone)
	if tonumber(stone) == 0 then
		return { "1" }
	elseif math.fmod(#stone, 2) == 0 then
		return {
			tostring(tonumber(string.sub(stone, 1, math.floor(#stone / 2)))),
			tostring(tonumber(string.sub(stone, math.floor(#stone / 2) + 1, #stone))),
		}
	else
		return { tostring(2024 * tonumber(stone)) }
	end
end

local function length(l)
	local len = 0
	for _, count in pairs(l) do
		len = len + count
	end
	return len
end

for i = 1, 75 do
	print("blink", i)
	local newStones = {}
	for stone, count in pairs(stones) do
		-- print(stone, count)
		local blinked = blink(stone)
		for _, b in ipairs(blinked) do
			if newStones[b] then
				newStones[b] = newStones[b] + count
			else
				newStones[b] = count
			end
		end
	end
	stones = newStones
	if i == 25 then
		print("p1", length(stones))
	end
end

print("p2", length(stones))
