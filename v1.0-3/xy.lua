require "tools"

do
  local function has(str,z)
    return string.find(str,z) ~= nil
  end
  --------------------------------------------------
  local function about(str, nx, ny, out)
     if has(str,"[=<>]") then
       ny = ny+1; out.pos = ny; out.xy = "y"
     else
       nx = nx+1; out.pos = nx; out.xy = "x"
     end
     return out, nx, ny
  end 
  --------------------------------------------------
  function xys()
    local names, abouts =  {}, {}
    local row, line = -1, io.read()
    return function ()
      while line ~= nil do
	local xy = {x= {}, y={}}
	local col, nx, ny = 0, 0, 0
	for z in string.gmatch(line, "([^,]+)" ) do
	  col = col + 1
	  if row == 0 then
	    abouts[col], nx, ny = about(z,nx,ny,{})
	  else
	    z1 = tonumber(z)
	    z  = z1 and z1 or z
	  end
	  local a = abouts[col]
	  xy[a.xy][a.pos] = z
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
