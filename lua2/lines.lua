require "lib"
require "magic"

function lines(xy)
  local n, header, o, makexy = 0, {}, Chars, nil
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
	out[i] = x.prep( tmp[x.from] ) end
    end 
    if xy then
      if n == 1 then makxy=xyMaker(out) end
      out = t2xy(out,makxy)
    end
    return n, out
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

function xyMaker(cells)
  local nx,ny,maker = 0,0,{}
  for col,cell in ipairs(cells) do
    if   found(cell, Chars.dep)
    then ny = ny + 1; add(maker, {col,2,ny})
    else nx = nx + 1; add(maker, {col,1,nx})
    end
  end
  return maker
end

function t2xy(t,maker)
  local out = {{},{}}
  for _,trio in pairs(maker) do
    out[ trio[2] ][ trio[3] ] = t[ trio[1] ]
  end
  return {x=out[1],y=out[2]}
end  	
