require "xy"

function table0(names)
  return { rows = {},
	   names= names or {},
	   meta = {x={}, y={}}}
end

function row0(row,t)
  for _,xy in pairs{"x","y"} do
    for pos,z in ipairs(row[xy]) do
      local log = type(z)=='number' and num0() or sym0()
      t.meta.[xy][pos] = lot
end end end

function row1(row,t)
  local function cell1(z,xy,pos)
    if z ~="_" then
      what = t.meta[xy][pos]
      puts = what.puts
      puts( z, what )
  end end
  for _,xy in pairs{"x","y"} do
    for pos,z in ipairs(row[xy]) do
     cell1(z,xy,pos)
end end end 

function table1(row,t,names)
  t = t or table0(names)
  if #t.rows==0 then
    row0(row,t)
  end
  row1(row,t)
  t.rows[#t.rows+1] = row
end
