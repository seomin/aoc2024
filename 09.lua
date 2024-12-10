#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "09.txt"
if arg[1] then
	file = arg[1]
end

local function initMem()
	local mem = {}
	local fileId = 0
	local pos = 0
	local free = false
	local f = io.open(file)
	assert(f)
	local c = f:read(1)
	repeat
		local len = tonumber(c)
		if free then
			for _ = 1, len do
				mem[pos] = -1
				pos = pos + 1
			end
		else
			for _ = 1, len do
				mem[pos] = fileId
				pos = pos + 1
			end
			fileId = fileId + 1
		end
		free = not free
		c = f:read(1)
	until c == "\n"
	assert(f:close())
	return mem, pos - 1, fileId - 1
end

local function checkSum(mem)
	local sum = 0
	for k, v in pairs(mem) do
		if v ~= -1 then
			sum = sum + k * v
		end
	end
	return sum
end

-- part 1
local mem, pos, _ = initMem()
local nextFree = 0
while true do
	while mem[pos] == -1 do
		pos = pos - 1
	end
	while mem[nextFree] ~= -1 do
		nextFree = nextFree + 1
	end
	if nextFree >= pos then
		break
	end
	mem[nextFree] = mem[pos]
	mem[pos] = -1
end
p1 = checkSum(mem)
print("p1", p1)

-- part 2
local filePos, nextFileId
mem, filePos, nextFileId = initMem()
while true do
	-- print("moving", nextFileId)
	if nextFileId == 0 then
		break
	end
	while mem[filePos] ~= nextFileId do
		filePos = filePos - 1
	end

	local fileLen = 0
	while mem[filePos] == nextFileId do
		filePos = filePos - 1
		fileLen = fileLen + 1
	end
	filePos = filePos + 1
	-- print("filePos", filePos, "fileLen", fileLen)

	local freePos = 0
	local freeLen = 0
	repeat
		freePos = freePos + freeLen
		while mem[freePos] ~= -1 do
			freePos = freePos + 1
		end
		freeLen = 1
		while mem[freePos + freeLen] == -1 do
			freeLen = freeLen + 1
		end
	-- print("free", freePos, freeLen, "file", filePos, fileLen)
	until freeLen >= fileLen or freePos + fileLen > filePos
	if freePos + fileLen > filePos then
		-- print("no free block found")
		goto continue
	end

	-- copy file as block
	for i = 0, fileLen - 1 do
		mem[freePos + i] = nextFileId
		mem[filePos + i] = -1
	end

	::continue::
	nextFileId = nextFileId - 1
end
p2 = checkSum(mem)
print("p2", p2)
