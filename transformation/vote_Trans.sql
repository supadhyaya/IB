
use socialvoyce;

create table if not exists vote (
votingID integer not null primary key,
createDate datetime,
description varchar(500),
questionText varchar(1000),
instanceID char(24),
instanceDB varchar(20),
starsRankingValue float,
totalStars float,
totalVotes float,
votingType varchar(25),
votingHash varchar(35),
jobDate datetime
);

UPDATE vote  INNER JOIN (
select b.id as votingID,a.totalVotes from scrubMetric a
inner join listVoting b on a.votingID=b.votingID
)a ON vote.votingID = a.votingID
set vote.totalVotes=a.totalVotes;

insert into vote (
votingID,
createDate,
description,
questionText,
instanceID,
instanceDB,
starsRankingValue,
totalStars,
totalVotes,
votingType,
votingHash,
jobDate
)
select 
b.id as votingID,
from_unixtime(a.createDate/1000) as createDate,
a.description,
a.questionText,
a.instanceID,
a.instanceDB,
a.starsRankingValue,
a.totalStars,
a.totalVotes,
a.votingType,
a.votingHash,
sysdate() as jobDate

from 
	scrubMetric a
left join 
	listVoting b
on a.votingID=b.votingID

left join 
    vote v
on v.votingID = b.id 
WHERE v.votingID is null;


drop table if exists url_table;

create table url_table (id int, questionText varchar(1000),votingHash varchar(75),instanceName varchar(50),fullurl varchar(1000),shortUrl varchar(1000));

insert into url_table (id,questionText,votingHash,instanceName,fullurl,shortUrl)
select 
votingID as id,questionText,votingHash,case instanceID when '50aa4fdf2ca17ba6c2099391' then 'sixx-community' 
when '51c806a4be66578a57180ecf' then 'fitforfun-community'
when '51d295a9a0153b5c639e2c4a' then 'mmi-community' else 'connect-community' end as instanceName,
'' as fullurl ,
'' as shortUrl
from vote 
where date(jobDate)=date(sysdate())
-- date(createDate)>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
-- Use the above statement for 1 month analysis of the likes and shares
;
