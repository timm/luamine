require "tprint"

SEP  = "([^,]+)" 

function tbl()
  local n,t, line = 0, {cols={},rows={},nump={}}, io.read()
  return function ()
    while line ~= nil do
      local col,row = 0,{}
      for z in string.gmatch(line, SEP ) do
	col = col + 1
	if   n == 0
        then t.nump[col] = string.find(z,"[<>\\$]") ~= nil
	else z = t.nump[col] and tonumber(z) or z
	end
	row[col] = z
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

t1=nil
for t,row in tbl() do
  t1= t
  print(row[1], type(row[1]))
end
print(">>",t1.nump)
