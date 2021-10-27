create table category
(
    id     int auto_increment,
    name   varchar(256) not null,
    cnName varchar(256) null,
    `desc` text         null,
    cnDesc text         null,
    constraint id
        unique (id)
);

alter table category
    add primary key (id);

INSERT INTO rnd.category (id, name, cnName, `desc`, cnDesc) VALUES (1, 'Dishes', '菜', null, null);
INSERT INTO rnd.category (id, name, cnName, `desc`, cnDesc) VALUES (2, 'Dessert', '点心', null, null);
INSERT INTO rnd.category (id, name, cnName, `desc`, cnDesc) VALUES (3, 'Proteins', '肉蛋奶', null, null);
INSERT INTO rnd.category (id, name, cnName, `desc`, cnDesc) VALUES (4, 'Fruits and vegetables', '果蔬', null, null);
INSERT INTO rnd.category (id, name, cnName, `desc`, cnDesc) VALUES (5, 'Soup', '汤', null, null);
INSERT INTO rnd.category (id, name, cnName, `desc`, cnDesc) VALUES (6, 'Drinks', '饮料', null, null);
INSERT INTO rnd.category (id, name, cnName, `desc`, cnDesc) VALUES (7, 'Staple Food', '主食', null, null);