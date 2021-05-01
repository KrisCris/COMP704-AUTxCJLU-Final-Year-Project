create table user
(
    id             int auto_increment,
    email          varchar(255)                                          not null,
    nickname       varchar(20)                                           null,
    password       varchar(255)                                          null,
    `group`        int                                                   null comment 'user group, 0=unactivated, 1=normal user',
    token          varchar(40)  default ''                               null comment 'unique string that auth auto login',
    avatar         varchar(255) default 'static/user/avatar/default.png' null,
    gender         int                                                   null comment 'male=1, female=2, others=0',
    age            int                                                   null,
    weight         float                                                 null,
    height         float                                                 null,
    auth_code      varchar(20)                                           null comment 'verification code',
    last_code_sent int                                                   not null comment 'timestamp the last time server sent a auth_code',
    code_check     int                                                   null,
    guide          tinyint(1)                                            null,
    register_date  int                                                   null,
    b_percent      int                                                   null,
    l_percent      int                                                   null,
    d_percent      int                                                   null,
    constraint email
        unique (email),
    constraint id
        unique (id)
);

alter table user
    add primary key (id);

