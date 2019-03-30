rm(list=ls())
gc()

library(xgboost)
library("plyr")
library(RMySQL)
library(stringr)
library(utils)
library(base)
library(wkb)
require(rjson)

all_cons <- dbListConnections(MySQL())
for(con in all_cons)
  dbDisconnect(con)

channel <- dbConnect(MySQL(), user="root", password="123456789", dbname="postdedup_matching", host="10.211.2.176")
dbSendQuery(channel, 'SET NAMES utf8')

# load model from DB
trainingModelId=690
features <- dbGetQuery(channel, paste("select featureSequence from training_models where trainingModelId=",trainingModelId))
feature_names <- str_split(features, "\\|")[[1]]
modelData <- dbGetQuery(channel, paste("select HEX(trainingModelData) as trainingModelData from training_models where trainingModelId=",trainingModelId))
xgb_model <- xgb.load(hex2raw(modelData$trainingModelData[1]))

#feature importance
mat <- xgb.importance (feature_names = feature_names, model = xgb_model)
#xgb.plot.importance (importance_matrix = mat[1:40])

# load test data from DB
pairItemData <- dbGetQuery(channel, "SELECT 
    b.score,b.dlSimilarityScore,b.keySimExp, b.inspectionResult
                 FROM
                 raw_pair_items a
                 JOIN
                 pair_items b ON a.cItemId = b.cItemId
                 AND a.qItemId = b.qItemId
                 -- AND pairItemId=
                 AND a.dataSource in ('SIMULATION_12224','SIMULATION_12225','SIMULATION_12226') and b.keySimExp is not null")

# process keySimExp json
jsonFeatureScores <- sapply(pairItemData$keySimExp,function(x) fromJSON(x), USE.NAMES=FALSE)
featureScoreFrame <- data.frame(t(jsonFeatureScores), check.names = FALSE)
for(i in 1:length(featureScoreFrame))
  featureScoreFrame[[i]] <- as.double(featureScoreFrame[[i]])

# sort out features by name
feature_scores <- cbind(pairItemData,featureScoreFrame)[c(feature_names,'inspectionResult')]
pairItem.label <- pairItemData[,'inspectionResult']

# predict
feature_score_matrix <- as.matrix(feature_scores)
xgb_dmatrix <- xgb.DMatrix(feature_score_matrix,label=pairItem.label)
score <- predict(xgb_model, xgb_dmatrix)
feature_scores$pred <- ifelse(score>0.5,1,0)

# precision & recall
truePredictedCount <- length(which(feature_scores$inspectionResult==feature_scores$pred&feature_scores$pred==1))
totalPredictedCount <- length(which(feature_scores$pred==1))
totalInspectedCount <- length(which(feature_scores$inspectionResult==1))

overall_precision <- truePredictedCount/totalPredictedCount
recall <- truePredictedCount/totalInspectedCount

print (paste("overall_precision:", overall_precision, ",recall:", recall))
