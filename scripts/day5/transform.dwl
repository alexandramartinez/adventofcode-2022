%dw 2.0
output application/json 
import isUpperCase from dw::core::Strings
import take, drop from dw::core::Arrays
import update from dw::util::Values

var instructions = (payload splitBy "\n\n")[1] splitBy "\n"
    then $ map do {
        var i = flatten($ scan /\d+/)
        ---
        {
            crates: i[0] as Number,
            from: i[1]-1,
            to: i[2]-1
        }
    }
var crates = (payload splitBy "\n\n")[0] splitBy "\n"

fun getStuff(crates, result=[]) = do {
    var r = crates map (
            $[0 to 2] filter isUpperCase($)
        ) filter !isEmpty($)
        //then $[-1 to 0]
    var nc = crates map $[4 to -1]
    var newr = result + r
    ---
    if (nc[0] == null) newr
    else getStuff(nc,newr)
}

fun move(instructions, crates) = do {
    @Lazy
    var i = instructions[0]
    @Lazy
    var cratesToTake = crates[i.from] take i.crates
    @Lazy
    var newColumnFrom = crates[i.from] drop i.crates
    @Lazy
    // PART 1
    // var newColumnTo = cratesToTake[-1 to 0] ++ crates[i.to]
    // PART 2
    var newColumnTo = cratesToTake ++ crates[i.to]
    @Lazy
    var newCrates = crates update i.from with newColumnFrom
        then $ update i.to with newColumnTo
    ---
    if (isEmpty(instructions)) crates
    else move(instructions drop 1, newCrates)
}
---
move(instructions, getStuff(crates))
map ($[0]) 
joinBy ""