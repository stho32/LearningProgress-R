#
#
# MarkR - Express a percentage as school grade
#
# https://www.abi-rechner.com/notentabelle/#Oberstufe
# (german school grade table)
#

#
# MarkR.AsMark 
#
# percentage: 0-100 as a floating point number
# result    : character() "1+" - "6"
#
MarkR.AsMark <- function(percentage) {
  if ( is.null(percentage) || is.na(percentage) ) return (percentage)
  
  if ( percentage >= 95 ) return ("1+")
  if ( percentage >= 90 ) return ("1")
  if ( percentage >= 85 ) return ("1-")
  
  if ( percentage >= 80 ) return ("2+")
  if ( percentage >= 75 ) return ("2")
  if ( percentage >= 70 ) return ("2-")
  
  if ( percentage >= 65 ) return ("3+")
  if ( percentage >= 60 ) return ("3")
  if ( percentage >= 55 ) return ("3-")
  
  if ( percentage >= 50 ) return ("4+")
  if ( percentage >= 45 ) return ("4")
  if ( percentage >= 40 ) return ("4-")
  
  if ( percentage >= 33 ) return ("5+")
  if ( percentage >= 27 ) return ("5")
  if ( percentage >= 20 ) return ("5-")
  
  return ("6");
}

