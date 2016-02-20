require "lib"


function nameOfVar(x)
  for this,that in pairs(_G) do
    if that == x  then
      return this
  end end
  error("var name not found : " .. tostring(x))
end
	  
function def(spec,   g,inits,id,parent,name,f,out)
  for k,v in pairs(spec) do
    if k=="plus" then
      inits = v
    else
      kid, parent = k,v
  end end
  name = nameOfVar(parent)
  if name == "Object" then
    g = same
  else
    g = string.lower(name) .. '0'
  end
  print("G",g)
  _G[kid] = parent:new()
  return function (t) return fresh(_G[kid], _G[g](t),inits)  end
end

rogue()



log0 = def({Log=Object, with= {
	     counts = {},
	     mode = nil,
	     most = 0}})

same0 = def( {Some=Log, with= {
	      max = 256,
	      _kept = {},
	      n = 0}})

