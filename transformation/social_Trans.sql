

use socialvoyce;

create table if not exists socialLike (
votingID int not null primary key,
url varchar(1000),
tweeter int,
linkedin int,
facebook_likes int,
facebook_shares int,
gPlus int
);



UPDATE socialLike  
INNER JOIN 
scrubSocialLike a
ON socialLike.url = a.url
set
socialLike.tweeter=a.tweeter,
socialLike.linkedin=a.linkedin,
socialLike.facebook_likes=a.facebook_likes,
socialLike.facebook_shares=a.facebook_shares,
socialLike.gPlus=a.gPlus;


insert into socialLike (
votingID,
url,
tweeter,
linkedin,
facebook_likes,
facebook_shares,
gPlus
)
select 
b.id as votingID,
a.url as url,
a.tweeter,
a.linkedin,
a.facebook_likes,
a.facebook_shares,
a.gPlus
from 
    scrubSocialLike a
left join 
    url_table b
on
    a.url=b.fullurl
left join 
    socialLike c
on 
    c.url=b.fullurl
where 
    c.votingID is null;
