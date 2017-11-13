drop table if exists fias_house cascade;
create table fias_house (
    postalcode varchar(6),
    ifnsfl varchar(4),
    terrifnsfl varchar(4),
    ifnsul varchar(4),
    terrifnsul varchar(4),
    okato varchar(11),
    oktmo varchar(11),
    updatedate timestamp,
    housenum varchar(20),
    eststatus integer,
    buildnum varchar(10),
    strucnum varchar(10),
    strstatus integer,
    houseid varchar(36),
    houseguid varchar(36),
    aoguid varchar(36),
    startdate timestamp,
    enddate timestamp,
    statstatus integer,
    normdoc varchar(36),
    counter integer,
    cadnum varchar(100),
    divtype integer,

    primary key (houseid)
)
