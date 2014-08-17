import qualified Data.Tree.Class as Tree
import Data.Tree.NTree.TypeDefs
import qualified Text.XML.HXT.DOM.FormatXmlTree as F
import qualified Text.XML.HXT.Parser.XmlParsec as P
import qualified Text.XML.HXT.Core as H
import qualified Text.XML.HXT.DOM.QualifiedName as QN
import qualified Text.XML.HXT.DOM.XmlNode as XN
import Data.Monoid
import qualified Text.XML.HXT.DOM.ShowXml as SX
import Data.UUID -- toString fromString
import Data.UUID.V4 -- nextRandom
import Data.Text(count, pack)
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
- [x] промапить данной функцией всё дерево, вглубь
    - [x] надо лучше протестировать
- [ ] скопировать и почистить исходник от тестового хлама
 - [x] надо сделать замену не текста в этом теге а текста в определённом теге
        Функцию заменяющую содержание текста тегов содержащихся в тэге с атрибутом с *данным* именем и *данным* значением
- [ ] заменять UUID все на новые
    - [x] разобраться с генерацией UUID
    - [.] заменять не просто на текст, а передавать функцию принимающую предыдущее значения текста и возвр. новое
    - [.] хранить список пар заменённых
        - [ ] сделать с помощью монады State
          - [ ] понять Monad State
    - [ ] заменять одинаковые на одинаковые
- [ ] опционально заменять versionFirst true/false
- [ ] заменять время versionStartTime на новое везде
    - [ ] узнать как получить текущее время
    - [ ] перевести его в нужный формат
- [ ] в конце в строке заменять старые уиды(мы же их ещё храним) на новые (в dataSourceRef - uuid)
- [ ] заменять имена ?
- [ ] специально обрабатывать первую строку
- [x] добавить комментарии пока я помню что тут творится
  - [ ] продолжать добавлять комментарии
-}
{-
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
-}
-- тот ли это атрибут, проверяем по имени и значению
isThatAttr :: NTree H.XNode -> String -> String -> Bool
-- сопоставляем со структурой узла аттрибута и проверяем
isThatAttr (NTree (H.XAttr qname) [NTree (H.XText text) []]) tagName tagText | (QN.qualifiedName qname) == tagName && text == tagText = True
isThatAttr _ _ _ = False

-- заменяем текст в ноде с конкретным аттрибутом
replaceTextIn :: NTree H.XNode -> String -> String -> String -> NTree H.XNode
-- сопоставляем структуру узла
replaceTextIn n@(NTree (H.XTag tagName attrList) childWithText) newText attrName attrVal = 
-- если там есть хоть один такой аттрибут
    if (or (fmap (\x-> isThatAttr x attrName attrVal) attrList)) then 
    -- то заменяем текст в дочерних узлах
        (NTree (H.XTag tagName attrList) (replaceText childWithText newText))
        else (NTree (H.XTag tagName attrList) (fmap (\x-> replaceTextIn x newText attrName attrVal) childWithText)) 
replaceTextIn n _ _ _ = n

-- замена значений текстовых узлов 
replaceText :: H.XmlTrees -> String -> H.XmlTrees
-- сопоставляем и конструируем туже структуру но с новым значением
replaceText ((NTree (H.XText _) [])  : other) newText = ((NTree (H.XText newText) [])  : other)
replaceText n _ = n

-- заменяем текст в дочерних узлах с конкретным именем, в ноде с конкретным аттрибутом
replaceTextInChild :: NTree H.XNode -> String -> String -> String -> String -> NTree H.XNode
replaceTextInChild n@(NTree (H.XTag tagName attrList) childs) newText attrName attrVal inTag = 
-- аналогично, но применяем мап заменой
    if (or (fmap (\x-> isThatAttr x attrName attrVal) attrList)) then 
        (NTree (H.XTag tagName attrList) (fmap (\x-> replaceTextChild x newText inTag) childs ))
        else (NTree (H.XTag tagName attrList) (fmap (\x-> replaceTextInChild x newText attrName attrVal inTag ) childs)) 
replaceTextInChild n _ _ _ _ = n

-- замена текста в одном дочернем узле с определённым именем
replaceTextChild :: H.XmlTree -> String -> String -> H.XmlTree
replaceTextChild n@(NTree (H.XTag tagName a) childWithText) newText inTag | (QN.qualifiedName tagName) == inTag = 
    (NTree (H.XTag tagName a) (replaceText childWithText newText))
replaceTextChild n _ _ = n

-- применяет замену по всему дереву
replaceTextInChilds :: [NTree H.XNode] -> String -> String -> String -> String -> [NTree H.XNode]
replaceTextInChilds nodes t a v n = fmap (\x-> replaceTextInChild x t a v n) nodes

-- тип для списка уидов, найденных и на что заменённых
type OldUUIDs = [(UUID,UUID)]
-- список уидов и индекс последнего использованного
type NewUUIDs = ([UUID], Int)
-- функции замены для UUID
--type TextNodeChgFun = String -> ReplaceState -> (String, ReplaceState)
type UUIDState = State UUIDchgState UUIDchgState
type TextNodeChgFun = UUIDState
--type ReplaceState = (NewUUIDs, OldUUIDs)
--type XmlTreeState = (H.XmlTrees, ReplaceState)
type UUIDchgState = (H.XmlTrees, NewUUIDs, OldUUIDs, NTree H.XNode)
four (_,_,_,x)=x

