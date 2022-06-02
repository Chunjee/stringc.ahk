stringsimilarity.ahk
=================

Finds degree of similarity between two strings, based on [Dice's Coefficient](http://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient), which is mostly better than [Levenshtein distance](http://en.wikipedia.org/wiki/Levenshtein_distance).


## Installation
In a terminal or command line navigated to your project folder:
```bash
npm install stringsimilarity.ahk
```

In your code only export.ahk needs to be included:
```autohotkey
#Include %A_ScriptDir%\node_modules
#Include stringsimilarity.ahk\export.ahk
oStringSimilarity := new stringsimilarity()

oStringSimilarity.compare("test", "testing")
; => 0.67
oStringSimilarity.compare("Hello", "hello")
; => 1.0
```

## API
Including the module provides a class `stringsimilarity` with three methods: `.compare`, `.rate`, and `.closestMatch`
