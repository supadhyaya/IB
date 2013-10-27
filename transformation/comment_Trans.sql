use socialvoyce;



create table if not exists comment (
votingID integer not null,
commentID char(24),
createDate datetime,
message varchar(500),
userID integer not null,
jobDate datetime
);


insert into comment (
votingID,
commentID,
createDate,
message,
userID,
jobDate
)
select
b.id as votingID,
a.commentID as commentID,
from_unixtime(a.createDate/1000) as createDate,
a.message as message,
c.id as userID,
sysdate() as jobDate

from 
	scrubComment a
left join 
	listVoting b
on 
	a.votingID=b.votingID
left join
	listUser c
on 
	a.userID=c.userID

left join 
    comment f
on 
    f.commentID=a.commentID
where 
    f.commentID is null
	;



