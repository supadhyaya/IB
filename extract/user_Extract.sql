

use socialvoyce;

drop table if exists initialUser;

create table initialUser (strng LONGTEXT);

LOAD  DATA  infile '/opt/database-migration/sourcefiles/votingUser.txt' 
INTO TABLE initialUser  LINES TERMINATED BY '\n';

drop table if exists scrubUser;

create table scrubUser as
select distinct 
ltrim(rtrim(replace(replace(substring(strng,instr(strng,'_id'),instr(strng,'"questionText" :')-instr(strng,'_id')),'_id" : { "$oid" : "',''),'" },',''))) as votingID,
ltrim(rtrim(replace(replace(substring(strng,instr(strng,'"user" :'),instr(strng,'"$db"')-instr(strng,'"user" :')),'"user" : { "$ref" : "user", "$id" : { "$oid" : "',''),'" },',''))) as userID
from initialUser;





