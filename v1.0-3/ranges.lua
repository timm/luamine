require "tprint"

local SEP  = "([^,]+)" 

local function same(x) return x end
local function nump(x) return string.find(x,"[<>\\$]") ~= nil end

function tbl()
  local n,t, line = 0, {cols={},rows={},prep={}}, io.read()
  return function ()
    while line ~= nil do
      local col,row = 0,{}
      for word in string.gmatch(line, SEP ) do
	col = col + 1
	if   n == 0
        then t.prep[col] = nump(word) and tonumber or same
	else word = t.prep[col](word)
	end
	row[col] = word
      end
      if   n == 0
      then t.cols = row
      else t.rows[ #t.rows + 1 ] = row
      end
      local tmp = row
      n = n + 1
      line = io.read()
      return t, tmp
    end
    return nil
  end
end

for t,row in tbl() do
   print(row[1], type(row[1]))
end
print(">>",t1.prep)
