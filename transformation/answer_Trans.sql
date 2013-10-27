
use socialvoyce;

create table if not exists answer (
votingID integer not null ,
answerText varchar(1000),
answerID char(24),
votes int,
jobDate datetime
);

UPDATE answer  INNER JOIN scrubAnswer ON answer.answerID = scrubAnswer.answerID
set answer.votes=scrubAnswer.votes;


insert into answer(
votingID,
answerText,
answerID,
votes,
jobDate
)
select 
b.id as votingID,
a.answerText as answerText,
a.answerID as answerID,
a.votes as votes,
sysdate()
from 
	scrubAnswer a
left join  
	listVoting b
on
	a.votingID=b.votingID
left join 
    answer f
on b.id=f.votingID

where f.votingID is null and f.answerID is null
	;
