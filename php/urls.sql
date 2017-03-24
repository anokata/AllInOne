drop sequence seq1;
drop table urls;

CREATE SEQUENCE seq1;
CREATE TABLE urls (
    id INTEGER PRIMARY KEY DEFAULT NEXTVAL('seq1'), 
    name CHAR(32),
    url CHAR(256) 
);

-- test data

insert into urls (name, url) values 
('ur', 'ur.com'), 
('wjur', 'www.ur.com'), 
('hurc', 'http://ur.com');

-- select * from urls;
