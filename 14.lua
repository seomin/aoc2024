#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "14.txt"
if arg[1] then
	file = arg[1]
end

local X, Y = 101, 103
if arg[2] and arg[3] then
	X = tonumber(arg[2]) or X
	Y = tonumber(arg[3]) or Y
end

Xh, Yh = math.floor(X/2), math.floor(Y/2)
T = 100

local function nums(str)
	local result = {}
	for n in string.gmatch(str, "-?%d+") do
		table.insert(result, tonumber(n))
	end
	return table.unpack(result)
end

local q = { 0, 0, 0, 0 }
for line in io.lines(file) do
	local px, py, vx, vy = nums(line)
	local finalx = math.fmod(math.fmod(px + T * vx, X) + X, X)
	local finaly = math.fmod(math.fmod(py + T * vy, Y) + Y, Y)
	-- print(finalx, finaly)
	if finalx == Xh or finaly == Yh then
		goto continue
	end
	local qx, qy = 0, 0
	if finalx > Xh then
		qx = 1
	end
	if finaly > Yh then
		qy = 1
	end
	local qq = qx * 2 + qy + 1
	q[qq] = q[qq] + 1
    ::continue::
end

-- print(q[1], q[2], q[3], q[4])

p1 = q[1] * q[2] * q[3] * q[4]

print("p1", p1)
print("p2", p2)
