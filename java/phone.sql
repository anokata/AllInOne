CREATE TABLE IF NOT EXISTS people (
  id SERIAL PRIMARY KEY,
  name varchar(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS phones (
  id SERIAL PRIMARY KEY, 
  phone varchar(15) NOT NULL,
  people_id integer NOT NULL,
  FOREIGN KEY (people_id) REFERENCES people(id)
) ;

delete from phones;
delete from people;
INSERT INTO people (id, name) VALUES
(123, 'John'),
(124, 'Smith');

INSERT INTO phones (id, phone, people_id) VALUES
(1, '+8123330000', 123),
(2, '+8127778891', 123),
(3, '+7100008891', 124),
(4, '+7127000091', 124),
(5, '77', 124);


select * from people;
select * from phones;
--select name, phone from people inner join phones where people.id = phones.people_id;
