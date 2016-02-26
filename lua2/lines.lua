require "lib"
require "magic"

function lines()
  local n, header, o = 0, {}, Chars
  local function newLine(str)
    n = n + 1
    local out,tmp = {}, explode(str,o.sep)
    if n==1 then
      for i,txt in ipairs(tmp) do
        if not found(txt,o.ignorep) then
	  add(out   , txt)
	  add(header, {from = i,
		       prep = found(txt, o.nump) and tonumber
			      or same }) end end	     
    else   
      for i,x in pairs(header) do
	out[i] = x.prep( tmp[x.from] ) end end
    print("L",n,out)
    return n,out
  end
  return function()
    local pre, line = "", io.read()
    while line ~= nil do
      line = line:gsub(o.white,""):gsub(o.comment,"")
      if line ~= "" then
	if lastchar(line) == "," then
	  pre  = pre .. line
      else
	line =  pre .. line
	pre  = ""
	return newLine(line)
      end end
      line = io.read()
    end
    if len(pre) > 0 then
      return newLine(pre)
end end end

function xys()
  local nx, ny, n, dep = 0, 0, 0, Chars.dep
  return function()
    for n,cells in lines() do
      n = n + 1
      print("X",n,cells)
      -- if n==1 then
      -- 	for col,cell in ipairs(cells) do
      -- 	  if   found(cell, dep)
      -- 	  then ny = ny + 1; add(header, {col,2,ny})
      -- 	  else nx = nx + 1; add(header, {col,1,nx})
      -- 	  end
      -- 	end
      -- end
      -- local out = {{},{}}
      -- for col,trio in pairs(header) do
      -- 	out[ trio[2] ][ trio[3] ] = cells[ trio[1] ]
      -- end
      return n,cells
    end  	
  end
end
