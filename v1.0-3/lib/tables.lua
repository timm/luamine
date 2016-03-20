---------------------------------------------
function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false
end

function first(t)  return t[1] end
function firsts(t) return map(t,first) end

function second(t) return t[2] end
function seconds(t) return map(t,second) end

function last(t)  return t[#t] end
function lasts(t) return map(t,first) end

function sort(t,f)
  table.sort(t,f or lt)
  return t
end

function copy(t)
  out={}
  for k,v in pairs(t) do out[k] = v end
  return out
end

function also(t1,t2)
  if t2 then
    for k,v in pairs(t2) do
      t1[k] = v
end end end

function reverse(t)
  for i=1, math.floor(#t / 2) do
    t[i], t[#t - i + 1] = t[#t - i + 1], t[i]
  end
  return t
end

function map(t,f)
  local out = {}
  if t ~= nil then
    for i,v in pairs(t) do
      out[i] = f(v)
    end end
  return out
end

function select(t,f)
  local out = {}
  if t ~= nil then
    for _,v in pairs(t) do
      local new = f(v)
      if new ~= nil then out[#out+1] = new end
  end end
  return out
end



function sub(t, first, last)
  last = last or #t
  local out = {}
  if last < first then last = first end
  for i = first,last do
    out[#out + 1] = t[i]
  end
  return out
end

function thing2(t, x, y)
  local tx = t[x]                      
  if not tx then tx={}; t[x] = tx end
  local txy = tx[y]
  if not txy then txy={}; tx[y] = txy end
  return txy
end
