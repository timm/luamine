package = "LuaMine" 
version = "1.0-2"
 source = {
    url = "git://github.com/timm/luamine.git" ,
    tag = "v1"
 }
 description = {
    summary = "Tools for combining data mining and optimization.",
    maintainer="tim.menzies@gmail.com",
    detailed = [[
      WARNING: major bug found with previous submission. do not use till
      version 2.0

      LuaMine documents common data mining   patterns. These tools
      learn, from examples, a approximation to some function

              y = Fun(x)

      where y can be a single or multiple goals. The general tactic is
      to approximate complex functions via a few
      dimensions, divided into a small number of ranges.
    ]],
    homepage = "https://github.com/timm/luamine/blob/master/README.md",  
    license = "Unlicense"  
 }
 dependencies = {
    "lua ~> 5.2" 
 }
 build = {
     type       = "builtin",
     modules    = {
      utils2    = "lua/aaa.lua",
      tests0    = "lua/aaaok.lua",
      columns   = "lua/cols.lua",
      tests1    = "lua/colsok.lua",
      discretization= "lua/divs.lua",
      tests2    = "lua/divsok.lua",
      functions = "lua/fun.lua",
      tests3    = "lua/funok.lua",
      csvReader = "lua/nsv.lua",
      tests4    = "lua/nsvok.lua"
      } ,
      copy_directories = {"data"}
 }
