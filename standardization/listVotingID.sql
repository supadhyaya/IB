

use socialvoyce;

create table if not exists listVoting (
votingID char(24) not null,
id INTEGER AUTO_INCREMENT PRIMARY KEY );


insert into listVoting(votingID)
select distinct a.votingID from scrubMetric a
left join listVoting b
on a.votingID=b.votingID
where b.id is  null;



create table if not exists listTag (
tagID char(24) not null,
id INTEGER AUTO_INCREMENT PRIMARY KEY )
;


insert into listTag(tagID)
select distinct a.tagID from scrubVotingTag a
left join listTag b 
on a.tagID=b.tagID
where b.id is null;


insert into listTag(tagID)
select distinct a.tagID from scrubTag a
left join listTag b 
on a.tagID=b.tagID
where b.id is null;


create table if not exists listUser (
userID char(24) not null,
id INTEGER AUTO_INCREMENT PRIMARY KEY )
;


insert into listUser(userID)
select distinct a.userID from scrubComment a
left join listUser b 
on a.userID=b.userID
where b.id is null;


insert into listUser(userID)
select distinct a.userID from scrubUser a
left join listUser b 
on a.userID=b.userID
where b.id is null;










