#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local fileName = "13.txt"
if arg[1] then
	fileName = arg[1]
end

local function solve(r, s, t, u, v, w)
	local q1 = t * v - s * w
	local q2 = r * v - s * u
	local q3 = t * u - r * w
	local q4 = s * u - r * v
	if math.fmod(q1, q2) == 0 and math.fmod(q3, q4) == 0 then
		assert(s ~= 0)
		assert(s * u ~= r * v)
		local a = math.modf(q1 / q2)
		local b = math.modf(q3 / q4)
		return 3 * a + b
	end
	return 0
end

local file = io.open(fileName)
assert(file)
repeat
	local r, u = string.match(file:read(), "Button A: X%+(%d+), Y%+(%d+)")
	local s, v = string.match(file:read(), "Button B: X%+(%d+), Y%+(%d+)")
	local t, w = string.match(file:read(), "Prize: X=(%d+), Y=(%d+)")
	p1 = p1 + solve(r, s, t, u, v, w)
	p2 = p2 + solve(r, s, t + 10000000000000, u, v, w + 10000000000000)
until not file:read("l")
file:close()

print("p1", p1)
print("p2", p2)

-- 94a+22b=8400
-- 34a+67b=5400
--
-- r*a + s*b = t
-- u*a + v*b = w
--
-- a = (t v - s w)/(r v - s u) and b = (t u - r w)/(s u - r v) and s u!=r v and s!=0
