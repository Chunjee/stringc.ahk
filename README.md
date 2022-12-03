<div align="center">
	<a href="https://github.com/chunjee/stringc.ahk">
		<img src="https://raw.githubusercontent.com/Chunjee/stringc.ahk/2bc5cd367b53698d8c7cd93d19b73f1015728d53/header.svg"/>
	</a>
	<br>
	<br>
	<a href="https://npmjs.com/package/stringc.ahk">
		<img src="https://img.shields.io/npm/dm/stringc.ahk?style=for-the-badge">
	</a>
	<a href="https://github.com/Chunjee/stringc.ahk#api">
		<img src="https://img.shields.io/badge/documentation-blue?style=for-the-badge">
	</a>
	<img src="https://img.shields.io/npm/l/stringc.ahk?color=tan&style=for-the-badge">
</div>

Finds degree of similarity between two strings, based on [Dice's Coefficient](http://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient), which is mostly better than [Levenshtein distance](http://en.wikipedia.org/wiki/Levenshtein_distance).


## Installation
In a terminal or command line navigated to your project folder:
```bash
npm install stringc.ahk
```

In your code only export.ahk needs to be included:
```autohotkey
#Include %A_ScriptDir%\node_modules
#Include stringc.ahk\export.ahk
ostringc := new stringc()

ostringc.compare("test", "testing")
; => 0.67
ostringc.compare("Hello", "hello")
; => 1.0
```

## API
Including the module provides a class `stringc` with three methods: `.compare`, `.compareAll`, and `.bestMatch`


### compare(string1, string2, [function])
Returns a fraction between 0 and 1, which indicates the degree of similarity between the two strings. 0 indicates completely different strings, 1 indicates identical strings. The comparison is case-insensitive.

##### Arguments
string1 (string): The first string

string2 (string): The second string

function (function): A function to applied to both strings prior to comparison.

Order does not make a difference.

##### Returns
(Number): A fraction from 0 to 1, both inclusive. Higher number indicates more similarity.

##### Example
```autohotkey
stringc.compare("healed", "sealed")
; => 0.80

stringc.compare("Olive-green table for sale, in extremely good condition."
	, "For sale: table in very good  condition, olive green in colour.")
; => 0.71

stringc.compare("Olive-green table for sale, in extremely good condition."
	, "For sale: green Subaru Impreza, 210,000 miles")
; => 0.30

stringc.compare("Olive-green table for sale, in extremely good condition."
	, "Wanted: mountain bike with at least 21 gears.")
; => 0.11
```

### compareAll(targetStrings, mainString, [function])
Compares `mainString` against each string in `targetStrings`.

##### Arguments
targetStrings (array): Each string in this array will be matched against the main string.

mainString (string): The string to match each target string against.

function (function): A function to applied to each element in `targetStrings` prior to comparison.

##### Returns
(Object): An object with a `ratings` property, which gives a similarity rating for each target string, and a `bestMatch` property, which specifies which target string was most similar to the main string. The array of `ratings` are sorted from higest rating to lowest.

##### Example
```autohotkey
stringc.compareAll(["For sale: green Subaru Impreza, 210,000 miles"
	, "For sale: table in very good condition, olive green in colour."
	, "Wanted: mountain bike with at least 21 gears."]
	, "Olive-green table for sale, in extremely good condition.")
; =>
{ ratings:
	[{ target: "For sale: table in very good condition, olive green in colour.",
		rating: 0.71 },
	{ target: "For sale: green Subaru Impreza, 210,000 miles",
		rating: 0.30 },
	{ target: "Wanted: mountain bike with at least 21 gears.",
		rating: 0.11 }],
	bestMatch:
	{ target: "For sale: table in very good condition, olive green in colour.",
		rating: 0.71 } }
```


### bestMatch(targetStrings, mainString, [function])
Compares `mainString` against each string in `targetStrings`.

##### Arguments
mainString (string): The string to match each target string against.
targetStrings (Array): Each string in this array will be matched against the main string.
function (function): A function to applied to strings prior to comparison.

##### Returns
(String): The string that was most similar to the first argument string.

##### Example
```autohotkey
stringc.bestMatch([" hard to    "
	, "hard to"
	, "Hard 2"]
	, "Hard to")
; => "hard to"
```
