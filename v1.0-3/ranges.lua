require "tprint"

local SEP  = "([^,]+)" 

local function same(x)  return x end
local function has(x,y) return string.find(x,y) ~= nil end
local function push(x,t) t[#t+1] = x; return x; end

local function tbl0()
  return {cols={},rows={},
	  less={}, more={},goals={}, nums={}}
end

local function numcol(word,col,t)
   local new = num0()
   new.col   = col
   new.txt   = word
   push(new, t.nums)
   if has(word,'<') then push(new,t.less); push(new,t.goals) end
   if has(word,'>') then push(new,t.more); push(new,t.goals) end
end

local nrows=0
local function row1(row,t)
  nrows = nrows+1
  new= {id=nrows, cells=row,normy={},normx={}}
  t.rows[nrows] = new
  for _,num in pairs(t.nums) do
    num1(num,row[num.col])
  end
end

function tbl()
  local n,t, nump, line = 0, tbl0(), {},io.read()
  return function ()
    while line ~= nil do
      local col,row = 0,{}
      for word in string.gmatch(line, SEP ) do
	col = col + 1
	if   n == 0
        then
	  if has(word,"[<>%]") then
	    nump[col] = true
	    numcol(word,col,t)
	  end 
	else
	  if nump[col] then
	    word = tonumber(word) 
	  end
	end
	row[col] = word
      end
      if   n == 0
      then t.cols = row
      else row1(row,t)
      end	
      local tmp = row
      n = n + 1
      line = io.read()
      return t, tmp
    end
    return nil
  end
end

function num0(some)
  i = {mu= 0, n= 0, m2= 0, up= -1e32, lo= 1e32}
  map(some, function (x) num1(i,x) end)
  return i
end

function map(t,f)
  for i,v in pairs(t) do f(v) end
end

function num1(i,one)
  if one ~= IGNORE then
    i.n= i.n+1
    if one < i.lo then i.lo = one end
    if one > i.up then i.up = one end
    local delta = one - i.mu
    i.mu = i.mu + delta / i.n
    i.m2 = i.m2 + delta * (one - i.mu)
  end
  return one
end

function sd(i)
  return i.n <= 1 and 0 or (i.m2 / (i.n - 1))^0.5
end

function norm(i,one)
  return (one - i.lo) / (i.up - i.lo + 1e-32)
end

function clustern(t)
  for id,row in ipairs(t.rows) do
    for col in t.goals do
      push(norm(col,row[col.col]),
	   row.normy)
    end
  end
end
  
print(">>",t1.prep)
