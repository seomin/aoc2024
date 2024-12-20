#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "19.txt"
if arg[1] then
	file = arg[1]
end
local towels = {}

local f = io.open(file)
assert(f)

local tLine = f:read()
for t in string.gmatch(tLine, "%w+") do
	towels[#towels + 1] = t
end
table.sort(towels)

DP = {}
local function canBuild(pattern)
	local n = 0
	if DP[pattern] then
		return DP[pattern]
	end
	for _, towel in pairs(towels) do
		if string.match(pattern, "^" .. towel .. "$") then
			n = n + 1
		end
		if string.match(pattern, "^" .. towel) then
			n = n + canBuild(string.sub(pattern, string.len(towel) + 1))
		end
	end
	DP[pattern] = n
	return n
end

_ = f:read()
local pattern = f:read()
while pattern do
	local n = canBuild(pattern)
	-- print(pattern, n)
	p2 = p2 + n
	if n > 0 then
		p1 = p1 + 1
	end
	pattern = f:read()
end

print("p1", p1)
print("p2", p2)
