import qualified Data.Tree.Class as Tree
import Data.Tree.NTree.TypeDefs
import qualified Text.XML.HXT.DOM.FormatXmlTree as F
import qualified Text.XML.HXT.Parser.XmlParsec as P
import qualified Text.XML.HXT.Core as H
import qualified Text.XML.HXT.DOM.QualifiedName as QN
import qualified Text.XML.HXT.DOM.XmlNode as XN
import Data.Monoid
import qualified Text.XML.HXT.DOM.ShowXml as SX
--import qualified Text.XML.HXT.DOM.XmlTreeFilter as R
{-TODO
- [x] Функцию заменяющую тэг с атрибутом с *данным* именем, с текстом на *данный* текст
        тип :: XNode -> String -> String -> XNode
        арг node attrName newText
            - [x] сделаем тестовые данные, заменим текст тэга с атрибутом target 
                "<not notarget='f'>text</not>"
                "<tot target='s'>source</tot>" -> "<tot target='s'>dest</tot>"
        - [x] функцию проверки тэга :: attrnode tagName tagText :: XNode -> String -> String -> Bool
- [x] Функцию заменяющую тэг с атрибутом с *данным* именем и *данным* значением, с текстом на *данный* текст
- [?] промапить данной функцией всё дерево, вглубь
    - [ ] надо лучше протестировать
- [ ] скопировать и почистить исходник от тестового хлама
 - [ ] надо сделать замену не текста в этом теге а текста в определённом теге
        Функцию заменяющую содержание текста тегов содержащихся в тэге с атрибутом с *данным* именем и *данным* значением
- [ ] заменять UUID все на новые
    - [ ] разобраться с генерацией UUID
    - [ ] хранить список пар заменённых
    - [ ] заменять одинаковые на одинаковые
- [ ] опционально заменять versionFirst true/false
- [ ] заменять время versionStartTime на новое везде
- [ ] в конце в строке заменять старые уиды(мы же их ещё храним) на новые (в dataSourceRef - uuid)
- [ ] заменять имена ?
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
testrepltext1 = Tree.getChildren $ head test1x
testrepltext2 = fromMaybe $ XN.getText $ head  $ Tree.getChildren $ head test1x

test2 = P.xread "<tot otherattr='da' target='s'>source</tot>"
test2AttrsIs = or $ (fmap (\x-> isThatAttr x "target" "s") (getAttrf $ head test2))
test3 = replaceTextIn (head test1x) "NEWTEXT" "target" "s"
test3n = P.xread "<tot otherattr='da' targets='s'>source</tot>"
test3a = P.xread "<tot otherattr='da' target='a'>source</tot>"
test3nn = replaceTextIn (head test3n) "NEWTEXT" "targets" "s"
test3aa = replaceTextIn (head test3a) "NEWTEXT" "target" "s"


replaceTextIn :: NTree H.XNode -> String -> String -> String -> NTree H.XNode
replaceTextIn n@(NTree (H.XTag tagName attrList) childWithText) newText attrName attrVal = 
    if (or (fmap (\x-> isThatAttr x attrName attrVal) attrList)) then 
        (NTree (H.XTag tagName attrList) (replaceText childWithText newText))
        else (NTree (H.XTag tagName attrList) (fmap (\x-> replaceTextIn x newText attrName attrVal) childWithText)) 
replaceTextIn n _ _ _ = n

replaceText :: H.XmlTrees -> String -> H.XmlTrees
replaceText ((NTree (H.XText _) [])  : other) newText = ((NTree (H.XText newText) [])  : other)
replaceText n _ = n

replaceTextInChilds :: NTree H.XNode -> String -> String -> String -> String -> NTree H.XNode
replaceTextInChilds n@(NTree (H.XTag tagName attrList) childs) newText attrName attrVal inTag = 
    if (or (fmap (\x-> isThatAttr x attrName attrVal) attrList)) then 
        (NTree (H.XTag tagName attrList) (fmap (\x-> replaceTextChild x newText inTag) childs ))
        else (NTree (H.XTag tagName attrList) (fmap (\x-> replaceTextInChilds x newText attrName attrVal inTag ) childs)) 
replaceTextInChilds n _ _ _ _ = n

replaceTextChild :: H.XmlTree -> String -> String -> H.XmlTree
replaceTextChild n@(NTree (H.XTag tagName a) childWithText) newText inTag | (QN.localPart tagName) == inTag = 
    (NTree (H.XTag tagName a) (replaceText childWithText newText))
replaceTextChild n _ _ = n


getAttr :: H.XmlTree -> Maybe H.XmlTrees
getAttr = XN.getAttrl . Tree.getNode 

getAttrf :: H.XmlTree -> H.XmlTrees
getAttrf = fromMaybe . XN.getAttrl . Tree.getNode 

fromMaybe :: (Monoid a) => Maybe a -> a
fromMaybe a = maybe mempty id a

replaceInTree :: H.XmlTrees -> String -> String -> String -> H.XmlTrees
replaceInTree tree text attrName attrVal = fmap (\x-> replaceTextIn x text attrName attrVal ) tree

{-NTree (XTag "tot" 
                [NTree (XAttr "target") 
                       [NTree (XText "s") []]])
      [NTree (XText "source") []] -}
--то есть надо у тэга проверить атрибут и если он подходит то найти текст и если он есть заменить его

testXMLs = "<a><A y='Y'>tx</A></a><b z='Z'>ss</b><c x='X' xx='_'><e><f t='t'><v>val</v><v>val2</v></f></e></c>"
testXML = P.xread testXMLs
b = F.formatXmlTree $ head testXML
c = putStrLn b

d = fmap F.formatXmlTree testXML
e = mapM putStrLn d
showx x = mapM putStrLn (fmap F.formatXmlTree x)

f = head testXML
--g H.XTag x = x
g (H.XText x) = H.XText $ "new" ++ x
g x = x 
h = fmap g f
i = showx [h]
-- ============
ftest = fmap (\x-> replaceTextIn x "" "" "" ) testXML
ftesta a b c = fmap (\x-> replaceTextIn x a b c ) testXML
ptest a b c = showx (ftesta a b c)

rtest a b c d = fmap (\x-> replaceTextInChilds x a b c d) 
rr a b c d = 

mtest = do 
    con <- readFile "/home/ksi/dev/testweb/1.xml"
    let res = replaceInTree (P.xread con) "NEWTEXT" "sv:name" "jcr:uuid"
    writeFile "/home/ksi/dev/testweb/out.xml" (SX.xshow res)
    print "ok"

main = do 
    
    
    
    print "end."
