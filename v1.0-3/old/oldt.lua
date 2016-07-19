do
  local function is_t(x) return type(x) == "table" end
  local function is_hidden(x)
    return type(x)=="string" and  x:sub(1,1) == ".."
  end
  -------------------------------
  local function showt1(t,spacing,seen)
    if not is_t(t) then
      print(spacing .. tostring(t))
    else
      if seen[t] then
	print("..")
      else
	seen[t] = t
	for k,v in keys(t) do
	  if not is_hidden(k) then 
	    print(spacing .. tostring(k),
		  is_t(v) and "" or v)
	    if is_t(v) then 
	      showt1(v,spacing..'|   ',seen)
  end end end end end end
  -------------------------------
  function showt(t)
    print(""); showt1(t,"",{})
  end 
end
