local l1 = {}
local l2 = {}
for l in io.lines("01.txt") do
	local a, b = string.match(l, "(%d+)%s+(%d+)")
	l1[#l1 + 1] = a
	l2[#l2 + 1] = b
end

table.sort(l1)
table.sort(l2)

local sum = 0
for i = 1, #l1 do
	local a, b = l1[i], l2[i]
	local d = math.abs(a - b)
	sum = sum + d
end

print("p1", sum)

local counts = {}
setmetatable(counts, {
	__index = function(t, k)
		local c = 0
		for _, v in ipairs(l2) do
			if v == k then
				c = c + 1
			end
		end
		t[k] = c
		return c
	end,
})
local sim = 0
for _, x in ipairs(l1) do
	local c = counts[x]
	sim = sim + (x * c)
end
print("p2", sim)
