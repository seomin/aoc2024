#!/usr/bin/env lua

local function eval(eq)
	local eqString = "result = " .. eq
	-- print(eqString)
	local eqF = load(eqString)
	assert(eqF, "could not load")
	eqF()
	return result
end

local canBuild
canBuild = function(target, currentEq, index, operands)
	local currentValue = eval(currentEq)
	if index > #operands then
		return target == currentValue
	end
	if currentValue > target then
		return false
	end

	if canBuild(target, "(" .. currentEq .. ")+" .. tostring(operands[index]), index + 1, operands) then
		return true
	end

	if canBuild(target, "(" .. currentEq .. ")*" .. tostring(operands[index]), index + 1, operands) then
		return true
	end
	return false
end

local sum = 0
local file = "07.txt"
if arg[1] then
	file = arg[1]
end
for line in io.lines(file) do
	local target, numbers = string.match(line, "^(%d+): (.+)$")
	local operands = {}
	for number in string.gmatch(numbers, "%d+") do
		table.insert(operands, tonumber(number))
	end
	target = tonumber(target)

	if canBuild(target, tostring(operands[1]), 2, operands) then
		sum = sum + target
	end
end

print("p1", sum)
