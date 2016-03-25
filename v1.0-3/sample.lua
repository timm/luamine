require "xy"

do
  local id=0
  function sample0(names)
    id = id + 1
    return { id = id,
	     rows = {},
	     names= names or {},
	     metas = {x={}, y={}} }
  end
  -------------------------------  
  local function row0(data, metas,    meta.put)
    for col,x in ipairs(data) do
      meta      = type(x)=='number' and num0() or sym0()
      meta.put  = type(x)=='number' and num1   or sym1
      metas[col]= meta
  end end
  -------------------------------  
  local function row1(data, metas)
    for col,x in ipairs(data) do
      if x ~="_" and x ~= nil then
	puts = metas[col].puts
	puts( x, metas[col] )
  end end end
  -------------------------------  
  function sample1(row,t,names)
    t = t or sample0(names)
    if #t.rows==0 then
      row0(row.x, t.metas.x)
      row0(row.y, t.metas.y)
    end
    row1(row.x, t.metas.x)
    row1(row.y, t.metas.y)
    t.rows[#t.rows+1] = row
    return t
  end
end
