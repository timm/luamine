
-- OO stuff --------------------
Object={}

function Object:new(o)
   o = o or {} 
   setmetatable(o,self)  
   self.__index = self
   return o
end

function Object:has(t)
  if t then
    for k,v in pairs(t) do
      self[k] = v
    end end
  return self
end

function Object:shallowCopy(t)
  return self:new():has(self):has(t)
end

function Object:copy(t)
  return self:shallowCopy(t)
end

function object0(t)
  return t:new()
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
