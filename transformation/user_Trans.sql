

use socialvoyce;

create table if not exists user (
userID int not null ,
votingID int not null,
votes varchar(100), 
user varchar(100)
);


insert into user (
userID,
votingID,
votes,
user
)
select 
distinct 
b.id as userID,
c.id as votingID,
a.votingID as votes,
a.userID as user

from 
	scrubUser a
left join 
	listUser b
on 
	a.userID=b.userID
left join 
    listVoting c
on
	a.votingID=c.votingID
left join 
    user d
on 
    d.user=a.userID
and
    d.votes=a.votingID
where 
	d.votes is null and d.user is null;

