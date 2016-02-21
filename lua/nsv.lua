require "lib"

Nsv= Object:new()
function nsv0(o)
  o = object0(o or Nsv)
  o.file = "data.csv"
  o.using       = {}
  o.compilers   = {}
  o.dep         = {}
  o.arity       = 0
  o.chars       = {
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
  }
  return o
end

Row=Object:new()
function row0(o)
  o = object0(o or Row)
  o.x={}
  o.y={}
  return o
end

function Nsv:char(txt,pat) 
  return found(txt, self.chars[pat]) end

function Nsv:header(cells) 
  local x,y={},{}
  for i,z in ipairs(cells) do
    if not self:char(z,"ignorep") then
      self.arity = self.arity + 1 
      local j    = self.arity 
      self.using[j]     = i
      self.compilers[j] = self:char(z, "nump") 
      self.dep[j]       = self:char(z,  "dep")
      if self.dep[j] then add(y,z) else add(x,z) end
  end end 
  return row0():has{x=x,y=y}
end

function Nsv:row(cells)
  local x,y={},{}
  for _,j in ipairs(self.using)  do
    local z = cells[j]
    if self.compilers[j] then z = tonumber(z) end
    if self.dep[j] then add(y,z) else add(x,z) end
  end
  return Row:new():has{x=x,y=y}
  
end
    
function Nsv:rows()
  io.input(self.file)
  local data=false
  return function()
    for line in lines(self.chars["whitespace"],
		       self.chars["comment"]
                     ) do
      local cells = explode(line, self.chars["sep"])
      if data then
	return true,self:row(cells)
      else
	data = true
	return false,self:header(cells)
end end end end
