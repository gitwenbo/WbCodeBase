DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `compareFeatureScores`(modelId int, trainingScoreString varchar(1000), grayLogScoreString varchar(1000))
BEGIN

DECLARE i INT DEFAULT 0;
declare featureSequenceString varchar(1000);
truncate table tmp_feature_score_compare;
select featureSequence into featureSequenceString from training_models where trainingModelId in (modelId);

set @isTrainingScoreNA = ISNULL(trainingScoreString) || LENGTH(trim(trainingScoreString))<1;
set @isGrayLogScoreNA = ISNULL(grayLogScoreString) || LENGTH(trim(grayLogScoreString))<1;

IF @isTrainingScoreNA || @isGrayLogScoreNA THEN
  select concat('isTrainingScoreNA:',@isTrainingScoreNA,', isGrayLogScoreNA:',@isGrayLogScoreNA) from dual;
ELSE
  SET @arraylength=1+(LENGTH(featureSequenceString) - LENGTH(REPLACE(featureSequenceString,'|','')));

  WHILE i<@arraylength
    DO
    SET i=i+1;
    SET @featureName = REVERSE(SUBSTRING_INDEX(REVERSE(SUBSTRING_INDEX(featureSequenceString,'|',i)),'|',1));
    SET @trainingScore = REVERSE(SUBSTRING_INDEX(REVERSE(SUBSTRING_INDEX(trainingScoreString,',',i)),',',1));
    SET @grayLogScore = REVERSE(SUBSTRING_INDEX(REVERSE(SUBSTRING_INDEX(grayLogScoreString,',',i)),',',1));

    IF (ABS(@trainingScore-@grayLogScore) < 0.01) THEN
      INSERT INTO tmp_feature_score_compare VALUE(@featureName,@trainingScore,@grayLogScore,1);
    ELSE
      INSERT INTO tmp_feature_score_compare VALUE(@featureName,@trainingScore,@grayLogScore,0);
    END IF;

  END WHILE;

  select IFNULL(group_concat(' ', featureName,':',trainingScore,'/',graylogScore), 'NA') from tmp_feature_score_compare where isSameScore = 0;

END IF;


END$$
DELIMITER ;


-- CREATE TABLE `tmp_feature_score_compare` (
--   `featureName` varchar(500) COLLATE utf8_bin NOT NULL,
--   `trainingScore` float DEFAULT NULL,
--   `graylogScore` float DEFAULT NULL,
--   `isSameScore` tinyint(1) DEFAULT NULL
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
