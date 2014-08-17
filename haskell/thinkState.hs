-- state 
import Control.Monad.State
 {- 
State :: {runStateT :: s -> m (a, s)} 
runState :: State s a -> s -> (a, s)
get :: m s
put :: s -> m ()
return Char :: State a Char

(>>) :: Monad m => m a -> m b -> m b
(>>=) :: Monad m => m a -> (a -> m b) -> m b
(>>=) :: State s a -> (a -> State s b) -> State s b

runState (do { put 5; return 'X' }) 1   <==>   runState (put 5 >> return 'X') 1

runState ( do { x <- get; put (x+1); return x }) 1  <==>  runState ( get >>= \x -> put (x+1) >> return x ) 1


 -}
type TestStateVal = (Char, Int, String)
startStateVal :: TestStateVal
startStateVal = ('A', 2, "_")

testStateChg :: TestStateVal
testStateChg = execState (chg) startStateVal -- chg :: State TestState ?
    where chg = get >>= \x@(c,i,s)-> put (c,3*i,s) >> get >>= \x@(c,i,s)-> put (c,i,s++"s") >> return x
testStateChg2 :: TestStateVal
testStateChg2 = execState (chg) startStateVal -- chg :: State TestState ?
    where chg = put ('B',3,"D") >> modify (\(a,b,c)->(a,b*3,c++"D"))
testStateChgs :: TestStateVal
testStateChgs= execState (chg) startStateVal 
    where chg = sequence [put ('B',3,"D") , modify (\(a,b,c)->(a,b*3,c++"D"))]




