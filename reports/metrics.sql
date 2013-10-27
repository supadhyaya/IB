

-- Voting Distribution
drop table if exists voteDist ;

create table voteDist as 
select 
b.instanceName as community ,date(a.createDate) as createDate ,count(a.votingID)  as totalPolls,
count(c.commentID) as totalComments , sum(scl.facebook_likes) as totalLikes from vote a
inner join instance b on
a.instanceID=b.instanceID
left join comment c 
on c.votingID=a.votingID
left join socialLike scl 
on scl.votingID=a.votingID
where date(a.createDate)>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
group by date(a.createDate) ,b.instanceName
order by date(a.createDate);




-- Popular Votes
drop table if exists maxVote;

create table maxVote as
select date(a.createDate)  as createDate ,b.instanceName as community,  max(a.totalVotes) as totalVotes 
from vote a
inner join instance b 
on a.instanceID=b.instanceID
where date(a.createDate)>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
group by  date(a.createDate),b.instanceName ;



drop table if exists popularPoll;

create table popularPoll
as select b.instanceName as community ,concat('Date: ',date(a.createDate),' - ',a.questionText) as questionText, max(a.totalVotes) as totalVotes
,count(c.commentID) as totalComments , scl.facebook_likes as totalLikes from vote a
inner join instance b on 
a.instanceID=b.instanceID
inner join maxVote mv on
date(mv.createDate)=date(a.createDate) and mv.community=b.instanceName and mv.totalVotes=a.totalVotes
inner join socialLike scl 
on scl.votingID=a.votingID
left join comment c on 
c.votingID=a.votingID
group by b.instanceName,date(a.createDate) ,a.questionText
order by a.createDate;


-- For Seeder Report
drop table if exists seederDetail;

create table  seederDetail as 
select date(v.createDate) as createDate,v.votingID,s.nickName,v.questionText,v.totalVotes,i.instanceName 
from seeder s
inner join user u
on
s.userID=u.userID
inner join vote v
on 
v.votingID=u.votingID
inner join instance i on 
i.instanceID=v.instanceID
order by date(v.createDate),nickName desc;


drop table if exists commentCount;
create table commentCount as 
select count(1) as commentCount,c.votingID from comment c 
inner join vote v on 
v.votingID=c.votingID
-- where date(v.createDate)>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
group by c.votingID
order by count(1) desc;


drop table if exists seederInfo;

create table  seederInfo as 
select sd.createDate,sd.votingID,sd.nickName,sd.questionText,sd.totalVotes,sd.instanceName as community ,cc.commentCount,scl.facebook_likes as facebookLikes
from seederDetail sd
left join commentCount cc
on sd.votingID=cc.votingID
left join socialLike scl
on scl.votingID=sd.votingID;



-- calculating the average likes , shares , referrals of the user.

drop table if exists userStat;
create table userStat as
select u.userID ,  sum(scl.facebook_likes)/count(scl.url) as avgLikes  from user u
inner join socialLike scl 
on u.votingID=scl.votingID
group by u.userID
order by count(scl.url) desc


-- for User Report

-- for User Report
drop table if exists userValue1;

create table userValue1 as
select u.userID,concat('User: ',u.userID,' - Date: ',Date(a.createDate),' - ',a.questionText) as user , i.instanceName , a.votingID,a.totalVotes,cc.commentCount,c.tweeter,c.linkedin,c.facebook_likes,c.facebook_shares,c.gplus
from vote a
inner join urlHistory b
on a.votingID=b.votingID
inner join socialLike c
on c.url=b.fullurl
inner join commentCount cc
on cc.votingID=a.votingID
inner join user u 
on u.votingID=a.votingID
inner join instance i
on i.instanceID=a.instanceID
where date(a.createDate)>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

drop table if exists userValue;
create table userValue as 
select uv1.*,us.avgLikes from userValue1 uv1
inner join userStat us 
on us.userID=uv1.userID;



drop table if exists userValueByVotes;
create table userValueByVotes as
select user , instanceName as community , totalVotes,facebook_likes,commentCount,avgLikes from userValue
where instanceName='sixx-community' order by totalVotes desc limit 20;

