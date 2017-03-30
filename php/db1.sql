drop table category;
CREATE TABLE category (
    id integer not null primary key,
    parent_category_id integer references category(id),
    name varchar(100) not null
);

CREATE UNIQUE INDEX catid ON category(id);
CREATE INDEX catpid ON category(parent_category_id);
CREATE UNIQUE INDEX idx_root_auto ON category(id, name);

insert into category (id, parent_category_id, name) values
(1, NULL, 'Top cat'),
(2, NULL, 'Top dog'),
(3, NULL, 'auto dog'),
(4, NULL, 'auto cat'),
(10, 1, 'cat one'),
(110, 10, 'leaf cat one'),
(11, 1, 'cat 2'),
(12, 1, 'cat 3'),
(13, 1, 'auto cat 4'),
(14, 2, 'dog 1'),
(15, 2, 'dog 2'),
(20, 3, 'dog a'),
(21, 3, 'dog b'),
(22, 3, 'dog c'),
(23, 3, 'dog d');
