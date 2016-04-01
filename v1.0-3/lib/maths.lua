function max(a,b) return a>b and a or b end
function min(a,b) return a<b and a or b end

function gt(a,b) return a > b end
function lt(a,b) return a < b end

function log2(n) return math.log(n)/math.log(2) end


function r1(x) return rn(x,1) end
function r3(x) return rn(x,3) end
function r5(x) return rn(x,5) end

function rn(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) 
          / math.pow(10,precision)
end

printf  = function(s,...) return io.write(s:format(...)) end
sprintf = function(s,...) return s:format(...) end 
