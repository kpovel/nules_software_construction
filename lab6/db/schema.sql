create table user (
    id         integer primary key autoincrement,
    first_name text not null,
    last_name  text not null,
    email      text not null unique,
    password   text not null,
    age        int  not null
);

create table policy (
    id         integer primary key autoincrement,
    type       text not null unique,
    base_price int  not null
);

create table ordered_policy (
    id         integer primary key autoincrement,
    user_id    integer not null,
    policy_id  integer not null,
    expired_at date    not null,

    foreign key (user_id) references user (id),
    foreign key (policy_id) references policy (id)
);

insert into ordered_policy (user_id, policy_id, expired_at)
values (1, 1, '2024-09-30');

insert into policy (type, base_price)
values ('Auto', 1000);
insert into policy (type, base_price)
values ('Property', 1500);
insert into policy (type, base_price)
values ('Travel', 1500);
insert into policy (type, base_price)
values ('Health', 1200);
insert into policy (type, base_price)
values ('Business', 3000);


select id, type, base_price
from policy;
