# Advent of Code 2022

DataWeave scripts used in the [adventofcode.com](https://adventofcode.com/) site for 2022.

## Scripts

### Day 1

This script was created thanks to [Pavan Vara Prasad Mamidi](https://www.linkedin.com/in/pavan-mamidi/) during [this live stream](https://www.twitch.tv/videos/1667481264).

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2022&path=scripts%2Fday1"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

```dataweave
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
```
</details>

### Day 2

This script was created during [this live stream](https://www.twitch.tv/videos/1673658599).

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2022&path=scripts%2Fday2"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

```dataweave
%dw 2.0
output application/json
/** Part 1
var rules = {
    A: { //R
        X: 3 + 1, //R
        Y: 6 + 2, //P
        Z: 0 + 3 // S
    },
    B: { //P
        X: 0 + 1, //R
        Y: 3 + 2, //P
        Z: 6 + 3 // S
    },
    C: { //S
        X: 6 + 1, //R
        Y: 0 + 2, //P
        Z: 3 + 3 // S
    }
}*/

// Part 2
var rules = {
    A: { //R
        X: 0 + 3, //L S
        Y: 3 + 1, //D R
        Z: 6 + 2 // W P
    },
    B: { //P
        X: 0 + 1, //L R
        Y: 3 + 2, //D P
        Z: 6 + 3 // W S
    },
    C: { //S
        X: 0 + 2, //L P
        Y: 3 + 3, //D S
        Z: 6 + 1 // W R
    }
}
---
payload splitBy "\n"
reduce ((round, score=0) -> do {
    var arr = round splitBy " "
    var opponent = arr[0]
    var me = arr[-1]
    ---
    score + (rules[opponent][me] default 0)
})
```
</details>

### Day 3

This script was created during the following live streams:
1. [Happy new year!! First stream of 2023 ✨ | Advent of Code day 3](https://www.twitch.tv/videos/1710480386)
2. [Advent of Code day 3 with DataWeave...FINALIZED!](https://www.twitch.tv/videos/1710523773)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2022&path=scripts%2Fday3"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

```dataweave
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
```
</details>

### Day 4

This script was created during the following live stream:
1. [Advent of Code 2022 day 4 -- with DataWeave!](https://www.twitch.tv/videos/1711294136)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2022&path=scripts%2Fday4"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

```dataweave
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
```
</details>

### Day 5

This script was created during the following live streams:
1. [Still doing Advent of Code '22 day 5 with DataWeave!](https://www.twitch.tv/videos/1712147286)
2. [Advent of Code 2022 days 5.2 and 6! ✨](https://www.twitch.tv/videos/1712316242)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2022&path=scripts%2Fday5"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

```dataweave
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
```
</details>

### Day 6

This script was created during the following live stream:
1. [Advent of Code 2022 days 5.2 and 6! ✨](https://www.twitch.tv/videos/1712316242)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2022&path=scripts%2Fday6"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

```dataweave
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
```
</details>

## Other repos

- Clayton Flesher's [AdventOfCode2022](https://github.com/claytonflesher/AdventOfCode2022/tree/main/src/main/resources/dwl)
- Ryan Hoegg's [adventofcode2022](https://github.com/rhoegg/adventofcode2022)
- Felix Schnabel's [aoc2022](https://github.com/Shadow-Devil/aoc2022)