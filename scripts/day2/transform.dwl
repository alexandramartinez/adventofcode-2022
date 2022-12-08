%dw 2.0
output application/json
// Rock defeats Scissors
// Scissors defeats Paper
// Paper defeats Rock

// The other person
// A for Rock 
// B for Paper 
// C for Scissors

// Me
// X Rock / Lose
// Y Paper / Draw
// Z Scissors / Win

// Scores
// 1 for Rock
// 2 for Paper
// 3 for Scissors
// 0 if you lost
// 3 if the round was a draw
// 6 if you won

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