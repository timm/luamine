for x in io.popen('ls *ok.lua'):lines() do
  if x ~= "ok.lua" then 
    print("\n--------------------------------------------")
    print("---- ",x)
    print("--------------------------------------------\n")
    dofile(x)
end end
