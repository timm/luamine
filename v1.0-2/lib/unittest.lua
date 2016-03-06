-- Test engine stuff -----------------------
do
  local builtin = { "jit", "bit", "true","math",
		    "package","table","coroutine",
		    "os","io","bit32","string","arg",
		    "debug","_VERSION","_G"}
  function rogue(x)
    local tmp={}
    for k,v in pairs( _G ) do
      if type(v) ~= 'function' then  
        if not member(k, builtin) then
	  table.insert(tmp,k) end end end
    print("-- Globals: ",sort(tmp))
  end
  
  local y,n = 0,0
  local function report() 
    print(string.format(
              ":PASS %s :FAIL %s :percentPASS %s%%",
              y,n,round(100*y/(0.001+y+n))))
    rogue() end
  local function test(s,x) 
    print("\n-------------------------------------")
    print("-- test:", s,eman(x))
    print("-------------------------------------")
    y = y + 1
    local passed,err = pcall(x) 
    if not passed then   
       n = n + 1
       print("Failure: ".. err) end end 
  local function tests(t)
    for s,x in pairs(t) do test(s,x) end end 
  function ok(t) 
    if empty(t) then report() else tests(t);report() end end
end

