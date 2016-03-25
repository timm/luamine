require "xy"

do
  local id=0
  function sample0(klasses)
    id = id + 1
    return { id      = id,
	     rows    = {},
	     klasses = kclasses,
	     columns = {x={}, y={}} }
  end
  -------------------------------  
  local function row0(data, columns, names, k,   col)
    for j,x in ipairs(data) do
      col     = type(x)=='number' and num0() or sym0()
      col.put = type(x)=='number' and num1   or sym1
      if names then
	col.txt = names[j+k]
      end
      columns[j] = col
  end end
  -------------------------------  
  local function row1(data, columns,      col,put)
    for j,x in ipairs(data) do
      if x ~="_" and x ~= nil then
	col = columns[i]
	put = col.put
	put(x, col)
  end end end
  -------------------------------  
  function sample1(row, t,   names, klasses)
    t = t or sample0(klasses)
    if #t.rows == 0 then
      row0(row.x, t.columns.x, names, 0)
      row0(row.y, t.columns.y, names, #row.x)
    end
    row1(row.x, t.columns.x)
    row1(row.y, t.columns.y)
    t.rows[#t.rows + 1] = row
    return t
  end
end
