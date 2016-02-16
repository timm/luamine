require "aaa"

Nsv= Object:new{file = "data.csv",
	       using       = {},
	       compilers   = {},
	       dep         = {},
	       arity       = 0,
	       chars       = {
    whitespace = "[ \t\n]*", -- kill all whitespace
    comment    = "#.*",        -- kill all comments
    sep        = ",",          -- field seperators
    ignorep    = "[\\?]",
    missing    = '[\\?]',
    klass      = "=",
    less       = "<",
    more       = ">",
    floatp     = "[\\$]",
    intp       = ":",
    goalp      = "[><=]",
    nump       = "[:\\$><]",
    dep        = "[=<>]"
}}

Row=Object:new{x={},y={}}

function Nsv:has(txt,pat) 
  return found(txt, self.chars[pat]) end

function Nsv:header(cells,    j) 
  local x,y={},{}
  for i,z in ipairs(cells) do
    if not self:has(z,"ignorep") then
      self.arity = self.arity + 1 
      local j    = self.arity 
      self.using[j]     = i
      self.compilers[j] = self:has(z, "nump") 
      self.dep[j]       = self:has(z,  "dep")
      if self.dep[j] then add(y,z) else add(x,z) end
  end end 
  return Row:new{x=x,y=y}
end

function Nsv:row(cells)
  local x,y={},{}
  for _,j in ipairs(self.using)  do
    local z = cells[j]
    if self.compilers[j] then z = tonumber(z) end
    if self.dep[j] then add(y,z) else add(x,z) end
  end
  return Row:new{x=x,y=y}
  
end
    
function Nsv:rows()
  io.input(self.file)
  return function()
    for line in lines(self.chars["whitespace"],
		                  self.chars["comment"]
                     ) do
      local cells = explode(line, self.chars["sep"])
      if #self.using==0 then
	      return false,self:header(cells)
      else
	      return true,self:row(cells)
end end end end
