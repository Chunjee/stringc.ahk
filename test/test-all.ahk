SetBatchLines, -1
#SingleInstance, force
#NoTrayIcon
#Include %A_ScriptDir%\..\export.ahk
#Include %A_ScriptDir%\..\node_modules
#Include expect.ahk\export.ahk

stringc := new stringc()
assert := new expect()

;; Test Vars
testVar := stringc.compareAll(["levenshtein","matching","similarity"], "similar")
testVar2 := stringc.compareAll([" hard to    ","hard to","Hard 2"], "Hard to")


;; Test compare()
assert.category := "compare"
assert.label("check functional")
assert.test((stringc.compare("The eturn of the king", "The Return of the King") > 0.90 ), true)
assert.test((stringc.compare("set", "ste") = 0 ), true)

assert.label("Check if case matters")
assert.true((stringc.compare("The Mask", "the mask") = 1 ))
assert.true(stringc.compare("thereturnoftheking", "TheReturnoftheKing") = 1 )
StringCaseSense, On
assert.true(stringc.compare("thereturnoftheking", "TheReturnoftheKing") = 1 )
StringCaseSense, Off


;; Test compareAll()
assert.category := "rate"
assert.label("ratings object")
assert.test(testVar.ratings.count(), 3)
assert.test(testVar.ratings[1].target, "similarity")
assert.test(testVar.ratings[1].rating, 0.80)
assert.test(testVar.ratings[2].target, "matching")
assert.test(testVar.ratings[2].rating, 0)
assert.test(testVar.ratings[3].target, "levenshtein")
assert.test(testVar.ratings[3].rating, 0)

assert.label("bestMatch object")
assert.test(testVar.bestMatch.target, "similarity")
assert.test(testVar.bestMatch.rating, 0.80)
assert.test(testVar2.bestMatch.target, "hard to")
assert.test(testVar2.bestMatch.rating, 1)


;; Test closestMatch()
assert.category := "closestMatch"
assert.label("basic usage")
assert.test(stringc.closestMatch(["ste","one","set"], "setting"), "set")
assert.test(stringc.closestMatch(["smarts","smrt","clip-art"], "Smart"), "smarts")
assert.test(stringc.closestMatch(["green Subaru Impreza","table in very good","mountain bike with"], "Olive-green table"), "table in very good")
assert.test(stringc.closestMatch(["For sale: green Subaru Impreza, 210,000 miles"
    , "For sale: table in very good condition, olive green in colour."
    , "Wanted: mountain bike with at least 21 gears."], "Olive-green table for sale, in extremely good condition.")
, "For sale: table in very good condition, olive green in colour.")


assert.final()
;; Display test results in GUI
assert.fullReport()
assert.writeTestResultsToFile()

exitApp
