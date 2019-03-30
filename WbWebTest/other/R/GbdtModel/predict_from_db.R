source('utils.R')

trainingModelId=690
select_sql="SELECT b.score,b.dlSimilarityScore,b.keySimExp,b.inspectionResult FROM raw_pair_items a JOIN pair_items b ON a.cItemId = b.cItemId AND a.qItemId = b.qItemId AND a.dataSource IN ('SIMULATION_12224' , 'SIMULATION_12225', 'SIMULATION_12226') AND b.keySimExp IS NOT NULL"
threshold=0.5

validateGbdtModel(690,select_sql,threshold)