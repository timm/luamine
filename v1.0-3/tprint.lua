-- print table contents
-- print tables in sorted key order
-- dont print private keys (starting with "_")
-- block recursive infinite loops
_tostring = tostring

local function stringkeys(t)
  for key,_ in pairs(t) do
    if type(key) ~= "string" then return false end
  end
  return true
end

local function keys(t)
  local ks={}
  for k,_ in pairs(t) do ks[#ks+1] = k end
  table.sort(ks)
  local i = 0
  return function ()
   if i < #ks then
      i = i + 1
      return ks[i],t[ks[i]] end end
end

local function eman(x)
  for k,v in pairs(_G) do
    if v==x then return k end
end end

function tostring(t,seen)
  if type(t) == 'function' then return "FUNC(".. (eman(t) or "") ..")" end
  if type(t) ~= 'table'    then return _tostring(t) end
  seen = seen and seen or {}
  if seen[t] then return "..." end
  seen[t] = t
  local out,sep= {'{'},""
  if stringkeys(t) then
    for k,v in keys(t) do
      if k:sub(1,1) ~= "_" then
	for _,v in pairs{sep,k,"=",tostring(v,seen)} do
	  out[#out+1] =v
	end
	sep=", "
      end
    end
  else
    for _,item in pairs(t) do
      for _,v in pairs{sep,k,"",tostring(item,seen)} do
	  out[#out+1] =v
      end
      sep=", "
  end end
  out[#out+1] = "}"
  return table.concat(out)
end
