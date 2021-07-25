module Values exposing (..)

import String

-- Primitive values

five : Int
five = 5

pi : Float
pi = 3.141592

homero : String
homero = "Homero J. Simpson"

marge : String
marge = "Marge Bouvier"

a : Char
a = 'A'

wave : Char
wave = '👋'

identifier : String
identifier = "Some Value"

t : Bool
t = True

f : Bool
f = False

-- Numeric operations
ten = five + five
zero = five - five
zeroAgain = zero * ten
one = five // five  -- (/) for Float and (//) for Int

twoPi = pi + pi
manyPi = pi * pi * pi
oneF = pi / pi
zeroF = pi - pi
inf = pi / zeroF

-- String operations
couple = homero ++ " and " ++ marge
charsInCouple = String.length couple
onlyHomero = String.left 6 couple
onlyBouvier = String.right 7 couple

-- Boolean operations
t1 = t && t
t2 = t && f
t3 = t || t
t4 = t || f
t5 = not t
t6 = five == five
t7 = pi /= pi
