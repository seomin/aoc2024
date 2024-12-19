#!/usr/bin/env lua

local p2 = 0
local file = "17.txt"
if arg[1] then
	file = arg[1]
end

A, B, C, IP = 0, 0, 0, 1
M = {}
do
	local function nums(str)
		local result = {}
		for n in string.gmatch(str, "-?%d+") do
			table.insert(result, tonumber(n))
		end
		return table.unpack(result)
	end
	local f = io.open(file)
	assert(f)
	A = nums(f:read())
	B = nums(f:read())
	C = nums(f:read())
	_ = f:read()
	M = table.pack(nums(f:read()))

	f:close()
end

function COMBO(op)
	if op < 4 then
		return op
	elseif op == 4 then
		return A
	elseif op == 5 then
		return B
	elseif op == 6 then
		return C
	else
		assert(false, "used reserved combo op " .. op)
	end
end

local function run()
	local out = {}
	-- print("start", A, B, C)
	while true do
		local inst, op = M[IP], M[IP + 1]
		-- print("n", inst, op, "reg", A, B, C)
		if not inst then
			-- print("not inst", inst)
			break
		end
		IP = IP + 2
		local cop = COMBO(op)

		if inst == 0 then -- adv
			A = math.floor(A / 2 ^ cop)
			-- print("adv", A, B, C)
		elseif inst == 1 then -- bxl
			B = B ~ op
			-- print("bxl", A, B, C)
		elseif inst == 2 then -- bst
			B = math.fmod(cop, 8)
			-- print("bst", A, B, C)
		elseif inst == 3 then -- jnz
			if A ~= 0 then
				-- print("jnz", A, B, C)
				IP = op + 1 -- 1-based index into M
			else
				-- print("not", A)
			end
		elseif inst == 4 then -- bxc
			B = B ~ C
			-- print("bxc", A, B, C)
		elseif inst == 5 then -- out
			out[#out + 1] = math.fmod(cop, 8)
		elseif inst == 6 then -- bdv
			B = math.floor(A / 2 ^ cop)
			-- print("bdv", A, B, C)
		elseif inst == 7 then -- cdv
			C = math.floor(A / 2 ^ cop)
			-- print("cdv", A, B, C)
		else
			assert(false, "invalid instruction " .. inst)
		end
	end
	-- print("end", A, B, C)
	return out
end

local function printout(out)
	local pout = "" .. out[1]
	for i = 2, #out do
		pout = pout .. "," .. out[i]
	end
	print("pout", #out, pout)
end

do
	local out = run()
	print("p1")
	printout(out)
end

local function eq(a, b)
	for i = #a, 1, -1 do
		if a[i] ~= b[i - #a + #b] then
			return #a - i
		end
	end
	return #a
end

local newA = 0
local bestE = 0
while true do
	-- print("A", newA)

	A, B, C, IP = newA, 0, 0, 1
	local out = run()
	-- printout(out)
	local e = eq(M, out)
	-- print("e", e)
	if e == #M then
		print("p2", newA)
		break
	end
	if e > bestE then
		bestE = e
		newA = newA * 8
	else
		newA = newA + 1
	end
end
