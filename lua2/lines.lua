require "lib"
require "magic"

--[[

Kills white space and comments.
Skips blank lines.
Lines ending with the seperator are continued to the next.
Lines are split on the seperator.

First line is a list of names for the columns.
Other lines are data.
Names have magic symbols as defined in magic.lua
Columns with names with the ignore character are ignored.

Columns with names with the numeric character are treated special.
Specifically, cells in numerc columns are coerced to numbers
  (unless they are just the missing character)

Rows are returned as {x=t1,y=t2} where t1 are the independent 
  variables and t2 are the dependent variables.

All this is in an iterator that reads one line at
a time into RAM (lets learners decide how much information, 
if any,  they want to keep around).

FYI, this code eats 10MB of a CSV file 
with 18 rows in 2.2 secs, using luajit. And that is
after near zero work on optimizations.

--]]

do
  local function asNumber(x)
    return x == Chars.missing and x or tonumber(x)
  end

  local function xyMaker(cells)
     local nx,ny,maker = 0,0,{}
     for col,cell in ipairs(cells) do
      if not found(cell,Chars.ignorep) then
	local prep = found(cell,Chars.nump) and asNumber
	             or same
	if found(cell, Chars.dep)
	then ny = ny + 1
	     add(maker, {col=col, xy= 2,
	  	         at=ny,prep=prep})
	else nx = nx + 1
	     add(maker, {col=col,xy=1,
		         at=nx,prep=prep})
     end end end
     return maker
  end

  local function t2xy(cols,maker,n)
    local out = {{},{}}
    for i=1,#maker do -- saves 20% over using 'pairs'
      local meta = maker[i]
      local cell = cols[ meta.col ]
      local xy   = out[ meta.xy ]
      xy[ meta.at ] = n==1 and cell
	              or meta.prep(cell)
    end
    return {x=out[1],y=out[2]}
  end
  
  function lines()
    local n, header, makexy = 0, {},  nil
    local function newLine(str)
      n = n + 1
      local tmp = explode(str,Chars.sep)
      if n == 1 then
	makexy=xyMaker(tmp)
      end
      return n, t2xy(tmp,makexy,n)
    end
    return function()
      local pre, line = "", io.read()
      while line ~= nil do
	line = line:gsub(Chars.white,""):gsub(Chars.comment,"")
	if line ~= "" then
	  if lastchar(line) == "," then
	    pre  = pre .. line
	  else
	    line =  pre .. line
	    pre  = ""
	    return newLine(line)
	end end
	line = io.read()
      end
      if len(pre) > 0 then
	return newLine(pre)
  end end end
end
