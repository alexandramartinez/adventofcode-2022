%dw 2.0
output application/json 
import divideBy, firstWith, indexOf from dw::core::Arrays
var values = "-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" splitBy ""
fun findChars(first, second) = (
    (first map (firstItem) -> do {
        second firstWith ($ contains firstItem)
    }) 
    filter $ != null 
    distinctBy $
)
---
payload splitBy "\n"
divideBy 3 // PART 2 ONLY
map do {
    // PART 1
    /*
    var middle = sizeOf($) / 2
    var first = $[0 to middle-1] splitBy ""
    var second = $[middle to -1] splitBy ""
    ---
    findChars(first, second) 
    */
    // PART 2
    var first = $[0] splitBy ""
    var second = $[1] splitBy ""
    var third = $[2] splitBy ""
    ---
    findChars(first, second)
    then findChars($, third)
}
then flatten($)
then $ map do {
    values indexOf $
}
then sum($)