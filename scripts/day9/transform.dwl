%dw 2.0
import lines, repeat from dw::core::Strings

output application/json
type Point = { // or knot
    x:Number,
    y:Number
}
type Direction = 'R' | 'L' | 'U' | 'D'
type Rope = Array<Point>
var sPoint:Point = {x:0,y:0}
var rope = (0 to 9) as Array reduce (item, acc=[]) -> acc + sPoint
fun isNear(point1:Point, point2:Point) = do {
    var xDistance = abs(point1.x - point2.x)
    var yDistance = abs(point1.y - point2.y)
    ---
    (xDistance <= 1) and (yDistance <= 1)
}
fun whichDirections(point1:Point, point2:Point): Array | String = do {
    var xDistance = point1.x - point2.x
    var yDistance = point1.y - point2.y
    var isDiagonal = point1.x != point2.x and point1.y != point2.y
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
fun moveRestOfRope(head:Point, rope:Rope, index=0) = do {
    var thisPoint:Point = rope[index]
    @Lazy
    var wd = log(whichDirections(head, thisPoint))
    @Lazy
    var newPoint = wd match {
        case is String -> thisPoint move wd // single move
        case is Array -> (thisPoint move wd[0]) move wd[1] // 2 moves - diagonal
        else -> thisPoint
    }
    ---
    if (isEmpty(thisPoint)) rope
    else if (head isNear thisPoint) rope
    else moveRestOfRope(
        newPoint,
        rope update {
            case [index] -> newPoint
        },
        index + 1
    )
}
fun getTailPoints(directions:String, rope=rope, tailPoints=[sPoint]) = do {
    var direction:Direction = directions[0]
    var head:Point = rope[0]
    @Lazy
    var newHead = log("head moves",head move direction)
    @Lazy
    var newRope = newHead >> moveRestOfRope(newHead, rope[1 to -1])
    ---
    if (isEmpty(directions)) tailPoints
    else getTailPoints(
        directions[1 to -1],
        newRope,
        tailPoints + newRope[-1]
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