f :: TextNodeChgFun
f = get >>= \all@(a,nu,ou, node) -> case node of
        ((NTree (H.XText t) [])  : o) -> return (a,nu,ou,((NTree (H.XText t) [])  : o))
        _ -> all

replaceUUIDInChild :: TextNodeChgFun -> String -> String -> String -> UUIDState
replaceUUIDInChild newUuidFun attrName attrVal inTag = 
    get >>= \allstate@(xt, nu, ou, node)-> case node of
        n@(NTree (H.XTag tagName attrList) childs)) -> 
            if (or (fmap (\x-> isThatAttr x attrName attrVal) attrList)) then 
                (NTree (H.XTag tagName attrList) (sequence (modify (\x-> replaceUUIDChild newUuidFun inTag ) childs )) 
            else (NTree (H.XTag tagName attrList) (sequence (replaceUUIDInChild newUuidFun attrName attrVal inTag rs) childs)) 
        otherwise -> allstate
   


replaceUUIDChild :: TextNodeChgFun -> String  -> UUIDState
replaceUUIDChild f inTag =
    get >>= \all@(a,b,c, node) -> case node of
        n@(NTree (H.XTag tagName a) childWithText)
            | (QN.qualifiedName tagName) == inTag ->
                replaceUUID f
                    ( (NTree (H.XTag tagName a) xtree) , state)
        _ -> all

replaceUUID :: TextNodeChgFun -> UUIDState
replaceUUID f = 
    get >>= \all@(_,_,_, node) -> case node of
        ((NTree (H.XText _) [])  : _) -> f all
        _ -> all

replaceUUIDInChilds :: [NTree H.XNode] -> TextNodeChgFun -> String -> String -> String  -> UUIDState -> [NTree H.XNode]
replaceUUIDInChilds nodes t a v n rs = fmap (replaceUUIDInChild t a v n rs) nodes
-- ---
countUUIDs :: String -> Int
countUUIDs input = count (pack "uuid") (pack input)

genEnoghUUIDs :: String -> IO [UUID]
genEnoghUUIDs xml = mapM (\_->nextRandom) [1..(countUUIDs xml)]

{- стандартная фун замены uuid. должна: 
    - [ ] поискать в сохранённых уидах текущий. если есть взять тот на который его надо заменить.
    - [ ] иначе взять следующий уид. изменить состояние
    - [ ] выдать полученный uuid и новое состояние.
-}
--uuidChgFun :: TextNodeChgFun
--uuidChgFun t (u,s) = 

{-
getAttr :: H.XmlTree -> Maybe H.XmlTrees
getAttr = XN.getAttrl . Tree.getNode 

getAttrf :: H.XmlTree -> H.XmlTrees
getAttrf = fromMaybe . XN.getAttrl . Tree.getNode 

fromMaybe :: (Monoid a) => Maybe a -> a
fromMaybe a = maybe mempty id a

replaceInTree :: H.XmlTrees -> String -> String -> String -> H.XmlTrees
replaceInTree tree text attrName attrVal = fmap (\x-> replaceTextIn x text attrName attrVal ) tree
-}
{-NTree (XTag "tot" 
                [NTree (XAttr "target") 
                       [NTree (XText "s") []]])
      [NTree (XText "source") []] -}
--то есть надо у тэга проверить атрибут и если он подходит то найти текст и если он есть заменить его
-- всякие тесты
testXML = P.xread "<a><A y='uuid'>tx</A></a><b z='Z'>ss</b><c x='X' xx='_'><e:e><f:f t:t='t'><v>val</v><v:v>val2</v:v></f:f></e:e></c>"
b = F.formatXmlTree $ head testXML
c = putStrLn b

d = fmap F.formatXmlTree testXML
e = mapM putStrLn d
showx x = mapM putStrLn (fmap F.formatXmlTree x)

f = head testXML
g (H.XText x) = H.XText $ "new" ++ x
g x = x 
h = fmap g f
i = showx [h]
-- ============
ftest = fmap (\x-> replaceTextIn x "" "" "" ) testXML
ftesta a b c = fmap (\x-> replaceTextIn x a b c ) testXML
ptest a b c = showx (ftesta a b c)

rtest a b c d = fmap (\x-> replaceTextInChild x a b c d) 
rr a b c d e = showx (rtest a b c d e)

--testUUIDreplace = replaceUUIDInChilds testXML (\_->nextRandom) "" "" ""

mtest = do 
    con <- readFile "/home/ksi/dev/testweb/1.xml"
    let res = replaceTextInChilds (P.xread con) "NEWTEXT" "sv:name" "jcr:uuid" "sv:value"
    let res' = replaceTextInChilds res "NEWVERSION" "sv:name" "fm:versionName" "sv:value"
    
    writeFile "/home/ksi/dev/testweb/out.xml" (SX.xshow res')
    print "ok"

main = do 
    
    print "end."
