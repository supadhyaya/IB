
use socialvoyce;

-- drop table if exists votingTag;

create table if not exists votingTag (
votes varchar(100),
tags varchar(100),
votingID integer not null,
tagID integer not null,
jobDate datetime
);


insert into votingTag (
votes,
tags,
votingID,
tagID,
jobDate 
)


select distinct
a.votingID as votes,
a.tagID as tags,
c.id as votingID,
d.id as tagID,
sysdate()

from 
	scrubVotingTag a
left join 
	 listTag d on
	 d.tagID=a.tagID 
left join
	listVoting c on
	c.votingID=a.votingID
left join votingTag vt
on
    vt.tags=a.tagID
and
    vt.votes=a.votingID
where vt.tags is null and vt.votes is null;


-- drop table if exists tag;

create table if not exists tag (
tags varchar(100),
tagID integer not null primary key,
createDate datetime,
blacklisted char(5),
moderated char(5),
valueParts varchar (500),
value varchar(500),
normalizedValue varchar(500),
jobDate datetime
);


insert into tag (
tags,
tagID ,
createDate ,
blacklisted ,
moderated ,
valueParts,
value ,
normalizedValue ,
jobDate 
)


select 
distinct
a.tagID as tags,
c.id as tagID,
a.createDate,
a.blacklisted,
a.moderated,
a.valueParts,
a.value,
a.normalizedValue,
sysdate()

from 
	scrubTag a

left join
	 listTag c on
	 c.tagID=a.tagID 

left join
    tag d
on
    d.tags=a.tagID

where d.tags is null
;

