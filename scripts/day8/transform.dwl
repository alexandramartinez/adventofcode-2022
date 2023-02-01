%dw 2.0
import countBy, every from dw::core::Arrays
import lines, everyCharacter from dw::core::Strings
output application/json
var linesarr = lines(payload)
fun countTrees(thisTree:String, nextTrees:String, count=0):Number = do {
    if (isEmpty(nextTrees)) count
    else if (nextTrees[0] < thisTree) countTrees(thisTree, nextTrees[1 to -1], count+1)
    else count+1
}
---
flatten
(linesarr map (line, y) -> do {
    var edge = sizeOf(line) - 1
    ---
    (line splitBy "") map (tree, x) -> do {
        // PART 1
        /*
        var edges:Boolean = (x == 0 or y == 0 or x == edge or y == edge)
        var left:Boolean = (line[0 to (x-1)] everyCharacter ($ < tree))
        var right:Boolean = (line[(x+1) to -1] everyCharacter ($ < tree))
        var top:Boolean = (linesarr[0 to y-1] every $[x] < tree)
        var bottom:Boolean = (linesarr[(y+1) to -1] every $[x] < tree)
        ---
        edges or left or right or top or bottom
        */

        // PART 2
        var left:Number = if (x==0) 1
            else tree countTrees line[(x-1) to 0]
        var right:Number = if (x==edge) 1
            else tree countTrees line[(x+1) to -1]
        var top:Number = if (y==0) 1
            else tree countTrees (linesarr[0 to y-1] reduce ((str, a='') -> str[x] ++ a))
        var bottom:Number = if (y==edge) 1
            else tree countTrees (linesarr[(y+1) to -1] reduce ((str, a='') -> a ++ str[x]))
        ---
        left * right * top * bottom

        // {
        //     linesarr: 0,
        //     line: line,
        //     y: y,
        //     tree: tree,
        //     x: x
        // }
    }
}) 
// PART 1
//countBy $
// PART 2
then max($)