<img src="img/fun.png" align=right>

# [Fun.lua](fun.lua)

## What we got, what we want

Induction means taking lots of examples

    x1,y1
    x2,y2
	x3,y3
	etc

And learning some function

    y = fun(x)

Optimization is taking that function and learning particular values of `x` (which we might call
`betterx`) that lead to better values of `y` (which we might call `bettery`).

    bettery = fun( betterx )

The `Fun` class accepts examples of the form `{x= this,y= that}`
(where `this` and `that` are lists of values). It keeps information on all the `x` and `y` values
in two separate `Space` (linked by the rows).

So in this code, a `Fun`ction are `Row`s of examples from the `x` space and the `y` space.


## Also
- clones are babies with the same properties, but
- not the same data, as their parent(s). if they
- meet the same data as their parent(s) they will
- turn into something different.
