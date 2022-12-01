# Advent of Code 2022

DataWeave scripts used in the [adventofcode.com](https://adventofcode.com/) site for 2022.

## Day 1

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