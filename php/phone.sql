
-- drop table if exists people;
CREATE TABLE IF NOT EXISTS people (
  id int(8) NOT NULL AUTO_INCREMENT,
  name varchar(30) NOT NULL,
  PRIMARY KEY (id)
) DEFAULT CHARSET=utf8 ;

CREATE TABLE IF NOT EXISTS phones (
  id int(8) NOT NULL AUTO_INCREMENT,
  phone varchar(15) NOT NULL,
  people_id int(8) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (people_id) REFERENCES people(id)
) DEFAULT CHARSET=utf8 ;

delete from phones;
delete from people;
INSERT INTO people (id, name) VALUES
(123, 'John'),
(124, 'Smith');

INSERT INTO phones (id, phone, people_id) VALUES
(1, '+8123330000', 123),
(2, '+8127778891', 123),
(3, '+7100008891', 124),
(4, '+7127000091', 124);


select * from people;
select * from phones;
select name, phone from people inner join phones where people.id = phones.people_id;
