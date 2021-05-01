create table dailyConsumption
(
    id       int auto_increment,
    uid      int          not null,
    pid      int          not null,
    fid      int          not null,
    type     int          not null comment '1=breakfast, 2=lunch, 3=dinner',
    day      int          not null comment 'relative days since the plan began',
    time     int          null,
    name     varchar(256) null comment 'easier way to query food name...',
    calories float        null comment 'easier way to query calories',
    protein  float        null comment 'easier way to query protein',
    weight   float        null comment '100g per',
    img      longtext     null,
    constraint id
        unique (id),
    constraint dailyconsumption_ibfk_1
        foreign key (uid) references user (id),
    constraint dailyconsumption_ibfk_2
        foreign key (pid) references plan (id),
    constraint dailyconsumption_ibfk_3
        foreign key (fid) references food (id)
);

create index fid
    on dailyConsumption (fid);

create index pid
    on dailyConsumption (pid);

create index uid
    on dailyConsumption (uid);

alter table dailyConsumption
    add primary key (id);

