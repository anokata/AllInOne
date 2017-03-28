module tf1
let _ = printf "Hello world"
let _ = printf "\n Another: %i" 199883

let SampleArithmetic1() =
    let x = 10 + 12 - 3 
    let y = x * 2 + 1 
    let r1,r2 = x/3, x%3
    printfn "x = %d, y = %d, r1 = %d, r2 = %d" x y r1 r2

let _ = SampleArithmetic1()
