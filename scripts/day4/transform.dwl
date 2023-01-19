%dw 2.0
output application/json 
import countBy, some from dw::core::Arrays
fun getRange(sections) = do {
    var arr = sections splitBy "-"
    var range = arr[0] to arr[1]
    ---
    // PART 1
    //" $(range joinBy " , ") "
    // PART 2
    range
}
---
payload splitBy "\n"
map do {
    var pairs = $ splitBy ","
    var first = getRange(pairs[0])
    var second = getRange(pairs[1])
    ---
    // PART 1
    //(first contains second) or (second contains first)
    // PART 2
    (first map (firstItem) -> (
        second some $ == firstItem
    )) some $
} 
countBy $