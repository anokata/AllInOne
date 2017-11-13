#!./env/bin/python
from dbfread import DBF
from collections import OrderedDict
from typing import List, Dict, Union, Tuple, Any

n = 1
db_path = '/mnt/data/fias/house/HOUSE'

def db_name(n):
    return "{}{:02}.DBF".format(db_path, n)


insert = """
begin transaction; 
insert into fias_house
(aoguid, buildnum, cadnum, counter, divtype, enddate, eststatus, houseguid, houseid, housenum, ifnsfl, ifnsul, normdoc, okato, oktmo, postalcode, startdate, statstatus, strstatus, strucnum, terrifnsfl, terrifnsul, updatedate) 
values ('{}'); 
commit;"""

def get_fields(db: str) -> List[str]:
    fields = list()
    record = DBF(db).__iter__().__next__()
    for name in record.keys():
        fields.append(name)
    return sorted(fields)


def make_insert_template(db):
    fields = [f.lower() for f in get_fields(db)]
    places = ["'{}'" for f in get_fields(db)]
    
    insert = "begin transaction; "
    insert += "\ninsert into fias_house ("
    insert += ', '.join(fields)
    insert += ")"
    insert += " values ("
    insert += ', '.join(places)
    insert += "); "
    insert += "\ncommit;"
    return insert


def get_values(record: OrderedDict, fields: List[str]) -> List[Any]:
    values = []
    for name in sorted(fields):
        values.append(record[name])
    return values

def import_db(db):
    insert = make_insert_template(db)
    fields = get_fields(db)
    try:
        for record in DBF(db):
            values = get_values(record, fields)
            print(insert.format(*values))
    except:
        pass

print(get_fields(db_name(1)))

#import_db(db_name(1))

for n in range(1, 100):
    import_db(db_name(n))

