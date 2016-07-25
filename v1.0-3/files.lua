SEP      = "([^,]+)"       -- cell seperator
DULL     = "['\"\t\n\r]*"  -- white space, quotes
IGNORE   = "?"             -- columns, cells to ignore
PADDING  = "%s*(.-)%s*"    -- space around words
COMMENTS = "#.*"           -- comments
WANTS    = function (t)
    return  {
      {who= "_X_", what= sym0, wheres= {t.things, t.ins,  t.syms  }},
      {who= "$",   what= num0, wheres= {t.things, t.ins,  t.nums  }},
      {who= "<",   what= num0, wheres= {t.things, t.outs, t.nums, t.less}},
      {who= ">",   what= num0, wheres= {t.things, t.outs, t.nums, t.more}},
      {who= "=",   what= sym0, wheres= {t.things, t.outs, t.syms  }}}
end

local nrows=0 -- counter for unique row ids (do not change)

----------------------------------------------------------------
function csv(f)
  if f then io.input(f) end  
  local first,line = true, io.read()
  local cache,use  = {},{}
  return function ()
    while line ~= nil do
      local row = {}
      line = line:gsub(PADDING,"%1")
	         :gsub(DULL,"")
	         :gsub(COMMENTS,"")       
      if line ~= "" then
	cache[#cache + 1] = line
	if string.sub(line,-1) ~= "," then
	  local lines = table.concat(cache)
	  local col   = 0
	  for word in string.gmatch(lines,SEP) do
	    col = col + 1
	    if first then
	      use[col] = string.find(word,ignore) == nil
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

function csv2tbl(f,     t)
  for row in csv(f) do
    t = row1(t,row)
  end
  return t
end

function row1(row, t)
  local function whatWhere(cell,wanted)
    for _,want in pairs(wanted) do
      if string.find(cell,what.who) ~= nil then
	return want.what, want.wheres
    end end
    return wanted[1].what, wanted[1].wheres
  end
  ------------------------------
  local function header(row,t)
    wanted= WANTS(t)
    for col,cell in ipairs(row) do
      what, wheres = whatWheres(cell, wanted)
      local thing = what()
      thing.col = col
      for _,where in ipair(wheres) do
	where[ #where + 1 ] = thing
    end end
    return t
  end
  ------------------------------
  local function data(row,t) 
    nrows = nrows+1
    local new= {id=nrows, cells=row,normy={},normx={}}
    t.rows[nrows] = new
    for _,thing in pairs(t.things) do
      thing1(thing, row[thing.col])
    end
    return t
  end
  -----------------------------
  if t then
    return data(row,t)
  else
    return header(row,{things={}, rows={}, less={}, more={},
		       outs={},   ins={},  syms={}, nums{} })
  end
end






      
function map(t,f) for i,v in pairs(t) do f(v) end end
function same(x) return x end

function sym0(t)
  return things({n=0, counts={}, most=0, mode=nil  ,add=sym1},t)
end

function num0(t)
  return things({n=0, mu=0, m2=0, up=-1e32, lo=1e32,add=num1},t)
end

function things(i,t)
  map(t, function (one) thing1(i,one) end)
  return i
end

function thing1(i,one)
  if one ~= IGNORE then
    i.n = i.n + 1
    i.add(i,one)
    return i
end end
  
function sym1(i, one)
  local old = t.counts[one]
  local new = old and old + 1 or 1
  t.counts[one] = new
  if new > t.most then
    t.most, t.mode = new,one
  end
end

function num1(i,one)
  if one < i.lo then i.lo = one end
  if one > i.up then i.up = one end
  local delta = one - i.mu
  i.mu = i.mu + delta / i.n
  i.m2 = i.m2 + delta * (one - i.mu)
end

function sd(i)     return i.n <= 1 and 0 or (i.m2 / (i.n - 1))^0.5 end
function norm(i,x) return (x - i.lo) / (i.up - i.lo + 1e-32)     end

n=0
for line in cells() do
  n= n+1
  if line then
    print(n,#line, table.concat(line,","))
  end
end
