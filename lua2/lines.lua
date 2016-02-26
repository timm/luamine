require "lib"
require "chars"

function lines()
  local sep, comment, white = "," , "#.*", "[ \\t\\n]*"
  local ignorep, nump       = "[\\?]", "[:\\$><]"
  local n, header           = 0, {}
  local function theLine(str)
    n = n + 1
    local out,tmp = {}, explode(str,sep)
    if n==1 then
      for i,label in ipairs(tmp) do
        if not found(label,ignorep) then
	  add(out, label)
	  add(header, {from= i,
		       prep= found(label,nump) and tonumber
			     or same }) end end	     
    else   
      for i,x in pairs(header) do
	out[i] = x.prep( tmp[x.from] ) end end
    return n==1,out
  end
  return function()
    local pre, line = "", io.read()
    while line ~= nil do
      line = line:gsub(white,""):gsub(comment,"")
      if line ~= "" then
	if lastchar(line) == "," then
	  pre  = pre .. line
      else
	line =  pre .. line
	pre  = ""
	return theLine(line)
      end end
      line = io.read()
    end
    if len(pre) > 0 then
      return theLine(pre)
end end end