insert into userValueByVotes 
select user , instanceName  as community , totalVotes,facebook_likes,commentCount,avgLikes from userValue
where instanceName='fitforfun-community' order by totalVotes desc limit 20;

insert into userValueByVotes 
select user , instanceName  as community , totalVotes,facebook_likes,commentCount,avgLikes from userValue
where instanceName='mmi-community' order by totalVotes desc limit 20;

insert into userValueByVotes 
select user , instanceName  as community , totalVotes,facebook_likes,commentCount,avgLikes from userValue
where instanceName='connect-community' order by totalVotes desc limit 20;



drop table if exists userValueByLikes;
create table userValueByLikes as
select user , instanceName  as community , totalVotes,facebook_likes,commentCount,avgLikes from userValue
where instanceName='sixx-community' order by facebook_likes desc limit 20;

insert into userValueByLikes 
select user , instanceName  as community , totalVotes,facebook_likes,commentCount,avgLikes from userValue
where instanceName='fitforfun-community' order by facebook_likes desc limit 20;

insert into userValueByLikes 
select user , instanceName  as community , totalVotes,facebook_likes,commentCount,avgLikes from userValue
where instanceName='mmi-community' order by facebook_likes desc limit 20;

insert into userValueByLikes 
select user , instanceName  as community , totalVotes,facebook_likes,commentCount,avgLikes from userValue
where instanceName='connect-community' order by facebook_likes desc limit 20;



-- For popular Tags from each of the community
drop table  if exists tempPopTag ;

create table tempPopTag as 
select distinct date(createDate) as createDate,votingID,questionText,totalVotes,instanceID from vote 
where instanceID='50aa4fdf2ca17ba6c2099391'
and date(createDate)>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
order by totalVotes desc limit 10;

insert into tempPopTag
select distinct date(createDate) as createDate,votingID,questionText,totalVotes,instanceID from vote 
where instanceID='51c806a4be66578a57180ecf'
and date(createDate)>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
order by totalVotes desc limit 10;

insert into tempPopTag
select distinct date(createDate) as createDate,votingID,questionText,totalVotes,instanceID from vote 
where instanceID='51d295a9a0153b5c639e2c4a'
and date(createDate)>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
order by totalVotes desc limit 10;

insert into tempPopTag
select distinct date(createDate) as createDate,votingID,questionText,totalVotes,instanceID from vote 
where instanceID='52271adbc4813af2888de7cb'
and date(createDate)>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
order by totalVotes desc limit 10;


drop table if exists popularTag;

create table popularTag as 
select
v.votingID,tag.valueParts,v.totalVotes,v.questionText , v.createDate , case v.instanceID  when '50aa4fdf2ca17ba6c2099391' then 'sixx-community' 
when '51c806a4be66578a57180ecf' then 'fitforfun-community' when '51d295a9a0153b5c639e2c4a' then 'mmi-community' when '52271adbc4813af2888de7cb' then  'connect-community' 
else 'unknown community'end as community from tempPopTag v
inner join votingTag vt 
on v.votingID=vt.votingID
inner join tag 
on tag.tagID=vt.tagID
order by totalVotes ;



-- For Tag Reports

update tag set valueParts=replace(valueParts,',','||');

call explode_Tag2('||');

update splitTag1 set valueParts=replace(valueParts,'||',',');

drop table if exists tagReportPass1;
create table tagReportPass1 as 
select v.votingID,t.tagID,t.valueParts,v.totalVotes,uv.facebook_likes , uv.commentCount,i.instanceName as community,
concat(year(v.createDate),'-',month(v.createDate)) as date from votingTag vt
inner join tag t on
t.tagID=vt.tagID
inner join vote v on
v.votingID=vt.votingID
inner join instance i
on i.instanceID=v.instanceID
inner join userValue1 uv 
on uv.votingID=v.votingID;

drop table if exists tagStatMonth;
create table tagStatMonth as 
select community,date,valueParts ,  sum(totalVotes) , sum(commentCount) , sum(facebook_likes) from tagReportPass1
group by community,date,valueParts 
order by date desc;


drop table if exists tagStatHistory;
create table tagStatHistory as 
select community,valueParts ,  sum(totalVotes) , sum(commentCount) , sum(facebook_likes)from tagReportPass1
group by community,valueParts 
order by date desc;