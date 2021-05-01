create table planDetail
(
    id            int auto_increment,
    uid           int   null,
    pid           int   null,
    time          int   null,
    weight        float null,
    caloriesL     float not null,
    caloriesH     float not null,
    proteinL      float not null,
    proteinH      float not null,
    activityLevel float not null,
    ext           int   null comment 'extension',
    constraint id
        unique (id),
    constraint plandetail_ibfk_1
        foreign key (uid) references user (id),
    constraint plandetail_ibfk_2
        foreign key (pid) references plan (id)
);

create index pid
    on planDetail (pid);

create index uid
    on planDetail (uid);

alter table planDetail
    add primary key (id);

