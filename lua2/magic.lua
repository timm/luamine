Chars =  {
  white   = "[ \t\n]*", -- kill all whitespace
  comment = "#.*",        -- kill all comments
  sep     = ",",          -- field seperators
  ignorep = "[\\?]",
  missing = '[\\?]',
  klass   = "=",
  less    = "<",
  more    = ">",
  floatp  = "[\\$]",
  intp    = ":",
  goalp   = "[><=]",
  nump    = "[:\\$><]",
  dep     = "[=<>]"
}
