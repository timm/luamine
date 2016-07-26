require "lib"

local IGNORE = "?"    -- marks which columns or cells to ignore
local NROWS  = 0      -- counter for unique row ids 
local function SYM()  return {n=0, counts={}, most=0, mode=nil } end
local function NUM()  return {n=0, mu=0, m2=0, up=-1e32, lo=1e32} end
local function TBL(t) return {things={}, _rows={}, less={}, ynums={}, xnums={},
			      more={},   spec=t,  outs={},
			      ins={},    syms={}, nums={}} end
local function ROW(t)
  NROWS = NROWS+1
  return {id=NROWS, cells=t, normy={}, normx={}} 
end

local function nump(x) return x.mu ~= nil end
----------------------------------------------------------------
local function sym1(i,one)
  if one ~= IGNORE then
    i.n = i.n + 1
    local old = i.counts[one]
    local new = old and old + 1 or 1
    i.counts[one] = new
    if new > i.most then
      i.most, i.mode = new,one
end end end

local function num1(i,one)
  if one ~= IGNORE then
    i.n = i.n + 1
    if one < i.lo then i.lo = one end
    if one > i.up then i.up = one end
    local delta = one - i.mu
    i.mu = i.mu + delta / i.n
    i.m2 = i.m2 + delta * (one - i.mu)
end end

local function thing1(i,one)
  return (nump(i) and num1 or sym1)(i,one)
end

local function sym0(inits) return map2(inits, SYM(), sym1) end
local function num0(inits) return map2(inits, NUM(), num1) end

local function sd(i)     return i.n <= 1 and 0 or (i.m2 / (i.n - 1))^0.5 end
local function norm(i,x)
  if x==IGNORE then return x end
  return (x - i.lo) / (i.up - i.lo + 1e-32)     end

local function ent(i)
  local e = 0
  for _,f in pairs(i.counts) do
    e = e + (f/i.n) * math.log((f/i.n), 2)
  end
  return -1*e
end
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
    local spec =  { 
      {what= "%$", who= num0, wheres= {t.things, t.ins,  t.nums, t.xnums  }},
      {what= "<",  who= num0, wheres= {t.things, t.outs, t.nums, t.less, t.ynums}},
      {what= ">",  who= num0, wheres= {t.things, t.outs, t.nums, t.more, t.ynums}},
      {what= "=",  who= sym0, wheres= {t.things, t.outs, t.syms  }},
      {what= "",   who= sym0, wheres= {t.things, t.ins,  t.syms  }}}
    for _,want in pairs(spec) do
      if string.find(cell,want.what) ~= nil then
	return want.who, want.wheres
  end end end
  ------------------------------
  local function header(t)
    for col,cell in ipairs(cells) do
      local who, wheres = whoWheres(cell,t)
      local thing = who()
      thing.col = col
      thing.txt = cell
      for _,where in ipairs(wheres) do
	where[ #where + 1 ] = thing
    end end
    return t
  end
  ------------------------------
  local function data(t,row) 
    t._rows[row.id] = row
    for _,thing in pairs(t.things) do
      local passed,err = pcall(function () thing1(thing, cells[thing.col]) end)
      if not passed then
	print('read fail>', thing.txt, thing.col, cells[thing.col], err)
      end
    end
    return t
  end
  -----------------------------
  return t and data(t, ROW(cells)) or header(TBL(cells))
end

function csv2tbl(f,     t)
  for row in csv(f) do t = row1(row, t) end
  return t
end

function _csv()
  local n=0
  for line in csv('../data/weather.csv') do
    n= n+1
    if line then
      print(n,#line, table.concat(line,","))
end end end

function _row()
  local t = csv2tbl('../data/autos.arff')
  for _,thing in pairs(t.nums) do
    print(thing.txt, {mu=f5(thing.mu), sd=f5(sd(thing)), lo=thing.lo,up=thing.up})
  end
  for _,thing in pairs(t.syms) do
    print(thing.txt, {mode=thing.mode, most=thing.most,
		      ent=f5(ent(thing))},thing.counts)
  end
  print(t.ynums)
  for _,row in pairs(t._rows) do
    print(row.normy)
  end
  normys(t)
  nwhere(t._rows)
end

function normys(t)
  for _,row in pairs(t._rows) do
    for _,thing in pairs(t.ynums) do
      row.normy[#row.normy+1] =
         norm(thing, row.cells[thing.col]) end end
  return t
end
 
function nwhere( population, cull,stop)
  local cull= cull or 0.5
  local stop= stop or 20
  ------------------------------------------------------
  local function  dist(r1,r2)
    local sum, n = 0,  0
    for i, y1 in pairs(r1.normy) do
      local y2 = r2.normy[i]
      if not (y2 == IGNORE and y1 == IGNORE) then
	
	if y2==IGNORE then
	  y2 = y1 < 0.5 and 1 or 0 end
	if y1==IGNORE then
	  y1 = y2 < 0.5 and 1 or 0 end
	sum = sum + (y1 -  y2)^2
	n = n + 1
    end end
    return sum^0.5 / n^0.5
  end
  ------------------------------------------------------
  local function furthest(r1, items)
    local out,most=r1,0
    for _,r2 in pairs(items) do
      local d = dist(r1,r2)
      if d > most then
	out,most = r2,d end end
    return out
  end
  ------------------------------------------------------
  local function split(items, mid,west,east,redo)
    redo= redo or 20
    assert(redo > 0,"max depth exceeded")
    local cos = function (a,b,c) return (a*a + c*c - b*b) / (2*c + 0.0001) end
    local west = west or furthest(any(items),items)
    local east = east or furthest(west, items)
    while east.id == west.id do
      east = any(items)
    end
    local c = dist(west,east)
    local xs = {}
    for n,item in pairs(items) do
      local a = dist(item,west)
      local b = dist(item,east)
      xs[ item.id ] = cos(a,b,c)
      if a > c then
	dot(">".. n.." ")
	return split(items, mid, west, item, redo-1)
      elseif b > c then
	dot("<"..n.." ")
	return split(items, mid, item, east, redo-1)
    end end
    table.sort(items,function (r1,r2) return xs[r1.id] < xs[r2.id] end)
    lefts=sub(items,1,mid)
    rights=sub(items,mid+1)
    print(#items, #lefts, #rights, #lefts+#rights)
    return west, east, sub(items,1,mid), sub(items,mid+1)
  end
  ------------------------------------------------------
  local function cluster(items,out)
    if #items < max((#population)^cull,stop) then
      out[#out+1] = items
    else
      local west,east,left,right = split(items, math.floor(#items/2))
      cluster(left,out)
      cluster(right,out)
  end end
  ------------------------------------------------------
  return cluster(copy(population), {})
end
 
if arg[1]=='--run' then
  loadstring(arg[2] .. '()')()
end


rogue()
