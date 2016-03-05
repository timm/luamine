order= {
  "libok.lua",
  "linesok.lua",
  "colsok.lua",
  "spaceok.lua",
  "funok.lua",
  "divsok.lua"
}

for _,f in ipairs(order) do
  print("\n")
  print("----------------------------------------------")
  print("---- ",f)
  print("----------------------------------------------")
  dofile(f)
end




