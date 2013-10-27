


use socialvoyce;

drop table if exists tempReferrals;

create table tempReferrals
(
pagepath varchar(550),
fullReferrer varchar(550),
deviceCategory varchar(550),
visits varchar(100)
);

drop table if exists tempVisits;

create table tempVisits
(
pagepath varchar(1000),
visits varchar(100),
visitors varchar(100),
newVisits varchar(100),
pageViews varchar(100),
avgTimeOnPage varchar(100),
visitBounceRate varchar(100)
);

create table if not exists referral (
votingID int,
pagePath varchar(1000),
fullReferrer varchar(1000),
deviceCategory varchar(200),
visits int,
jobDate datetime
);

insert into referral
(
votingID,
pagePath,
fullReferrer,
deviceCategory,
visits,
jobDate
)

select
b.id,
ltrim(rtrim(replace(replace(a.pagePath,'{"pagepath":"',''),'"',''))) as pagePath,
ltrim(rtrim(replace(replace(a.fullReferrer,'"fullReferrer":"',''),'"',''))) as fullReferrer,
ltrim(rtrim(replace(replace(a.deviceCategory,'"deviceCategory":"',''),'"',''))) as deviceCategory,
ltrim(rtrim(replace(replace(a.visits,'"visits":',''),'}',''))) as visits,
sysdate()
from tempReferrals a
left join url_table b
on a.pagePath=b.fullurl
left join referral c
on c.pagePath=a.pagePath
where c.pagePath is null;




create table if not exists visit (
votingID int,
pagePath varchar(1000),
visits int,
visitors int,
newVisits int,
pageViews int,
avgTimeOnPage float,
visitBounceRate float,
jobDate datetime
);

insert into visit
(
votingID,
pagePath,
visits,
visitors,
newVisits,
pageViews,
avgTimeOnPage,
visitBounceRate,
jobDate
)

select
b.id,
ltrim(rtrim(replace(replace(a.pagePath,'{"pagepath":"',''),'"',''))) as pagePath,
ltrim(rtrim(replace(replace(a.visits,'"visits":',''),'"',''))) as visits,
ltrim(rtrim(replace(replace(a.visitors,'"visitors":',''),'"',''))) as visitors,
ltrim(rtrim(replace(replace(a.newVisits,'"NewVisits":',''),'"',''))) as NewVisits,
ltrim(rtrim(replace(replace(a.pageViews,'"Pageviews":',''),'}',''))) as Pageviews,
ltrim(rtrim(replace(replace(a.avgTimeOnPage,'"avgTimeOnPage":',''),'}',''))) as avgTimeOnPage,
ltrim(rtrim(replace(replace(a.visitBounceRate,'"visitBounceRate":',''),'}',''))) as visitBounceRate,
sysdate()
from tempVisits a
left join url_table b
on a.pagePath=b.fullurl
left join visit c
on c.pagePath=a.pagePath
where c.pagePath is null;






create table  if not exists urlHistory (
	votingID int not null primary key ,
	questionText varchar(2000) not null ,
	votingHash varchar(75) not null ,
	instanceName varchar(50) not null ,
	fullurl text not null
	 );


insert into urlHistory	(
votingID,
questionText,
votingHash,
instanceName,
fullurl
)
select 
a.id as votingID,
a.questionText as questionText,
a.votingHash as votingHash,
a.instanceName as instanceName,
ltrim(rtrim(a.fullurl)) as fullurl
from url_table a
left join 
urlHistory  b
on 
b.votingID=a.id
where b.votingID is null;