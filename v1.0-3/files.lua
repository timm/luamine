require "lib"

local IGNORE = "?"    -- marks which columns or cells to ignore

local _ID = 0
local function ID()
  _ID = _ID + 1;
  return _ID
end 

local function SYM()
  return {n=0, counts={}, most=0,   mode=nil } end

local function NUM()
  return {n=0,  mu=0, m2=0,up=-1e32, lo=1e32 } end

local function nump(x)
  return x.mu ~= nil end

local function ROW(t)
  return {id=ID(),   cells=t,   normy={}, normx={}} end

local function TBL(t) return {
    things={}, _rows={}, less={}, ynums={}, xnums={},
    more={}, spec=t, outs={}, ins={}, syms={}, xsyms={}, nums={}}
end

local function RANGE(t) return {
    label=t.label, score=t.score, x=t.x, y=t.y, has=t.has,
    n=t.n, id=t.id, lo=t.lo, up=t.up}
end

local function RANGES(t) return plus(
    {label=1, x=first, y=last, verbose=false,
     trivial=1.05, cohen=0.3, tiny=nil,
     enough=nil},t)
end

local function NWHERE(t) return plus(
    {verbose=false, cull=0.5, stop=20}, t)
end

local function DICHOTOMIZE(t) return plus(
    {min=2}, t)
end  
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

function unnum(i, one)
  if one ~= IGNORE then
    i.n  = i.n - 1
    local delta = one - i.mu
    i.mu = i.mu - delta/i.n
    i.m2 = i.m2 - delta*(one - i.mu) -- untrustworthy for very small n and z
end end

function unsym(i, one)
  if one ~= IGNORE then
    i.n  = i.n - 1
    i.most,i.mode = 0,nil
    i.counts[one] = i.counts[one] - 1
end end

local function thing1(i,one)   return (nump(i) and num1  or sym1 )(i,one) end
local function unthing1(i,one) return (nump(i) and unnum or unsym)(i,one) end

local function sym0(inits) return map2(inits, SYM(), sym1) end
local function num0(inits) return map2(inits, NUM(), num1) end

local function sd(i)
  return i.n <= 1 and 0 or (i.m2 / (i.n - 1))^0.5
end

local function norm(i,x)
  if x==IGNORE then return x end
  return (x - i.lo) / (i.up - i.lo + 1e-32)
end

local function ent(i)
  local e = 0
  for _,f in pairs(i.counts) do
    e = e + (f/i.n) * math.log((f/i.n), 2)
  end
  return -1*e
end

local function ke(i)
  local e,k = 0,0
  for _,f in pairs(i.counts) do
    e = e + (f/i.n) * math.log((f/i.n), 2)
    k = k + 1
  end
  e = -1*e
  return k,e,k*e
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
      {what= "",   who= sym0, wheres= {t.things, t.ins,  t.syms, t.xysms }}}
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



