
use socialvoyce;

drop table if exists initialSeeder;

create table initialSeeder(nickName TEXT ,questionText TEXT);

LOAD  DATA  infile '/opt/database-migration/current/sourcefiles/seederDetail.csv' 
INTO TABLE initialSeeder  FIELDS TERMINATED BY '||||' LINES TERMINATED BY '\n';

delete from initialSeeder where nickName like 'nick Name';