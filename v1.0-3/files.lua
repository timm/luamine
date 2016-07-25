local IGNORE = "?"             -- columns, cells to ignore
local NROWS  = 0 -- counter for unique row ids (do not change)
local SYM    = {n=0, counts={}, most=0, mode=nil }
local NUM    = {n=0, mu=0, m2=0, up=-1e32, lo=1e32}
local ROW    = {id=nil, cells=nil, normy={}, normx={}}
local TBL    = {things={}, rows={}, less={}, more={},
	        outs={}, ins={}, syms={}, nums{}}
----------------------------------------------------------------
local function same(x) return x end

local function map(t,f)
  if t then
    for i,v in pairs(t) do f(v)
end end end

local function collect(t,f)
  out={}
  if t then  
    for i,v in pairs(t) do out[i] = f(v) end end
  return out
end 

local function copy(t)
  return collect(t,same)
end

----------------------------------------------------------------
local function thing1(i,one)
  local function sym1()
    local old = i.counts[one]
    local new = old and old + 1 or 1
    i.counts[one] = new
    if new > i.most then
      i.most, i.mode = new,one
    end
  end
  local function num1()
    if one < i.lo then i.lo = one end
    if one > i.up then i.up = one end
    local delta = one - i.mu
    i.mu = i.mu + delta / i.n
    i.m2 = i.m2 + delta * (one - i.mu)
  end
  if one ~= IGNORE then
    i.n = i.n + 1
    if i.mu == nil then sym1() else num1() end
    return i
end end

local function things(i,t)
  map(t, function (one) thing1(i,one) end)
  return i
end

local function sym0(t) return things(copy(SYM),t) end
local function num0(t) return things(copy(NUM),t) end

local function sd(i)     return i.n <= 1 and 0 or (i.m2 / (i.n - 1))^0.5 end
local function norm(i,x) return (x - i.lo) / (i.up - i.lo + 1e-32)     end

----------------------------------------------------------------
local function csv(f)
  local sep      = "([^,]+)"       -- cell seperator
  local dull     = "['\"\t\n\r]*"  -- white space, quotes
  local padding  = "%s*(.-)%s*"    -- space around words
  local comments = "#.*"           -- comments
  if f then io.input(f) end  
  local first,line = true, io.read()
  local cache,use  = {},{}
  return function ()
    while line ~= nil do
      local row = {}
      line = line:gsub(padding,"%1")
	         :gsub(dull,"")
	         :gsub(comments,"")       
      if line ~= "" then
	cache[#cache + 1] = line
	if string.sub(line,-1) ~= "," then
	  local lines = table.concat(cache)
	  local col   = 0
	  for word in string.gmatch(lines,sep) do
	    col = col + 1
	    if first then
	      use[col] = string.find(word,IGNORE) == nil
	    end
	    if use[col] then
	      row[#row+1] = tonumber(word) or word
	    end
	  end	  
	  first, cache = false, {}
      end end
      line = io.read()
      if #row > 0 then return row end
end end end

----------------------------------------------------------------
local function row1(cells, t)
  local function whoWheres(cell,t)
    local wants =  { 
      {what= "$", who= num0, wheres= {t.things, t.ins,  t.nums  }},
      {what= "<", who= num0, wheres= {t.things, t.outs, t.nums, t.less}},
      {what= ">", who= num0, wheres= {t.things, t.outs, t.nums, t.more}},
      {what= "=", who= sym0, wheres= {t.things, t.outs, t.syms  }},
      {what= "",  who= sym0, wheres= {t.things, t.ins,  t.syms  }}}
    for _,want in pairs(wants) do
      if string.find(cell,want.what) ~= nil then
	return want.who, want.wheres
  end end end
  ------------------------------
  local function header(t)
    for col,cell in ipairs(cells) do
      local who, wheres = whoWheres(cell,t)
      local thing = who()
      thing.col = col
      for _,where in ipair(wheres) do
	where[ #where + 1 ] = thing
    end end
    return t
  end
  ------------------------------
  local function data(t,row) 
    NROWS         = NROWS+1
    row.id        = nrows
    row.cells     = cells
    t.rows[nrows] = row
    for _,thing in pairs(t.things) do
      thing1(thing, cells[thing.col])
    end
    return t
  end
  -----------------------------
  return t and data(t,copy(ROW)) or header(copy(TBL))
end

local function csv2tbl(f,     t)
  for row in csv(f) do
    t = row1(row, t)
  end
  return t
end


-- n=0
-- for line in cells() do
--   n= n+1
--   if line then
--     print(n,#line, table.concat(line,","))
--   end
-- end

return {map=map,same=same,
	num0=num0, sym0=sym0,
	thing1 = thing1,
	sd=sd, norm=norm,
	row1=row1,
	csv2tbl=csv2tbl, csv=csv}
