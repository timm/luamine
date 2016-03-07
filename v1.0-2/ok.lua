#!/bin/sh
_=[[ exec lua "$0" ]]

for _,f in ipairs{
  "libok.lua"  ,
  "linesok.lua",
  "colsok.lua" ,
  "spaceok.lua",
  "funok.lua"
  --- "divsok.lua"
} do
  print("\n----------------------------------------------")
  print("---- ",f)
  print("----------------------------------------------\n")
  dofile(f)
end 
