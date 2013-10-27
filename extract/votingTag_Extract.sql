

use socialvoyce;

drop table if exists initialVotingTag;

create table initialVotingTag(tag LONGTEXT);


LOAD  DATA  infile '/opt/database-migration/sourcefiles/votingtag.txt' 
INTO TABLE initialVotingTag  LINES TERMINATED BY '\n';


drop table if exists votingTagPass1;

create table votingTagPass1 as
select distinct substring(tag,21,instr(tag,'tags" :')-26) as votingID,
substring(tag,instr(tag,'tags" :'),char_length(tag)) as tag
from initialVotingTag ;

call explode_tag('$oid');


drop table if exists scrubVotingTag;

create table scrubVotingTag as

select distinct ltrim(rtrim(replace(votingID,'"',''))) as votingID ,
ltrim(rtrim(replace(replace(substring(tag,instr(tag,'$oid" :'),33),'" } "$db" : "socialvoyce" } { "$ref" : "tag" "$id" : { "',''),'$oid" : "','')))as tagID
from splitTag;

delete from scrubVotingTag where tagID='';
