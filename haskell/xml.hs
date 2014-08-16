import qualified Data.Tree.Class as Tree
import Data.Tree.NTree.TypeDefs
import qualified Text.XML.HXT.DOM.FormatXmlTree as F
import qualified Text.XML.HXT.Parser.XmlParsec as P
import qualified Text.XML.HXT.Core as H
import qualified Text.XML.HXT.DOM.QualifiedName as QN
import qualified Text.XML.HXT.DOM.XmlNode as XN
import Data.Monoid
--import qualified Text.XML.HXT.DOM.XmlTreeFilter as R
{-TODO
- [ ] Функцию заменяющую тэг с атрибутом с *данным* именем, с текстом на *данный* текст
        тип :: XNode -> String -> String -> XNode
        арг node attrName newText
            - [ ] сделаем тестовые данные, заменим текст тэга с атрибутом target 
                "<not notarget='f'>text</not>"
                "<tot target='s'>source</tot>" -> "<tot target='s'>dest</tot>"
        - [ ] функцию проверки тэга :: attrnode tagName tagText :: XNode -> String -> String -> Bool
- [ ] промапить данной функцией всё дерево
- [ ] Функцию заменяющую тэг с атрибутом с *данным* именем и *данным* значением, с текстом на *данный* текст
-}
isThatAttr :: NTree H.XNode -> String -> String -> Bool
isThatAttr (NTree (H.XAttr qname) [NTree (H.XText text) []]) tagName tagText | (QN.localPart qname) == tagName && text == tagText = True
isThatAttr _ _ _ = False

tagTextReplace :: H.XNode -> String -> String -> H.XNode
--tagTextReplace (H.XTag name trees) attrName newText = 
tagTextReplace x _ _ = x
test1 = "<tot target='s'>source</tot>"
test1x = P.xread test1
test1xa = Tree.getNode $ head test1x
test1xatr = maybe [] id (XN.getAttrl test1xa)
testA = isThatAttr (head (fromMaybe $ getAttr $ head test1x)) "target" "s"

getAttr :: H.XmlTree -> Maybe H.XmlTrees
getAttr = XN.getAttrl . Tree.getNode 

fromMaybe :: (Monoid a) => Maybe a -> a
fromMaybe a = maybe mempty id a

{-NTree (XTag "tot" 
                [NTree (XAttr "target") 
                       [NTree (XText "s") []]]) 
      [NTree (XText "source") []] -}
--то есть надо у тэга проверить атрибут и если он подходит то найти текст и если он есть заменить его

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
