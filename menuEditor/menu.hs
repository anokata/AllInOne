import System.IO
import System.Environment
import Data.List

showcmd = ["show","s","view","v"]
delcmd  = ["del","d","delete","remove","r"]
addcmd  = ["add","a","+"]
-- cmd arg format: menu cmd file [arg]

main = do
    
    putStrLn "."
