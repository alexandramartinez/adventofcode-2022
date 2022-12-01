%dw 2.0
output application/json
---
(payload splitBy "\n\n")
map ((item,index) -> do {
    var newItem = item splitBy "\n"
    ---
    sum(newItem) as Number
})
//then max($) //Part 1
//Part 2 below
orderBy $
then $[-1 to -3]
then sum($)