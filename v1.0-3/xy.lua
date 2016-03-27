require "tools"
--[[
Divide lines into comma seperated values
Seperate the rows into xy pairs: {x=independent,y=depndent} variables}.
Pulls first row into "names"
In remaining rows, compile numeric strings to numbers 
Return one new xy record at a time (none of this load all into RAM silliness)

Not slow: when run with Luajit, reads 15,000 records in 100K in 0.2 seconds
--]]

do
  local KLASS= "[=<>]" -- symbols that mark a class name
  local SEP  = ","     -- row field seperator
  --------------------------------------------------
  local function about(str, nx, ny, out)
    if string.find(str,KLASS) ~= nil then
       ny = ny+1; out.pos = ny; out.xy = "y"
     else
       nx = nx+1; out.pos = nx; out.xy = "x"
     end
     return out, nx, ny
  end 
  --------------------------------------------------
  function xys()
    local names, abouts =  {}, {}
    local row, line     = -1, io.read()
    return function ()
      while line ~= nil do
	local xy = {x= {}, y={}}
	local col, nx, ny = 0, 0, 0
	for z in string.gmatch(line, "([^".. SEP .."]+)" ) do
	  col = col + 1
	  if row < 0 then
	    abouts[col], nx, ny = about(z,nx,ny,{})
	  end
	  local a  = abouts[col]
	  local z1 = tonumber(z)
	  xy[a.xy][a.pos] = z1 and z1 or z
	end
	row, line = row + 1, io.read()
	if row == 0 then
	  names = xy
	else
	  return row, names, xy
	end end
      return nil
  end end
end

if arg[1] == "--xy" then
  for row,names,xy in xys() do
    print(row,names,xy)
  end  
end
