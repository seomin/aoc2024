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

local robots = {}
local q = { 0, 0, 0, 0 }
for line in io.lines(file) do
	local px, py, vx, vy = nums(line)
	table.insert(robots, {px, py, vx, vy})
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

local function ins(board, x, y)
	if not board[x] then
		board[x] = { y = 1}
	elseif not board[x][y] then
		board[x][y] = 1
	else
		board[x][y] = board[x][y] + 1
	end
end
local function show()
	local board = {}
	for _, robot in pairs(robots) do
		ins(board, robot[1], robot[2])
	end
	for y = 0, Y do
		local line = ""
		for x = 0, X do
			local char = "."
			if board[x] and board[x][y] then
				char = "x"
			end
			line = line .. char
		end
		print(line)
	end
end

local function update()
	for _, robot in pairs(robots) do
		robot[1] = math.fmod(robot[1] + robot[3] + X, X)
		robot[2] = math.fmod(robot[2] + robot[4] + Y, Y)
	end
end

-- These numbers showed interesting patterns
-- 23 + 103*t
-- 48 + 101*t

local t = 0
show()
while true do
	t = t + 1
	update()
	while math.fmod(t-23, 103) ~= 0 and math.fmod(t-48, 101) ~= 0 do
		t = t + 1
		update()
	end
	print("t", t)
	show()
	_ = io.read()
end

