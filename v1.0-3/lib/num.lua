function num0(t)
  local tmp = {mu= 0, n= 0, m2= 0, put=num1,
	       up= -1e32,   lo= 1e32}
  map(t, function (z) num1(z,tmp) end)
  return tmp
end

function num1(z,t)
  if z < t.lo then t.lo = z end
  if z > t.up then t.up = z end
  t.n  = t.n + 1
  local delta = z - t.mu
  t.mu = t.mu + delta / t.n
  t.m2 = t.m2 + delta * (z - t.mu)
  return t
end

function unnum(z,t)
  t.n  = t.n - 1
  local delta = z - t.mu
  t.mu = t.mu - delta/t.n
  t.m2 = t.m2 - delta*(z - t.mu) -- not trust worthy for n < 5 and lost of small "z"
                                 
  return t
end

function sd(t)
  return t.n <= 1 and 0 or (t.m2/(t.n - 1))^0.5
end

function norm(z, t)
  return (z - t.lo) / (t.up - t.lo + 1e-32)
end
