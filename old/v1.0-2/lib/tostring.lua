do
  _tostring = tostring  
  local lineWidth = 8000
  
  local function toStringSimple(t)
    -- for when the indexes are all numeric
    local out,sep,lines="","{",1
    for _,y in ipairs(t) do
      out = out..sep..tostring(y) 
      sep = " "
      if #out > lines*lineWidth then
	lines = lines+1
	sep = "\n "
    end end
    return out..'}'
  end
  
  function tostring(t)
    -- for arbitary stuff
    if type(t) ~= 'table' then
      return _tostring(t) 
    else
      local out,sep,lines="{",":",1
      local allNums,empty=true,true
      for x,y in pairs(t) do
	empty   = False
	allNums = allNums and type(x) == 'number'
	if string.sub(x,1,1) ~= "_" -- skip 'private' stuff
	then
	  out = out..sep..x.." "..tostring(y) 
	  sep = " :"
	  if #out > lines*lineWidth then 
	    lines = lines+1
	    sep = "\n  :"
      end end end
      if empty then
        return "{}" 
      elseif allNums then
        return toStringSimple(t)
      else
        return out..'}'
  end end end
  str = tostring
end
