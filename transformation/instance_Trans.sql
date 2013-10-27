
use socialvoyce;

drop table if exists instance;

create table instance (
instanceID varchar(100) PRIMARY KEY ,
instanceName varchar(100)
) ;

insert into instance (
instanceID,
instanceName
)
select '50aa4fdf2ca17ba6c2099391' as instanceID,'sixx-community' as instanceName
union
select '51c806a4be66578a57180ecf' as instanceID, 'fitforfun-community' as instanceName
union
select '51d295a9a0153b5c639e2c4a' as instanceID,'mmi-community' as instanceName
union
select '52271adbc4813af2888de7cb' as instanceID,'connect-community' as instanceName;