function normys(t)
  for _,row in pairs(t._rows) do
    for _,thing in pairs(t.ynums) do
      row.normy[#row.normy+1] =
         norm(thing, row.cells[thing.col]) end end
  return t
end

function z(t)
  for i,pop in pairs(t) do
    if pop== nil then
      print(">>",i)
end end end

function nwhere(all,t) return nwhere1(all, NWHERE(t)) end

function nwhere1( all, o)
  o.enough = max((#all)^o.cull,o.stop)
  ------------------------------------------------------
  local function  dist(r1,r2)
    local sum, n = 0,  1e-32
    for i, y1 in pairs(r1.normy) do
      local y2 = r2.normy[i]
      if not (y2 == IGNORE and y1 == IGNORE) then
	if y2 == IGNORE then
	  y2 = y1 < 0.5 and 1 or 0 end
	if y1 == IGNORE then
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
    local cos = function (a,b,c)
                   return (a*a + c*c - b*b) / (2*c + 0.0001) end 
    local west = west or furthest(any(items),items)
    local east = east or furthest(west, items)
    while east.id == west.id do
      east = any(items)
    end
    local c  = dist(west,east)
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
    return west, east, sub(items,1,mid), sub(items,mid+1)
  end
  ------------------------------------------------------
  local function cluster(items,out,lvl)
    lvl = lvl or 1
    if o.verbose then
      print(s5(#items)..nstr("|..",lvl-1)) end
    if #items < o.enough then
      out[#out+1] = items
    else
      local west,east,left,right = split(items, math.floor(#items/2))
      cluster(left,  out, lvl+1)
      cluster(right, out, lvl+1)
    end
    return out
  end
  ------------------------------------------------------
  return cluster(copy(all), {})
end

function _row()
  local t = csv2tbl('../data/autos.arff')
  print("\n----| NUMBERS |---------------------------")
  for _,thing in pairs(t.nums) do
    print(thing.txt, {mu=f5(thing.mu), sd=f5(sd(thing)), lo=thing.lo,up=thing.up})
  end
  print("\n----| SYMBOLS |---------------------------")
  for _,thing in pairs(t.syms) do
    print(thing.txt, {mode=thing.mode, most=thing.most,
  		      ent=f5(ent(thing))},thing.counts)
  end
end

function _nwhere()
  local t= csv2tbl('../data/autos.arff')
  normys(t)
  print("======")
  for i,rows in pairs(nwhere(t._rows,{verbose=true})) do
    print(i,#rows)
    for _,row in pairs(rows) do
      row.cluster = i end end
end

function ranges(items,t) return ranges1(items, RANGES(t)) end
 
function ranges1(items,o)
  o.tiny   = o.tiny   or sd(num0(collect(items,o.x))) * o.cohen
  o.enough = o.enough or (#items)^0.5
  local function xpect(l,r,n) return l.n/n*ent(l) + r.n/n*ent(r) end
  local function divide(items,out,lvl,cut)
    local xlhs, xrhs   = num0(), num0(collect(items,o.x))
    local ylhs, yrhs   = sym0(), sym0(collect(items,o.y))
    local score,score1 = ent(yrhs), nil
    local k0,e0,ke0    = ke(yrhs) 
    local reportx       = copy(xrhs)
    local reporty      = copy(yrhs)
    local n            = #items
    local start, stop  = o.x(first(items)), o.x(last(items))
    for i,new in pairs(items) do
      local x1 = o.x(new)
      local y1 = o.y(new)
      if x1 ~= IGNORE then
	num1( xlhs,x1); sym1( ylhs,y1)  -- the code giveth
	unnum(xrhs,x1); unsym(yrhs,y1)  -- the code taketh away
	if xrhs.n < o.enough then
	  break
	else
	  if xlhs.n >= o.enough then
	    if x1 - start > o.tiny then
	      if stop - x1 > o.tiny then
		if x1 < o.x(items[i+1])  then
		  local score1 = xpect(ylhs,yrhs,n)
		  if score1 * o.trivial < score then
		    local gain       = e0 - score1
		    local k1,e1, ke1 = ke(yrhs) -- k1,e1 not used
		    local k2,e2, ke2 = ke(ylhs) -- k2,e2 not used
		    local delta      = math.log(3^k0 - 2,2) - (ke0 - ke1 - ke2)
		    local border     = (math.log(n-1,2)  + delta) / n
		    if gain > border then
		      cut,score = i,score1 end end end end end end end end
    end -- for loop
    if o.verbose then
      print(s5(n),nstr('|..',lvl)) end
    if cut then
      divide( sub(items,1,   cut), out, lvl+1)
      divide( sub(items,cut+1), out, lvl+1)
    else
      out[#out+1] = RANGE{label=o.label,score=score,x=reportx,y=reporty,
			  n=n, id=#out, lo=start, up=stop, _has=items}
    end
    return out
  end
  -----------------------------------
  
  local items1 = select(items, function(z) return o.x(z) ~= IGNORE end)
  table.sort(items1, function (z1,z2) return o.x(z1) < o.x(z2) end)
  return divide(items1, {}, 0)
end

local function thingScore(rows)
  local syms, splits={},{}
  for  _,row in pairs(rows) do
    local x1 = x(row)
    if syms[x1] == nil then
      syms[x1] = sym0()
      splits[x1] = {}
    end
    sym1(syms[x1],y(row))
    t = splits[x1]
    t[#t + 1] = row
    splits[x] = t 
  end
  local xpect = 0
  for _,sym in pairs(syms) do
    xpect = xpect + sym.n/#rows * ent(sym)
  end
  return xpect,splits
end

function bestThing(rows,t)
  local score,best,splits = 1e31,nil,{}
  print(t.xsyms, #t.xsyms)
  for _,thing in pairs(t.xsyms) do
    tmp,some = thingScore(
      rows,
      function (row) return row.cells[thing.col] end,
      function (row) return row.cluster end)
    print("tmp", tmp)
    if tmp < score then
      score, best, splits = tmp, thing, some
    end
  end
  print(best)
  return best,splits
end

function dichotomize(t)    return dichotomize1(t,DICHOTOMIZE()) end
function dichotomize1(t,o) return dichotomize2(t._rows,t,o) end

function dichotomize2(rows,t,o,lvl)
  lvl= lvl or 0
  if #rows < o.min then
    print(nstr('|..',lvl+1), #rows)
  else
    local best, splits  = bestThing(rows,t)
    print(nstr('|..',lvl), best.txt)
    for k,subs in ipairs(splits) do
      print(nstr('|..',lvl+1), k)
      dichotomize2(subs,t,o,lvl+2)
end end end
    
function _ranges1()
  local a,b,c="a","b","c"
  local t={}
  local n = 1000
  for i= 1,n,1      do t[#t+1] = {i- n + n*2*r(), a} end
  for i= n+1,n+n,1  do t[#t+1] = {i- n + n*2*r(), b} end
  for i= 2*n+1,3*n,1 do t[#t+1]= {i- n + n*2*r(), c} end
  local t1 = shuffle(t)
  print("===")
  for _,r in pairs(ranges1(t1,RANGES{verbose=true})) do
    print(r,ent(r.y))
  end
end

function _dichotimize()
  dichotomize(csv2tbl('../data/autos.arff'))
end

--- ranges needs repportx and reporty.
--- looke like tostring is eating all numberic idenxes

function _ranges2()
  local t= csv2tbl('../data/autos.arff')
  normys(t)
  print("======")
  for i,rows in pairs(nwhere(t._rows,{verbose=true})) do
    for _,row in pairs(rows) do
      t._rows[row.id].cluster  = "C"..i end end
  for _,thing in pairs(t.xnums) do
    local rs = ranges1(t._rows,
		      RANGES{x=function (z) return z.cells[thing.col] end,
			     y=function (z) return z.cluster end
                            })
    if #rs > 1 then
      print("\nnum",thing.txt,thing.col,#rs)
      for _,r in pairs(rs) do
	print(r.lo, r.up, ent(r.y))
      end
    end
    
  end
end


function _demos()
  for k,v in pairs(_G) do
    if type(v) == 'function' and
      string.find(k,'^_') ~= nil and
      k ~= '_tostring' and
      k ~= '_demos' 
    then
      print(string.format("\n---| %s |-------\n",k))
      pcall(v)
end end end

if arg[1]=='--run' then
  loadstring(arg[2] .. '()')()
end


rogue()
