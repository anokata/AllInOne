import Prelude hiding (id, (>>))

class Category cat where
    id :: cat a a
    (>>) :: cat a b -> cat b c -> cat a c

class Kleisli m where
    idK :: a -> m a
    (*>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

(+>) :: Kleisli m => (a -> m b) -> (b -> c) -> (a -> m c)
f +> g = f *> (g >> idK)

instance Category (->) where
    id = \x -> x
    f >> g = g . f -- \x -> g (f x)

instance Kleisli Maybe where
    idK = Just
    f *> g = \x -> case f x of 
                        Nothing -> Nothing
                        Just b -> g b

instance Kleisli [] where
    idK = \x -> [x]
    f *> g = f >> map g >> concat -- \x -> concat $ map g (f x)

--my axiom\theorem generator
--nextTheorem :: Theorem -> [Theorem]

--apply 
(*$) :: Kleisli m => (a -> m b) -> m a -> m b
(+$) :: Kleisli m => (a -> b) -> m a -> m b

f *$ a = (const a *> f) ()
f +$ a = (const a +> f) ()
infixr 0 +$, *$

$$ :: Kleisli m => m (a -> b) -> m a -> m b
mf $$ ma = ( +$ ma) *$ mf

lift2 :: Kleisli m => (a -> b -> c) -> m a -> m b -> m c
lift2 f a b = 





