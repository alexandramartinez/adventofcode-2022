%dw 2.0
import lines, repeat from dw::core::Strings

output application/json
type Point = {
    x:Number,
    y:Number
}
type Direction = 'R' | 'L' | 'U' | 'D'
var sPoint:Point = {x:0,y:0}
fun isNear(head:Point, tail:Point) = do {
    var xDistance = abs(head.x - tail.x)
    var yDistance = abs(head.y - tail.y)
    ---
    (xDistance <= 1) and (yDistance <= 1)
}
fun whichDirections(head:Point, tail:Point): Array | String = do {
    var xDistance = head.x - tail.x
    var yDistance = head.y - tail.y
    var isDiagonal = head.x != tail.x and head.y != tail.y
    ---
    if (isDiagonal) ([] +
        (if (xDistance >= 1) 'R'
        else if (xDistance <= -1) 'L'
        else '')
        +
        (if (yDistance >= 1) 'U'
        else if (yDistance <= -1) 'D'
        else '')
    )
    else (
        if (xDistance > 1) 'R'
        else if (xDistance < -1) 'L'
        else if (yDistance > 1) 'U'
        else if (yDistance < -1) 'D'
        else ''
    )
}
fun move(point:Point, direction:Direction): Point = 
    direction match {
		case "D" -> {
			x: point.x,
			y: point.y - 1
		}
		case "U" -> {
			x: point.x,
			y: point.y + 1
		}
		case "L" -> {
			x: point.x - 1,
			y: point.y
		}
		case "R" -> {
			x: point.x + 1,
			y: point.y
		}
		else -> point
	}
fun getTailPoints(directions:String, head=sPoint, tail=sPoint, tailPoints=[sPoint]) = do {
    var direction:Direction = directions[0]
    @Lazy
    var newHead = log("head moves",head move direction)
    @Lazy
    var wd = log(whichDirections(newHead, tail))
    @Lazy
    var newTail = wd match {
        case is String -> tail move wd // single move
        case is Array -> (tail move wd[0]) move wd[1] // 2 moves - diagonal
        else -> tail
    }
    @Lazy
    var restOfDirections = directions[1 to -1]
    ---
    if (isEmpty(directions)) tailPoints
    else if (log("newHead isNear tail",newHead isNear log("tail",tail)))
        getTailPoints(
            restOfDirections, 
            newHead, tail, tailPoints
        )
    else getTailPoints(
        restOfDirections,
        newHead, newTail, tailPoints + newTail
    )
}
---
(lines(payload) map (line) -> do {
    var splits = line splitBy " "
    var d = splits[0]
    var howmany = splits[1]
    ---
    d repeat howmany
}) joinBy ""
then getTailPoints($) distinctBy $
then sizeOf($)