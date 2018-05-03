DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `calculateSingleVerifyResult`(modelId int, purpose varchar(50), threshold float)
BEGIN


declare allCount INT DEFAULT 0;
declare tp INT DEFAULT 0;
declare tn INT DEFAULT 0;
declare fp INT DEFAULT 0;
declare fn INT DEFAULT 0;

declare inspectionResult INT DEFAULT 0;
declare result INT DEFAULT 0;

declare score float DEFAULT 0;
declare accuracy float DEFAULT 0;
declare precisionn float DEFAULT 0;
declare recall float DEFAULT 0;

declare no_more_departments integer DEFAULT 0;

declare C_RESULT CURSOR FOR
             select a.score, b.inspectionResult from training_predict_results a
			 join training_samples b on a.trainingSampleId=b.trainingSampleId and b.purpose=purpose where a.trainingModelId=modelId;

declare CONTINUE HANDLER FOR NOT FOUND
             SET no_more_departments=1;


OPEN C_RESULT;
     REPEAT
           FETCH C_RESULT INTO score, inspectionResult;

           if score > threshold then
              set result = 1;
              if result = inspectionResult then
				  set tp = tp + 1;
				else
				  set fp = fp + 1;
			  end if;
           else
               set result = 0;
               if result = inspectionResult then
				  set tn = tn + 1;
				else
				  set fn = fn + 1;
			  end if;
           end if;

     UNTIL no_more_departments  END REPEAT;
     CLOSE C_RESULT;

	 set allCount = tp + tn + fp + fn;
     set accuracy = (tp + tn) / (tp + tn + fp + fn);
     set precisionn = tp / (tp + fp);
     set recall = tp / (tp + fn);

     insert into training_predict_results_summary(`trainingModelId`, `threshold`,`allCount`, `tp`,`tn`,`fp`,`fn`,`accuracy`,`precision`,`recall`,`purpose`)
     values (modelId, threshold, allCount, tp, tn, fp, fn, accuracy, precisionn, recall, purpose);

END$$
DELIMITER ;


-- CREATE TABLE `training_predict_results_summary` (
--   `trainingModelId` bigint(20) DEFAULT NULL,
--   `allCount` bigint(20) DEFAULT NULL,
--   `threshold` float DEFAULT NULL,
--   `tp` bigint(20) DEFAULT NULL,
--   `tn` bigint(20) DEFAULT NULL,
--   `fp` bigint(20) DEFAULT NULL,
--   `fn` bigint(20) DEFAULT NULL,
--   `accuracy` float DEFAULT NULL,
--   `precision` float DEFAULT NULL,
--   `recall` float DEFAULT NULL,
--   `purpose` varchar(45) COLLATE utf8_bin DEFAULT NULL,
--   `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT 'row data create timestamp',
--   `modifiedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT 'last modified timestamp'
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
