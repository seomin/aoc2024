#!/usr/bin/env lua

local canBuild
canBuild = function(target, currentValue, index, operands, part)
	if index > #operands then
		return target == currentValue
	end
	if currentValue > target then
		return false
	end

	local currentOp = operands[index]
	if canBuild(target, currentValue + currentOp, index + 1, operands, part) then
		return true
	end

	if canBuild(target, currentValue * currentOp, index + 1, operands, part) then
		return true
	end

	if part == 2 then
		local newValue = tonumber(tostring(currentValue) .. tostring(currentOp))
		if canBuild(target, newValue, index + 1, operands, part) then
			return true
		end
	end
	return false
end

local sum1 = 0
local sum2 = 0
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

	if canBuild(target, operands[1], 2, operands, 1) then
		sum1 = sum1 + target
	end
	if canBuild(target, operands[1], 2, operands, 2) then
		sum2 = sum2 + target
	end
end

print("p1", sum1)
print("p2", sum2)
