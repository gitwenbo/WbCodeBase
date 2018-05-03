DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `calculateVerifyResult`(modelId int, step float)
BEGIN

declare threshold float DEFAULT 0;

truncate table training_predict_results_summary;

while threshold < 1
  do
    call calculateSingleVerifyResult(modelId, 'training', threshold);
    call calculateSingleVerifyResult(modelId, 'testing', threshold);

    set threshold = threshold + step;

  end while;

select * from training_predict_results_summary where purpose='training';
select * from training_predict_results_summary where purpose='testing';
select * from training_predict_results_summary;

END$$
DELIMITER ;
