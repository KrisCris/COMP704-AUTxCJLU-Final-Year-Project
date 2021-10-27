create table plan
(
    id             int auto_increment,
    uid            int        not null,
    begin          int        not null,
    end            int        not null,
    type           int        not null,
    goalWeight     float      null,
    achievedWeight float      null,
    realEnd        int        null,
    completed      tinyint(1) not null,
    constraint id
        unique (id),
    constraint plan_ibfk_1
        foreign key (uid) references user (id)
);

create index uid
    on plan (uid);

alter table plan
    add primary key (id);

