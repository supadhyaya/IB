
use socialvoyce;

drop table if exists initialAnswer;

create table initialAnswer(answer LONGTEXT);

LOAD  DATA  infile '/opt/database-migration/sourcefiles/answer.txt' 
INTO TABLE initialAnswer  LINES TERMINATED BY '\n';

drop table if exists answerPass1;

create table answerPass1 as
select substring(answer,1,INSTR(answer,'}')) as votingID,
substring(answer,instr(answer,'}'),CHAR_LENGTH(answer)) as answer from initialAnswer;


call explode_answer('} ] }');

call explode_answer1('] } { "_id');

drop table if exists splitAnswer11;

create table splitAnswer11 as 
select * from splitAnswer1;

delete from splitAnswer1 
where answer not like '%"text" :%';

delete from splitAnswer1 
where answer='';


drop table if exists answerPass2;
create table answerPass2
as select votingID,substring(answer,instr(answer,'$oid'),35) as answerID,
case when
substring(answer,instr(answer,'"text" :'),instr(answer,'"tags" :')-instr(answer,'"text" :'))='' then  
substring(answer,instr(answer,'"text" :'),instr(answer,'"votes" :')-instr(answer,'"text" :'))
when
substring(answer,instr(answer,'"text" :'),instr(answer,'"media" :')-instr(answer,'"text" :'))='' then
substring(answer,instr(answer,'"text" :'),instr(answer,'"votes" :')-instr(answer,'"text" :'))
when
substring(answer,instr(answer,'"text" :'),instr(answer,'"value" :')-instr(answer,'"text" :'))='' then
substring(answer,instr(answer,'"text" :'),instr(answer,'"votes" :')-instr(answer,'"text" :'))
else 0 end
as answerText,
substring(answer,instr(answer,'"votes" :'),CHAR_LENGTH(answer)) as vote
from splitAnswer1;

drop table if exists scrubAnswer;

create table scrubAnswer as
select distinct ltrim(rtrim(replace(replace(replace(votingID,'{ "_id" : { "$oid" : "',''),'" }',''),'','')))  as votingID,
ltrim(rtrim(replace(replace(answerID,'$oid" : "',''),'"',''))) as answerID,
ltrim(rtrim(replace(replace(answerText,'"text" : "',''),'"',''))) as answerText,
ltrim(rtrim(CHAR_LENGTH(vote)-CHAR_LENGTH(REPLACE(vote, '"_id"', '|}}|')))) as  votes
from answerPass2;

-- SELECT CHAR_LENGTH(vote)-CHAR_LENGTH(REPLACE(vote, '"_id"', '|}}|')) +1 ,answerID from answerPass2


delete from scrubAnswer where answerID='';
