require "xy"

do
  local id=0
  local function sample0(subs) -- subs may be nil
    id = id + 1
    return { id      = id,
	     rows    = {},
	     subs    = subs and {}, 
	     columns = {x={}, y={}} }
  end
  --------------------------------------------------  
  local function row0(columns, names, k, -- required
		      col)               -- local
    for j,x in ipairs(columns) do
      col = {}
      col.txt = names and names[j+k] or ''..j
      columns[j] = col
  end end
  ----------------------------------------------  
  local function row1(data, columns, -- required
		      col,put)       -- local
    for j,x in ipairs(data) do
      if x ~="_" then
	col = columns[j]
	if not col.log then
	  col.log= type(x)=='number' and num0() or sym0()
	  col.put= type(x)=='number' and num1   or sym1
	end
	log = col.log
	put = col.put
	put(x, log)
    end end
  end
  --------------------------------------------  
  function sample1(row, t,         -- required
		   names,subs,lvl) -- optional
    -- fill in defaults ----------------------
    lvl  = lvl  and lvl  or 1
    subs = subs and subs or {}
    t    = t or sample0(subs)
    -- initialize if this is first call ------
    if #t.rows == 0 then
      row0(t.columns.x, names, 0)
      row0(t.columns.y, names, #row.x)
    end
    -- process and keep the row ---------------
    row1(row.x, t.columns.x)
    row1(row.y, t.columns.y)
    t.rows[#t.rows + 1] = row
    -- maybe, sub-divide the data -------------
    if subs[lvl] then
      local k = row.y[1]
      t.klasses[k] = sample1(row, t.klasses[k],
			     names, false, lvl+1)
    end
    return t
  end
end
