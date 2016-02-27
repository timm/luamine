-- OO stuff --------------------
Object={}

function object0(t)
  return t:new() end

function Object:super()
  return getmetatable(self) end

function Object:new(o)
   o = o or {} 
   setmetatable(o,self)  
   self.__index = self
   return o
end

Animal=Object:new()
Bird=Animal:new()

function animal0(o)
  return object0(o or Animal) end

function bird0(o)
  return animal0(o or Bird) end

function Animal:speak()
  print("hello\n") end

function Bird:speak()
  self:super():speak()
  print "polly" end

b=bird0()

b:speak()
