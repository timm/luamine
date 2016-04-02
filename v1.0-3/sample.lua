require "xy"

do
  local id=0
  local function sample0() -- subs may be nil
    id = id + 1
    return { id      = id,
	     rows    = {},
	     subs    = {},
	     ignore  = "_",
	     columns = {x={}, y={}} }
  end
  --------------------------------------------------  
  local function row0(data,columns,names) -- required
    for j,x in ipairs(data) do
      columns[j] = names and {txt=names[j]} or j
  end end
  ----------------------------------------------  
  local function row1(data, columns,ignore, -- required
		      col,put)       -- local
    for j,x in ipairs(data) do
      if x ~= ignore then
	col = columns[j] 
	if not col.log then
	  col.log= type(x)=='number' and num0() or sym0()
	  col.put= type(x)=='number' and num1   or sym1
	end
	log = col.log
	put = col.put
	put(x, log)  
      end end end
  --------------------------------------------  
  function sample1(row, t,  -- required
		   names,lvl)   -- optional
    t   = t or sample0()
    -- initialize if this is first call ------
    if #t.rows == 0 then
      row0(row.x, t.columns.x, names.x)
      row0(row.y, t.columns.y, names.y)
    end
    -- process and keep the row ---------------
    row1(row.x, t.columns.x, t.ignore)
    row1(row.y, t.columns.y, t.ignore)
    t.rows[#t.rows + 1] = row
    if lvl == 0 then
      local k = row.y[1]
      t.subs[k] = sample1(row, t.subs[k], names, lvl+1)
    end
    return t
  end
end

if arg[1] == "--sample" then
  local t 
  for _,names,row in xys() do
    t= sample1(row,t,names)
  end
  print(t.columns.y)
end
