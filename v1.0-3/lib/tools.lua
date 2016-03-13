require "lib/tostring"

function map(t,f)
  local out = {}
  if t == nil then
    for i,v in pairs(t) do
      out[i] = f(v)
  end end
  return out
end

function max(a,b) return a>b and a or b end
function same(x)  return x end

function sub(t, first, last)
  last = last or #t
  local out = {}
  if last < first then last = first end
  for i = first,last do
    out[#out + 1] = t[i]
  end
  return out
end

function num0(t)
  tmp = {m=0,n=0,m2=0}
  map(t, function (z) num1(z,tmp) end)
  return tmp
end

function num1(z,t)
  t.n  = t.n + 1
  local delta = z - t.mu
  t.mu = t.mu + delta / t.n
  t.m2 = t.m2 + delta * (z - t.mu)
end

function unnum(z,t)
  t.n  = t.n - 1
  local delta = x - t.mu
  t.mu = t.mu - delta/t.n
  t.m2 = t.m2 - delta*(x - t.mu)
end

function sd(t)
  return t.n <= 1 and 0 or (t.m2/(t.n - 1))^0.5
end
  
  
