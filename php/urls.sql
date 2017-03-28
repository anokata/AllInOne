drop sequence seq1 CASCADE;
drop table urls CASCADE;
drop table categories CASCADE;

CREATE SEQUENCE seq1;

CREATE TABLE categories (
    id INTEGER PRIMARY KEY DEFAULT NEXTVAL('seq1'), 
    name CHAR(32)
);

CREATE TABLE urls (
    id INTEGER PRIMARY KEY DEFAULT NEXTVAL('seq1'), 
    name CHAR(32),
    url CHAR(256),
    cat_id INTEGER,
    FOREIGN KEY (cat_id) REFERENCES categories(id)
);

-- test data

insert into urls (name, url) values 
('ur', 'ur.com'), 
('wjur', 'www.ur.com'), 
('hurc', 'http://ur.com');

insert into categories (name) values 
('default'), 
('IT');

-- select * from urls;
