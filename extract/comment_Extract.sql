use socialvoyce;
-- mongoexport --db socialvoyce --collection voting --out comment.txt --fields _id,comments;

-- scp idp@46.16.77.31:/home/idp/comment.txt /home/sanjiv/Desktop/IDP/sourcefiles/

drop table if exists initialComment;

create table initialComment (comment LONGTEXT);

LOAD  DATA  infile '/opt/database-migration/sourcefiles/comment.txt' 
INTO TABLE initialComment  LINES TERMINATED BY '\n';


drop table if exists commentPass1;

create table commentPass1 as
select substring(comment,1,INSTR(comment,'}')) as votingID,
substring(comment,instr(comment,'}'),char_length(comment)) as comment from initialComment;

call explode_comment('"_id"');


drop table if exists commentPass2;
create table commentPass2
as select votingID,
substring(comment,instr(comment,': "'),30) as commentID ,
substring(comment,instr(comment,'createDate'),41) as createDate,
substring(comment,instr(comment,'"message" :'),instr(comment,'"path" :')-instr(comment,'"message" :')) as message,
substring(comment,instr(comment,'"$oid" :'),38) as userID,
substring(comment,instr(comment,'"$db" :'),25) as instanceDB
from splitComment;

drop table if exists scrubComment;

create table scrubComment as
select distinct
ltrim(rtrim(replace(replace(votingID,'{ "_id" : { "$oid" : "',''),'" }','')))  as votingID,
ltrim(rtrim(replace(replace(commentID,': "',''),'"',''))) as commentID,
ltrim(rtrim(replace(replace(createDate,'createDate" : { "$date" :',''),'}',''))) as createDate,
ltrim(rtrim(replace(replace(message,'"message" : "',''),'"',''))) as message,
ltrim(rtrim(replace(replace(userID,'"$oid" : "',''),'" }',''))) as userID,
ltrim(rtrim(replace(replace(instanceDB,'"$db" : "',''),'" } }',''))) as instanceDB
from commentPass2;


delete from scrubComment where commentID='';