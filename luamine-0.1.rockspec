package = "LuaMine"
 version = "0.1"
 source = {
    url = "git://github.com/timm/luamine.git"  
 }
 description = {
    summary = "Tools for combining data mining and optimization.",
    maintainer="tim.menzies@gmail.com",
    detailed = [[
       LuaMine documents common data mining   patterns. These tools
      learn, from examples, a approximation to some function

              y = Fun(x)

      where y can be a single or multiple goals. The general tactic is
      be to approximate complex functions via a few
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
      lib       = "aaa.lua",
      tests0    = "aaaok.lua"
      columns   = "cols.lua",
      tests1    = "colsok.lua",
      discretization= "divs.lua",
      tests2    = "divsok.lua",
      functions = "fun.lua",
      tests3    = "funok.lua",
      csvReader = "nsv.lua",
      tests4    = "nsvok.lua",
      utils1    = "Makefile"
      },
      copy_directories = {"data"}
 }