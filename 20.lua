#!/usr/bin/env lua

local p1 = 0
local p2 = 0
local file = "20.txt"
if arg[1] then
	file = arg[1]
end

G = {}
local sr, sc, er, ec
local r, c = 1, 1
for line in io.lines(file) do
	G[r] = {}
	c = 1
	for char in string.gmatch(line, ".") do
		if char == "S" then
			sr, sc = r, c
		elseif char == "E" then
			er, ec = r, c
		end
		G[r][c] = char
		c = c + 1
	end
	r = r + 1
end

local function key(r, c)
	return r .. ":" .. c
end

WAY = { [key(sr, sc)] = 0 }
L = 0
DIRS = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }

r, c = sr, sc
while true do
	if G[r][c] == "E" then
		break
	end
	for _, dir in pairs(DIRS) do
		local dr, dc = dir[1], dir[2]
		local nr, nc = r + dr, c + dc
		if G[nr][nc] ~= "#" and not WAY[key(nr, nc)] then
			WAY[key(nr, nc)] = WAY[key(r, c)] + 1
			L = L + 1
			r, c = nr, nc
			break
		end
	end
end

print("L", L)

local function fromKey(k)
	local r, c = string.match(k, "(%d+):(%d+)")
	return tonumber(r), tonumber(c)
end

CHEATS = {}
local function findCheats(r, c, d, MAX_CD)
	-- print("findCheats", r, c, d)
	local Q = { { r, c, 0 } }
	local SEEN = { [key(r, c)] = true }

	local q = table.remove(Q, 1)
	while q do
		local qr, qc, cd = table.unpack(q)
		-- print("q", qr, qc, cd)
		if cd <= MAX_CD and WAY[key(qr, qc)] then
			local impr = WAY[key(qr, qc)] - d - cd
			if impr > 0 then
				local ckey = key(r, c).."-"..key(qr, qc)
				if not CHEATS[ckey] or CHEATS[ckey] < impr then
					CHEATS[ckey] = impr
				end
			end
		end
		if cd ~= MAX_CD then -- and (G[qr][qc] == "#" or cd == 0) then
			for _, dir in pairs(DIRS) do
				local dr, dc = dir[1], dir[2]
				local nr, nc = qr + dr, qc + dc
				if not G[nr] or not G[nr][nc] then
					goto continue
				end
				if SEEN[key(nr, nc)] then
					goto continue
				end
				if cd == 0 and G[nr] and G[nr][nc] ~= "#" then
					goto continue
				end
				table.insert(Q, { nr, nc, cd + 1 })
				SEEN[key(nr, nc)] = true
				::continue::
			end
		end
		q = table.remove(Q, 1)
	end
end

for w, d in pairs(WAY) do
	local r, c = fromKey(w)
	findCheats(r, c, d, 2)
end
for cheat, impr in pairs(CHEATS) do
	if impr >= 100 then
		p1 = p1 + 1
	end
end
print("p1", p1)

for w, d in pairs(WAY) do
	local r, c = fromKey(w)
	findCheats(r, c, d, 20)
end
local ncheats = 0
local byImpr = {}
for cheat, impr in pairs(CHEATS) do
	ncheats = ncheats + 1
	-- print("cheat", from, to, impr)
	if byImpr[impr] then byImpr[impr] = byImpr[impr] + 1 else byImpr[impr] = 1 end
	if impr >= 100 then
		p2 = p2 + 1
	end
end

for d, c in pairs(byImpr) do
	if d >= 50 then
		print("impr", d, c)
	end
end

print(CHEATS["4:2-8:6"])

-- 980161 too low
print("p2", p2)
