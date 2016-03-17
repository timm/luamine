require "tools"

do
   local function meta0(str, nx, ny)
     local function has(z)
       return string.find(str,z) ~= nil end
     tmp = {str   = str,
	    less  = has("<"),
	    more  = has(">"),
	    klass = has("="),
	    num   = has("[\\$]")
            }
     if    has("[=<>]")
     then ny = ny+1; tmp.pos = ny; tmp.xy = "y"
     else nx = nx+1; tmp.pos = nx; tmp.xy = "x"
     end
     return tmp, nx, ny
   end  

   local function complete(t)
     for n,meta in ipairs(t.meta) do
       for _,want in pairs{"less","more","klass","num"} do
	 if meta[want] then
	   push2(t.also,meta.xy,want,meta)
	 end end
       if not meta.num then
	 push2(t.also,meta.xy,"sym",meta)
       end
       push2(t.also,meta.xy,"ALL",meta)
     end
     return t
   end

   function xy()
     local t = {meta={}, rows={}, also={}} 
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
       if row == 0 then
	 complete(t) 
       else
	 t.rows[row] = tmp
       end
       row, line = row + 1, io.read()
     end
     return t
  end
end

if arg[1] == "--xy" then
  t={}
  t = xy()
  for i=1,#t.meta do print(i,t.meta[i]) end
  print("")
  print("also.x",t.also.x)
  print("also.y",t.also.y)
  print("")
  for i=1,#t.rows do print(i,t.rows[i]) end
end
