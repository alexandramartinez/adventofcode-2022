%dw 2.0
import mapString, someCharacter from dw::core::Strings
output application/json
var numberOfMarkers = 14 // PART 1 = 4
fun findThing(str) = do {
    var toEvaluate = str[0 to numberOfMarkers-1] splitBy ""
    var repeated = sizeOf(toEvaluate distinctBy $) < numberOfMarkers
    ---
    if (repeated) findThing(str[1 to -1])
    else if (toEvaluate == null) -1
    else toEvaluate
}
---
findThing(payload) 
joinBy ""
then indexOf(payload, $) + numberOfMarkers