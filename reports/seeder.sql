
use socialvoyce;

drop table if exists seeder;

create table seeder (userID int,nickName varchar(100));


insert into seeder (userID,nickName) 
select distinct u.userID , sd.nickName from user u 
inner join vote v on
u.votingID=v.votingID
left join seeder s2
on s2.userID=u.userID
inner join initialSeeder sd 
on sd.questionText=v.questionText
where s2.userID is null;