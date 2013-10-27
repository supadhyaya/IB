

use socialvoyce;
-- delimiter $$
-- CREATE DATABASE `socialvoyce` /*!40100 DEFAULT CHARACTER SET utf8mb4 */$$


drop table if exists initialMetric;

create table initialMetric (strng LONGTEXT);

LOAD  DATA  infile '/opt/database-migration/sourcefiles/metrics.txt' 
INTO TABLE initialMetric  LINES TERMINATED BY '\n';

drop table if exists metricPass1;

create table metricPass1 as
select substring(strng,20,28) as votingID,
substring(strng,instr(strng,'createDate" :'),41)as createDate,
substring(strng,instr(strng,'"description" :'),
instr(strng,'"instance" :')-instr(strng,'"description" :')) as description,
substring(strng,instr(strng,'"questionText" :'),
instr(strng,'"starsRankingValue" :')-instr(strng,'"questionText" :')) as questionText,
substring(strng,instr(strng,'"instance",'),60) as instanceID,
substring(strng,instr(strng,'"$db" :'),25) as instanceDB,
substring(strng,instr(strng,'"starsRankingValue" :'),
instr(strng,'"totalStars" :')-instr(strng,'"starsRankingValue" :')) as starsRankingValue,
substring(strng,instr(strng,'"totalStars" :'),
instr(strng,'"totalVotes" :')-instr(strng,'"totalStars" :')) as totalStars,
substring(strng,instr(strng,'"totalVotes" :'),
instr(strng,'"user" :')-instr(strng,'"totalVotes" :')) as totalVotes,
substring(strng,instr(strng,'votingType'),30) as votingType,
substring(strng,instr(strng,'votingHash'),50) as votingHash
from initialMetric;

drop table if exists scrubMetric;
create table scrubMetric as
select distinct ltrim(rtrim(replace(replace(votingID,': "',''),'"',''))) as votingID,
ltrim(rtrim(replace(replace(createDate,'createDate" : { "$date" : ',''),'}',''))) as createDate,
ltrim(rtrim(replace(replace(description,'"description" : "',''),'",',''))) as description,
ltrim(rtrim(replace(replace(questionText,'"questionText" : "',''),'",',''))) as questionText,
ltrim(rtrim(replace(replace(instanceID,'"instance", "$id" : { "$oid" : "',''),'" },',''))) as instanceID,
ltrim(rtrim(replace(replace(instanceDB,'"$db" : "',''),'" },',''))) as instanceDB,
ltrim(rtrim(replace(replace(starsRankingValue,'"starsRankingValue" :',''),',',''))) as starsRankingValue,
ltrim(rtrim(replace(replace(totalStars,'"totalStars" :',''),',',''))) as totalStars,
ltrim(rtrim(replace(replace(totalVotes,'"totalVotes" :',''),',',''))) as totalVotes,
ltrim(rtrim(replace(replace(votingType,'votingType" : "',''),'" }',''))) as votingType,
ltrim(rtrim(replace(replace(votingHash,'votingHash" : "',''),'",',''))) as votingHash
from metricPass1;





