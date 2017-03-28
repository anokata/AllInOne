import qualified Text.XML.HXT.Parser.XmlParsec as P
import qualified Text.XML.HXT.DOM.FormatXmlTree as X
import qualified Text.XML.HXT.Core as T
import Data.Tree.NTree.TypeDefs

testfile = "d:\\Q\\2123\\test.xml"
outfile = testfile++".out.xml"
xmlheader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" -- уже flatten должен быть
magicNumber = length xmlheader
path = "d:\\Q\\hasqell\\copyreport\\"
-- drop 38 
main = do
	con <- readFile testfile
	let xml = P.xread $ drop magicNumber con
	writeFile (path++"tree.txt") (X.formatXmlTree $ head xml)
	print $ t (head xml)
	writeFile (path++"tree2.txt") (X.formatXmlTree $ t (head xml))
	writeFile (path++"atree.txt") (show $ head xml)
	writeFile (path++"atree2.txt") (show $ t (head xml))
	--writeFile outfile result
	putStrLn "end."

t :: NTree T.XNode -> NTree T.XNode
t x = fmap processEveryXnode x
	where --processEveryXnode :: T.XNode -> T.XNode
		  processEveryXnode x = case x of 
			T.XText t -> T.XText t--"*text*"
		--	T.XTag n t -> -- t:: XmlTrees = NTrees Xnode
				{- T.XTag n (processTrees $ head t)
					where 
						--processTrees :: T.XmlTrees -> T.XmlTrees
						processTrees t = (fmap (\t-> fmap processEverySubXnode t) t) --(processSubTrees t)
							where 
								processEverySubXnode t = case t of 
									T.XAttr a -> T.XText "AA"
									otherwise -> t
-}
			otherwise -> x
				--where processSubTrees t = fmap (\t-> fmap processEveryXnode t) t
			


{-
xread :: String -> T.XmlTrees
XmlTrees = NTrees T.XNode
xread :: String -> NTrees T.XNode
	NTrees a = [NTree a]
		NTree is Functor
	XNode = 
		XText String
	|   XTag QName XmlTrees
	|   XAttr QName  ...
	
XText "some" :: XNode
NTree (XText "some") [] :: NTree XNode
[NTree (XText "some") []] :: [NTree XNode] = NTrees XNode = XmlTrees

-}

