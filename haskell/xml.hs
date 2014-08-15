import qualified Data.Tree.Class as B
import Data.Tree.NTree.TypeDefs
import qualified Text.XML.HXT.DOM.FormatXmlTree as F
import qualified Text.XML.HXT.Parser.XmlParsec as P
import qualified Text.XML.HXT.Core as H

testXML = "<a><A y='Y'>tx</A></a><b z='Z'></b><c x='X' xx='_'></c>"
a = P.xread testXML
b = F.formatXmlTree $ head a
c = putStrLn b

d = fmap F.formatXmlTree a
e = mapM putStrLn d
showx x = mapM putStrLn (fmap F.formatXmlTree x)

f = head a
--g H.XTag x = x
g (H.XText x) = H.XText $ "new" ++ x
g x = x 
h = fmap g f
i = showx [h]

main = do 
    
    
    
    print "end."
