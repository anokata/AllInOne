import qualified Data.Tree.Class as B
import Data.Tree.NTree.TypeDefs
import qualified Text.XML.HXT.DOM.FormatXmlTree as F
import qualified Text.XML.HXT.Parser.XmlParsec as P
import qualified Text.XML.HXT.Core as H
--import qualified Text.XML.HXT.DOM.XmlTreeFilter as R
{-TODO
- [ ] Функцию заменяющую тэг с атрибутом с *данным* именем, с текстом на *данный* текст
        тип :: XNode -> String -> String -> XNode
        арг node attrName newText
            - [ ] сделаем тестовые данные, заменим текст тэга с атрибутом target 
                "<not notarget='f'>text</not>"
                "<tot target='s'>source</tot>" -> "<tot target='s'>dest</tot>"
- [ ] промапить данной функцией всё дерево
- [ ] Функцию заменяющую тэг с атрибутом с *данным* именем и *данным* значением, с текстом на *данный* текст
-}
tagTextReplace :: H.XNode -> String -> String -> H.XNode
tagTextReplace (H.XTag node) attrName newText = 
tagTextReplace x _ _ = x
--test1 = 

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
