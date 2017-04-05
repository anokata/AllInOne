-- select * from category;
SELECT * FROM category WHERE parent_category_id IS NULL and name like 'auto%';
SELECT * FROM category AS root_cat WHERE (select count(id) FROM category WHERE parent_category_id = root_cat.id) <= 3;
SELECT * FROM category AS root_cat WHERE (select count(id) FROM category WHERE parent_category_id = root_cat.id) = 0;

EXPLAIN select * from category;
EXPLAIN select * from category where parent_category_id is null and name like 'auto%';

