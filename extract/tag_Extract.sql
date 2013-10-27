

use socialvoyce;

drop table if exists initialTag; 

create table initialTag (tag lONGTEXT) ;
LOAD  DATA infile '/opt/database-migration/sourcefiles/tag.txt' 
INTO TABLE initialTag  LINES TERMINATED BY '\n';


drop table if exists tagPass1;

# Simple logic to break down the columns
create table tagPass1 as
select substring(tag,1,INSTR(tag,'},')) as tagID,
substring(tag,INSTR(tag,'createDate'),41) as createDate,
substring(tag,INSTR(tag,'blacklisted'),20) as blacklisted ,
substring(tag,INSTR(tag,'moderated'),20) as moderated,  
substring(tag,INSTR(tag,'['),instr(tag,']')-instr(tag,'[')) as valueParts,    
replace(substring(tag,INSTR(tag,'['),instr(tag,']')-instr(tag,'[')),'", "',' ') as value,
lower(substring(tag,INSTR(tag,'['),instr(tag,']')-instr(tag,'['))) as normalizedValue,
substring(tag,INSTR(tag,'instance'),200) as instance
from initialTag;


drop table if exists scrubTag;

create table scrubTag as select distinct
ltrim(rtrim(replace(replace(tagID,'{ "_id" : { "$oid" : "',''),'" }',''))) as tagID ,
FROM_UNIXTIME(ltrim(rtrim(replace(replace(createDate,'createDate" : { "$date" :',''),'}','')))/1000) as createDate,
ltrim(rtrim(replace(replace(blacklisted,'blacklisted" :',''),'',''))) as blacklisted,
ltrim(rtrim(replace(replace(moderated,'moderated" :',''),',',''))) as moderated,
ltrim(rtrim(replace(replace(valueParts,'[ "',''),'"',''))) as valueParts,
ltrim(rtrim(replace(replace(value,'[ "',''),'"',''))) as value,
ltrim(rtrim(replace(replace(replace(normalizedValue,'[ "',''),'"',''),',',''))) as normalizedValue,
ltrim(rtrim(replace(replace(replace(substring(instance,
INSTR(instance,'$oid'),INSTR(instance,'$db')-INSTR(instance,'$oid')),'$oid',''),'" : "',''),'" }, "',''))) as instanceID,
ltrim(rtrim(replace(replace(substring(instance,INSTR(instance,'$db'),200),'$db" : "',''),'" } }',''))) as instanceDB,
sysdate() as jobDate
from tagPass1;
