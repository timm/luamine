<img align=right width=300 src="img/csv.png">

# Lines.lua


## Input

Text files contain comma seperated values.

## Output

One table per row of the form `{x=t1,y=t2}` where
`t1` are the independent variables and `t2` are the
dependent variables (and all num strings coerced to
numbers)

## Synopsis

     io.input("data.csv") 
     for n,row in lines() do
       -- handle row n
     end

Note this code runs as an iterator that reads one
line at a time into RAM (lets learners decide how
much information, if any, they want to keep around).

## Features

- Kills white space and comments.
- Skips blank lines.
- Lines ending with the seperator are continued to the next.
- Lines are split on the seperator.
- First line is a list of names for the columns.
      - Other lines are data.
- Names have magic symbols as defined in magic.lua
- Columns with names with the ignore character are ignored.
- Columns with names with the numeric character are treated special.
      - Specifically, cells in numerc columns are coerced
        to numbers (unless they are just the missing
         character)

## Performance

This code eats 10MB of a CSV file with 18 rows in
2.2 secs, using luajit (on a Mac running OS X El Capitan.

And that is after near zero
work on optimizations.
