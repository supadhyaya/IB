
use socialvoyce;



drop table if exists scrubSocialLike;

delimiter $$

CREATE TABLE `scrubSocialLike` (
  `url` varchar(1000) DEFAULT NULL,
  `tweeter` int(11) DEFAULT NULL,
  `linkedin` int(11) DEFAULT NULL,
  `facebook_likes` int(11) DEFAULT NULL,
  `facebook_shares` int(11) DEFAULT NULL,
  `gplus` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4$$





delete from scrubSocialLike where url='';
