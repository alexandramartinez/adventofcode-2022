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

## Other repos

- Clayton Flesher's [AdventOfCode2022](https://github.com/claytonflesher/AdventOfCode2022/tree/main/src/main/resources/dwl)
- Ryan Hoegg's [adventofcode2022](https://github.com/rhoegg/adventofcode2022)
- Felix Schnabel's [aoc2022](https://github.com/Shadow-Devil/aoc2022)