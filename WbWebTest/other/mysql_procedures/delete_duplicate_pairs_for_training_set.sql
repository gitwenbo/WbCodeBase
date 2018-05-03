DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `delete_duplicate_pairs_for_training_set`(theTrainingSetId int)
BEGIN
  DECLARE _cItemId bigint(20);
  DECLARE _qItemId bigint(20);
    DECLARE _minPariItemId bigint(20);

    DECLARE done INT DEFAULT FALSE;
  DECLARE c CURSOR FOR SELECT cItemId, qItemId FROM pair_items where trainingSetId=theTrainingSetId GROUP BY cItemId , qItemId HAVING COUNT(1) > 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN c;
  read_loop: LOOP

  FETCH c INTO _cItemId, _qItemId;
  -- 声明结束的时候
  IF done THEN
    LEAVE read_loop;
  END IF;

  SELECT MIN(pairItemId) INTO _minPariItemId FROM pair_items WHERE  cItemId = _cItemId AND qItemId = _qItemId;

  DELETE FROM pair_items WHERE pairItemId <> _minPariItemId AND cItemId = _cItemId AND qItemId = _qItemId;
  COMMIT;
  END LOOP;
  -- 关闭游标
  CLOSE c;
END$$
DELIMITER ;