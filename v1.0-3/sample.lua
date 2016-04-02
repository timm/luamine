require "xy"

do
  local id=0
  local function sample0() -- subs may be nil
    id = id + 1
    return { id      = id,
	     rows    = {},
	     subs    = {},
	     ignore  = "_",
	     h       = 0,
	     columns = {x={}, y={}} }
  end --[[
        columns[i].x and columns[i].y both have the same format
           {log = some num0 or sym0 cache of data seen see far	
            pos	= the column's place in columns.x or columns.y
            txt	= the column name (if supplied, else == pos)
            put	= some function that lets us add new items to log
                  (and if put==num1, this is a number)
  ]]--
  function numcol(col) return col.put == num1 end
  function symcol(col) return not numcol(col) end
  --------------------------------------------------  
  local function row0(data,columns,names) -- required
    for j,x in ipairs(data) do
      columns[j] = names and {txt=names[j]} or j
  end end
  ----------------------------------------------  
  local function row1(data, columns,ignore)
    for j,x in ipairs(data) do
      if x ~= ignore then
	local col = columns[j] 
	if not col.log then
	  col.log= type(x)=='number' and num0() or sym0()
	  col.put= type(x)=='number' and num1   or sym1
	  col.pos= j
	end
	local log = col.log
	local put = col.put
	put(x, log)  
      end end end
  --------------------------------------------  
  function sample1(row, t,  -- required
                   names,lvl)   -- optional
    lvl = lvl or 0
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
      if t.subs[k] == nil then t.h = t.h+1 end
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
