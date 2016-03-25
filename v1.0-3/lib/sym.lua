function sym0(t)
  local tmp = {counts={}, most=0, mode=nil, n=0, put=sym1}
  map(t, function (z) sym1(z,tmp) end)
  return tmp
end

function sym1(z,t)
  t.n  = t.n + 1
  local old,new
  old = t.counts[z]
  new = old and old + 1 or 1
  t.counts[z] = new
  if new > t.most then
    t.most, t.mode = new,z
  end
  return t
end

function ent(t)
  local e = 0
  for _,n in pairs(t.counts) do
    local p = n/t.n
    e = e - p*log2(p)
  end
  return e
end
