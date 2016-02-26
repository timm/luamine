-- Test engine stuff -----------------------
function rogue(x)
  -- find rogue globals
  local builtin = { "true","math","package","table","coroutine",
       "os","io","bit32","string","arg","debug","_VERSION","_G"}
  io.write "-- Globals: "
  for k,v in pairs( _G ) do
    if type(v) ~= 'function' then  
       if not member(k, builtin) then 
         io.write(" ",k) end end end
  print  ""
end


do
  local y,n = 0,0
  local function report() 
    print(string.format(
              ":pass %s :fail %s :percentPass %s%%",
              y,n,round(100*y/(0.001+y+n))))
    rogue() end
  local function test(s,x) 
    print("# test:", s) 
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

