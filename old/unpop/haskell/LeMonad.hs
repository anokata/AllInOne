--exercice Writer
--import Control.Monad.Writer
import Data.Monoid
import Data.Char
--
data Writer logtype datatype = Writer { fromWriter :: (datatype,logtype) } deriving (Show)
-- logtype is Monoid
instance (Monoid logtype) => Monad (Writer logtype) where
  --return :: a -> m a  :: datatype -> (Writer logtype) datatype :: datatype -> Writer logtype datatype
  return x = Writer (x, mempty) -- use monoid feature
  --bind (>>=) :: m a -> (a->m b) -> m b  ::  Writer logtype datatypeOne -> (datatypeOne-> Writer logtype datatypeTwo) -> Writer logtype datatypeTwo
  -- monad is about fmap "in the" something to some else other type "in the" same thing
  (Writer (oldData, oldLog)) >>= funMakeSomeWrite =  -- достали паттерном 
    let (newData, newLog) = fromWriter $ funMakeSomeWrite oldData -- скормили функции, получив новое
    in Writer (newData, mappend oldLog newLog)  -- запаковали новое скомбинированное со старым use monoid

main = return 3

type TestWriter = Writer String Int
type TestWriter2 = Writer String Char
testWriter :: Writer String Int
testWriter = return 3

intfuncWithLog :: Int -> TestWriter
intfuncWithLog x = Writer (x*30, "mult "++ show x ++" with 30\n")

test1 = testWriter >>= intfuncWithLog
test2 = return 33 >>= intfuncWithLog >>= intfuncWithLog

f2 :: Int -> TestWriter2
f2 x = let res = chr (x+3)
    in Writer (res, "turn "++ show x ++" to char+3")

f3 :: Char -> TestWriter
f3 x = let res = (ord x) - 31
    in Writer (res, "turn back!")

test3 = return 33 >>= intfuncWithLog >>= intfuncWithLog >>= f2
test4 = return 33 >>= intfuncWithLog >>= intfuncWithLog >>= f2 >>= f3 >>= intfuncWithLog

class (Monoid w, Monad m) => MonadWriter w m | m -> w where 
    pass   :: m (a,w -> w) -> m a 
    -- 
    listen :: m a -> m (a,w) 
    tell   :: w -> m () 



---------------------------------------------------------------------




















