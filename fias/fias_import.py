#!./env/bin/python
from dbfread import DBF
from collections import OrderedDict
from typing import List, Dict, Union, Tuple, Any


insert = """
begin transaction; 
insert into fias_addrobj 
(actstatus, aoguid, aoid, aolevel, areacode, autocode, cadnum, centstatus, citycode, code, ctarcode, currstatus, divtype, enddate, extrcode, formalname, ifnsfl, ifnsul, livestatus, nextid, normdoc, offname, okato, oktmo, operstatus, parentguid, placecode, plaincode, plancode, postalcode, previd, regioncode, sextcode, shortname, startdate, streetcode, terrifnsfl, terrifnsul, updatedate) 
values ('{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}','{}', '{}'); 
commit;"""
fields = [
    "ACTSTATUS",
    "AOGUID",
    "AOID",
    "AOLEVEL",
    "AREACODE",
    "AUTOCODE",
    "CADNUM",
    "CENTSTATUS",
    "CITYCODE",
    "CODE",
    "CTARCODE",
    "CURRSTATUS",
    "DIVTYPE",
    "ENDDATE",
    "EXTRCODE",
    "FORMALNAME",
    "IFNSFL",
    "IFNSUL",
    "LIVESTATUS",
    "NEXTID",
    "NORMDOC",
    "OFFNAME",
    "OKATO",
    "OKTMO",
    "OPERSTATUS",
    "PARENTGUID",
    "PLACECODE",
    "PLAINCODE",
    "PLANCODE",
    "POSTALCODE",
    "PREVID",
    "REGIONCODE",
    "SEXTCODE",
    "SHORTNAME",
    "STARTDATE",
    "STREETCODE",
    "TERRIFNSFL",
    "TERRIFNSUL",
    "UPDATEDATE",
    ]

def get_values(record: OrderedDict, fields: List[str]) -> List[Any]:
    values = []
    for name in fields:
        values.append(record[name])
    return values

n = 1
db = '/mnt/data/fias/ADDROB{0:02}.DBF'.format(n)

def import_db(db):
    try:
        for record in DBF(db):
            values = get_values(record, fields)
            print(insert.format(*values))
    except:
        pass

for n in range(1, 100):
    db = '/mnt/data/fias/ADDROB{0:02}.DBF'.format(n)
    import_db(db)

