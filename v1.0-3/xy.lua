require "tools"

do
   local function meta0(str, nx, ny)
     local function has(z)
       return string.find(str,z) ~= nil end
     tmp = {str   = str,
	    less  = has("<"),
	    more  = has(">"),
	    klass = has("="),
	    num   = has("[\\$]"),
	    dep   = has("[=<>]")}
     if   tmp.dep
     then ny = ny+1; tmp.pos = ny; tmp.xy = "y"
     else nx = nx+1; tmp.pos = nx; tmp.xy = "x"
     end
     return tmp, nx, ny
   end  

   function xy()
     local t = {meta={}, rows={}} 
     local row, line = 0, io.read() 
     while line ~= nil do
       local nx, ny, col = 0, 0, 0
       local tmp = {x= {}, y={}, also=nil}
       for z in string.gmatch(line, "([^,]+)" ) do
	 col = col + 1
	 if row == 0 then
	   t.meta[col], nx, ny = meta0(z,nx,ny)
	 else
	   meta = t.meta[col]
	   if meta.num then z = tonumber(z) end
	   tmp[meta.xy][meta.pos] = z
	 end end
       if row > 0 then t.rows[row] = tmp end
       row, line = row + 1, io.read()
     end
     return t
  end
end

if arg[1] == "--xy" then
  t = xy()
  for i=1,#t.meta do print(i,t.meta[i]) end
  print("")
  for i=1,#t.rows do print(i,t.rows[i]) end
end
