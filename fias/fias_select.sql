--#!/usr/bin/env psql -U support support
-- create index if not exists fias_addrobj_aoguid on fias_addrobj(aoguid);
-- create index if not exists fias_addrobj_currstatus on fias_addrobj(currstatus);
-- create index if not exists fias_addrobj_parentguid on fias_addrobj(parentguid);
-- select 
-- (select offname from fias_addrobj where aoguid=root.parentguid and currstatus=0 limit 5) as pname,
-- offname, parentguid from fias_addrobj as root where offname like '%Ворош%' and currstatus=0 limit 5;

select formalname, aoguid from fias_addrobj as root where formalname like '%Абельмановская%' and currstatus=0 limit 5;


--(SELECT string_agg(X.fullname, ', ') FROM (
WITH RECURSIVE child_to_parents AS (
    SELECT fias_addrobj.formalname, fias_addrobj.shortname, fias_addrobj.code, fias_addrobj.parentguid 
    FROM fias_addrobj
    WHERE aoguid = 'e533f38f-54d9-44be-91f2-cf23be201766'
        AND fias_addrobj.currstatus = 0 
    UNION ALL
    SELECT fias_addrobj.formalname, fias_addrobj.shortname, fias_addrobj.code, fias_addrobj.parentguid 
    FROM fias_addrobj, child_to_parents
    WHERE fias_addrobj.aoguid = child_to_parents.parentguid
        AND fias_addrobj.currstatus = 0
)
SELECT concat(formalname, ' ', shortname, '.') fullname FROM child_to_parents ORDER BY code
;
-- )X);
-- use formal name
-- к. стр.
-- г Москва, ул Абельмановская, д 10/21 стр 8 
select houseguid, concat('д. ', housenum), buildnum strucnum from fias_house 
    where aoguid = '4afc99aa-1349-47d0-8c5d-24e7a9886dbf'
    limit 5;

-- select aoguid, buildnum, strucnum from fias_house 
    -- where buildnum <> '' and strucnum <> '' ;

