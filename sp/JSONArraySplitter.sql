use socialvoyce;

-- answer splitter 

DELIMITER $$

DROP PROCEDURE IF EXISTS explode_answer $$
CREATE PROCEDURE explode_answer(bound VARCHAR(255))

  BEGIN

    DECLARE votingID TEXT;
    DECLARE answer LONGTEXT;
    DECLARE occurance INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE splitted_value LONGTEXT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR SELECT answerPass1.votingID, answerPass1.answer
                                         FROM answerPass1
                                         WHERE answerPass1.votingID != '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    drop table if exists splitAnswer;

    create table splitAnswer (votingID varchar(500) , answer LONGTEXT);

    OPEN cur1;
      read_loop: LOOP
        FETCH cur1 INTO votingID, answer;
        IF done THEN
          LEAVE read_loop;
        END IF;

        SET occurance = (SELECT CHAR_LENGTH(answer)
                                 - CHAR_LENGTH(REPLACE(answer, bound, '|}}|'))
                                 +1);
        SET i=1;
        WHILE i <= occurance DO
          SET splitted_value =
          (SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(answer, bound, i),
          CHAR_LENGTH(SUBSTRING_INDEX(answer, bound, i - 1)) + 1), ',', ''));

          INSERT INTO splitAnswer VALUES (votingID, splitted_value);
          SET i = i + 1;

        END WHILE;
      END LOOP;

    CLOSE cur1;

  END; $$
  
-- votes splitter
-- votes splitter

DELIMITER $$

DROP PROCEDURE IF EXISTS explode_answer1 $$
CREATE PROCEDURE explode_answer1 (bound VARCHAR(255))
BEGIN

    DECLARE votingID TEXT;
    DECLARE answer LONGTEXT;
    DECLARE occurance INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE splitted_value LONGTEXT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR SELECT splitAnswer.votingID, splitAnswer.answer
                                         FROM splitAnswer
                                         WHERE splitAnswer.votingID != '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    drop table if exists splitAnswer1;

    create table splitAnswer1 (votingID varchar(200) , answer LONGTEXT);

    OPEN cur1;
      read_loop: LOOP
        FETCH cur1 INTO votingID, answer;
        IF done THEN
          LEAVE read_loop;
        END IF;

        SET occurance = (SELECT CHAR_LENGTH(answer)
                                 - CHAR_LENGTH(REPLACE(answer, bound, '%%$&$&$%%'))
                                 +1);
        SET i=1;
        WHILE i <= occurance DO
          SET splitted_value =
          (SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(answer, bound, i),
          CHAR_LENGTH(SUBSTRING_INDEX(answer, bound, i - 1)) + 1), ',', ''));

          INSERT INTO splitAnswer1 VALUES (votingID, splitted_value);
          SET i = i + 1;

        END WHILE;
      END LOOP;

    CLOSE cur1;

  END$$


-- comment splitter

DELIMITER $$

DROP PROCEDURE IF EXISTS explode_comment $$
CREATE PROCEDURE explode_comment(bound LONGTEXT)

  BEGIN

    DECLARE votingID TEXT;
    DECLARE comment LONGTEXT;
    DECLARE occurance INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE splitted_value LONGTEXT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR SELECT commentPass1.votingID, commentPass1.comment
                                         FROM commentPass1
                                         WHERE commentPass1.votingID != '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    drop table if exists splitComment;

    create table splitComment (votingID varchar(200) , comment LONGTEXT);

    OPEN cur1;
      read_loop: LOOP
        FETCH cur1 INTO votingID, comment;
        IF done THEN
          LEAVE read_loop;
        END IF;



        SET occurance = (SELECT CHAR_LENGTH(comment)
                                 - CHAR_LENGTH(REPLACE(comment, bound, '$$$$'))
                                 +1);
        SET i=1;
        WHILE i <= occurance DO
          SET splitted_value =
          (SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(comment, bound, i),
          CHAR_LENGTH(SUBSTRING_INDEX(comment, bound, i - 1)) +1), ',', ''));

          INSERT INTO splitComment VALUES (votingID, splitted_value);
          SET i = i + 1;

        END WHILE;
      END LOOP;

    CLOSE cur1;

  END; $$

-- tag splitter

DELIMITER $$

DROP PROCEDURE IF EXISTS explode_tag $$
CREATE PROCEDURE explode_tag(bound VARCHAR(255))

  BEGIN

    DECLARE votingID TEXT;
    DECLARE tag LONGTEXT;
    DECLARE occurance INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE splitted_value LONGTEXT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR SELECT votingTagPass1.votingID, votingTagPass1.tag
                                         FROM votingTagPass1
                                         WHERE votingTagPass1.votingID != '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    drop table if exists splitTag;

    create table splitTag (votingID varchar(200) , tag LONGTEXT);

    OPEN cur1;
      read_loop: LOOP
        FETCH cur1 INTO votingID, tag;
        IF done THEN
          LEAVE read_loop;
        END IF;

        SET occurance = (SELECT CHAR_LENGTH(tag)
                                 - CHAR_LENGTH(REPLACE(tag, bound, '$$$'))
                                 +1);
        SET i=1;
        WHILE i <= occurance DO
          SET splitted_value =
          (SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(tag, bound, i),
          CHAR_LENGTH(SUBSTRING_INDEX(tag, bound, i - 1)) + 1), ',', ''));

          INSERT INTO splitTag VALUES (votingID, splitted_value);
          SET i = i + 1;

        END WHILE;
      END LOOP;

    CLOSE cur1;

  END; $$


-- For Tag reports 


DELIMITER $$

DROP PROCEDURE IF EXISTS explode_tag2 $$
CREATE PROCEDURE explode_tag2(bound VARCHAR(255))

  BEGIN

    DECLARE tagID TEXT;
    DECLARE valueParts LONGTEXT;
    DECLARE occurance INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE splitted_value LONGTEXT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR SELECT tag.tagID, tag.valueParts
                                         FROM tag
                                         WHERE tag.tagID != '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    drop table if exists splitTag1;

    create table splitTag1 (tagID varchar(200) , valueParts LONGTEXT);

    OPEN cur1;
      read_loop: LOOP
        FETCH cur1 INTO tagID, valueParts;
        IF done THEN
          LEAVE read_loop;
        END IF;

        SET occurance = (SELECT CHAR_LENGTH(valueParts)
                                 - CHAR_LENGTH(REPLACE(valueParts, bound, '$'))
                                 +1);
        SET i=1;
        WHILE i <= occurance DO
          SET splitted_value =
          (SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(valueParts, bound, i),
          CHAR_LENGTH(SUBSTRING_INDEX(valueParts, bound, i - 1)) + 1), ',', ''));

          INSERT INTO splitTag1 VALUES (tagID, splitted_value);
          SET i = i + 1;

        END WHILE;
      END LOOP;

    CLOSE cur1;

  END; $$