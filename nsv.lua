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
  for i,x in ipairs(cells) do
    if not self:has(x,"ignorep") then
      self.arity = self.arity + 1 
      local j    = self.arity
      self.using[j]     = i
      self.compilers[j] = self:has(x, "nump") 
      self.dep[j]       = self:has(x,  "dep")
end end end

function Nsv:row(cells)
  assert(self.arity == #cells, "wrong number of cells")
  local out=Row:new{}
  for _,j in ipairs(self.using)  do
    local z = cells[j]
    if self.compilers[j] then z = tonumber(z) end
    if self.dep[j] then add(out.y,z) else add(out.x,z) end
  end
  return out
end
    
function Nsv:rows()
  io.input(self.file)
  return function()
    for line in lines(self.chars["whitespace"],
		                  self.chars["comment"]
                     ) do
      local cells = explode(line, self.chars["sep"])
      if #self.using==0 then
	      self:header(cells)
	      return cells
      else
	      return self:row(cells)
end end end end
