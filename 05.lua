#!/usr/bin/env lua

local rules = {}
local updates = {}
for line in io.lines("05.txt") do
	if line == "" then
		goto continue
	end

	local a, b = string.match(line, "(%d+)|(%d+)")
	if a ~= nil then
		if not rules[a] then
			rules[a] = {}
		end
		rules[a][b] = true
		goto continue
	end

	local update = {}
	for x in string.gmatch(line, "%d+") do
		table.insert(update, x)
	end
	table.insert(updates, update)
	::continue::
end

local function valid(update)
	for i = 1, #update do
		for j = i + 1, #update do
			local a, b = update[i], update[j]
			if rules[b] and rules[b][a] then
				return false
			end
		end
	end
	return true
end

local function middle(update)
	local index = math.floor(#update / 2) + 1
	-- print("middle of", #update, index)
	return update[index]
end

local sum = 0
for _, update in pairs(updates) do
	if valid(update) then
		sum = sum + middle(update)
	end
end

print("p1", sum)
