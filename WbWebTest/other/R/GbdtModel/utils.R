library(xgboost)
library("plyr")
library(RMySQL)
library(stringr)
library(utils)
library(base)
library(wkb)
require(rjson)

channel <- dbConnect(MySQL(), user="root", password="123456789", dbname="postdedup_matching", host="10.211.2.176")
dbSendQuery(channel, 'SET NAMES utf8')

clearAll <- function() {
  rm(list=ls())
  gc()
  
  all_cons <- dbListConnections(MySQL())
  for(con in all_cons)
    dbDisconnect(con)
}

getModelFeatures <- function(trainingModelId) {
  features <- dbGetQuery(channel, paste("select featureSequence from training_models where trainingModelId=",trainingModelId))
  feature_names <- str_split(features, "\\|")[[1]]
  
  return (feature_names)
}

loadGbdtModle <- function(trainingModelId) {
  modelData <- dbGetQuery(channel, paste("select HEX(trainingModelData) as trainingModelData from training_models where trainingModelId=",trainingModelId))
  xgb_model <- xgb.load(hex2raw(modelData$trainingModelData[1]))

  return (xgb_model)
}

getModelDetails <- function(modelIds) {
  modelDetails <- list()
  n <- 1
  
  for (modelId in modelIds) {
    feature_names <- getModelFeatures(modelId)
    xgb_model <- loadGbdtModle(modelId)
    modelDetails[[n]] <- list(feature_names, xgb_model)
    n <- n + 1
  }
  
  return (modelDetails)
}

loadFeatureScoreFromDb <- function(select_sql, feature_names) {
  pairItemData <- loadAllFeatureScoreFromDb(select_sql)
  feature_scores <- pairItemData[c(feature_names,'inspectionResult','cItemId','qItemId')]
  
  return (feature_scores)
}

loadAllFeatureScoreFromDb <- function(select_sql) {
  pairItemData <- dbGetQuery(channel, select_sql)
  jsonFeatureScores <- sapply(pairItemData$keySimExp,function(x) fromJSON(x), USE.NAMES=FALSE)
  featureScoreFrame <- data.frame(t(jsonFeatureScores), check.names = FALSE)
  for(i in 1:length(featureScoreFrame))
    tryCatch({
      featureScoreFrame[[i]] <- as.double(featureScoreFrame[[i]])
    }, error = function(e) {
      print (i)
      print (e)
      print (featureScoreFrame[[i]])
      break
    })
  
  return (cbind(pairItemData,featureScoreFrame))
}

gbdtPredict <- function(xgb_model,feature_scores) {
  feature_score_matrix <- as.matrix(feature_scores)
  # xgb_dmatrix <- xgb.DMatrix(feature_score_matrix,label=labelValue)
  xgb_dmatrix <- xgb.DMatrix(feature_score_matrix)
  score <- predict(xgb_model, xgb_dmatrix)
  
  return (score)
}

getEvaluationResult <- function(threshold, label_values, score) {
  label_values$score <- score
  label_values$pred <- ifelse(score>threshold,1,0)
  
  tNCases <- label_values[which(label_values$inspectionResult==label_values$pred&label_values$pred==0),]
  fPCases <- label_values[which(label_values$inspectionResult!=label_values$pred&label_values$pred==1),]
  fNCases <- label_values[which(label_values$inspectionResult!=label_values$pred&label_values$pred==0),]
  
  tPCount <- length(which(label_values$inspectionResult==label_values$pred&label_values$pred==1))
  tNCount <- length(which(label_values$inspectionResult==label_values$pred&label_values$pred==0))
  fPCount <- length(which(label_values$inspectionResult!=label_values$pred&label_values$pred==1))
  fNCount <- length(which(label_values$inspectionResult!=label_values$pred&label_values$pred==0))

  totalPredictedPositiveCount = tPCount + fPCount
  totalPredictedNegativeCount = tNCount + fNCount
  
  totalPositiveCount <- length(which(label_values$inspectionResult==1))
  totalNegativeCount <- length(which(label_values$inspectionResult==0))
  
  precision <- tPCount/totalPredictedPositiveCount
  recall <- tPCount/totalPositiveCount
  
  return (list(precision, recall,totalPositiveCount,totalNegativeCount))
}

normalizeFeatrueScoresFromLog <- function(log_feature_scores, feature_names) {
  jsonFeatureScoreFromLog <- str_replace_all(jsonFeatureScoreFromLog,'=','":')
  jsonFeatureScoreFromLog <- str_replace_all(jsonFeatureScoreFromLog,', ',',"')
  jsonFeatureScoreFromLog <- str_replace_all(jsonFeatureScoreFromLog,'\\{','\\{"')
  
  jsonFeatureScores <- sapply(jsonFeatureScoreFromLog,function(x) fromJSON(x), USE.NAMES=FALSE)
  featureScoreFrame <- data.frame(t(jsonFeatureScores), check.names = FALSE)
  for(i in 1:length(featureScoreFrame))
    featureScoreFrame[[i]] <- as.double(featureScoreFrame[[i]])
  feature_scores <- cbind(featureScoreFrame)[c(feature_names)]
  
  return (feature_scores)
}

validateGbdtModel <- function(trainingModelId, triggerIds, threshold) {
  result <- list()
  n <- 1
  
  feature_names <- getModelFeatures(trainingModelId)
  xgb_model <- loadGbdtModle(trainingModelId)
  
  for (triggerId in  triggerIds) {
    datasource <- paste("SIMULATION_",triggerId, sep = "", collapse = NULL)
    select_sql <- paste("SELECT b.cItemId,b.qItemId,b.score,b.dlSimilarityScore,b.keySimExp,b.inspectionResult FROM raw_pair_items a JOIN pair_items b ON a.cItemId = b.cItemId AND a.qItemId = b.qItemId AND a.dataSource IN ('",datasource,"') AND b.keySimExp IS NOT NULL", sep = "", collapse = NULL)
    feature_scores <- loadFeatureScoreFromDb(select_sql, feature_names)
    label_values <- feature_scores[c('cItemId','qItemId','inspectionResult')]
    predicted_scores <- gbdtPredict(xgb_model,feature_scores)
    evaluationResult <- getEvaluationResult(threshold,label_values,predicted_scores)
    
    print (paste("modelId:",trainingModelId,"& triggerId:",triggerId," -- precision:", evaluationResult[1], ",recall:", evaluationResult[2], ",positiveCount:", evaluationResult[3], ",negativeCount:", evaluationResult[4]))
  
    result[n] <- evaluationResult[1]
    n <- n + 1
  }
  
  return (result)
}

validateGbdtComboModel <- function(trainingModelIds, triggerIds, threshold) {
  result <- list()
  n <- 1
  
  modelDetails <- getModelDetails(trainingModelIds)

  for (triggerId in  triggerIds) {
    datasource <- paste("SIMULATION_",triggerId, sep = "", collapse = NULL)
    select_sql <- paste("SELECT b.cItemId,b.qItemId,b.score,b.dlSimilarityScore,b.keySimExp,b.inspectionResult FROM raw_pair_items a JOIN pair_items b ON a.cItemId = b.cItemId AND a.qItemId = b.qItemId AND a.dataSource IN ('",datasource,"') AND b.keySimExp IS NOT NULL", sep = "", collapse = NULL)
    pairItemData <- loadAllFeatureScoreFromDb(select_sql)
    
    count <- 1
    for (modelDetail in modelDetails) {
      feature_names <- modelDetail[[1]]
      xgb_model <- modelDetail[[2]]
      
      feature_scores <- pairItemData[c(feature_names,'inspectionResult','cItemId','qItemId')]
      label_values <- feature_scores[c('cItemId','qItemId','inspectionResult')]
      predicted_scores <- gbdtPredict(xgb_model,feature_scores)
      
      if (count > 1) {
        all_predicted_scores <- rbind(all_predicted_scores, predicted_scores)
      } else {
        all_predicted_scores <- predicted_scores
      }
      
      count <- count + 1
    }
    
    predicted_scores <- apply(all_predicted_scores,2,min)
    evaluationResult <- getEvaluationResult(threshold,label_values,predicted_scores)
    
    print (paste("modelId:",getModelsString(trainingModelIds),"& triggerId:",triggerId,"-- precision:", evaluationResult[1], ",recall:", evaluationResult[2], ",positiveCount:", evaluationResult[3], ",negativeCount:", evaluationResult[4]))
    
    result[n] <- evaluationResult[1]
    n <- n + 1
  }
  
  return (result)
}

getModelsString <- function(modelIds) {
  modelStr <- ""
  
  for (modelId in modelIds) {
    modelStr <- paste(modelStr, modelId)
  }
  
  return (modelStr)
}

validateGbdtModels <- function(modelIds, triggerIds, threshold) {
  evaluationResults <- list()
  pos <- 1
  
  for (modelId in modelIds) {
    result <- validateGbdtModel(modelId,triggerIds,threshold)
    resultVector <- unlist(result)
    evaluationResults[[pos]] <- resultVector
    
    pos <- pos + 1
  }
  
  return (evaluationResults)
}

predeictFromLog <- function(trainingModelId, jsonFeatureScoreFromLog) {
  feature_names <- getModelFeatures(trainingModelId)
  feature_scores <- normalizeFeatrueScoresFromLog(jsonFeatureScoreFromLog, feature_names)
  xgb_model <- loadGbdtModle(trainingModelId)
  
  mat <- xgb.importance (feature_names = feature_names, model = xgb_model)
  #xgb.plot.importance (importance_matrix = mat[1:40])
  
  predicted_scores <- gbdtPredict(xgb_model,feature_scores)
  
  print (paste("modelId:",trainingModelId," -- predictedScore:", predicted_scores))
}

drawLineChart <- function(modelIds, triggerIds, evaluationResults) {
  # mycols <- runif(length(modelIds),min=1,max=length(colors()))
  mycols <- palette()
  pos <- 1
  for (result in evaluationResults) {
    if (pos == 1) {
      plot(result, type = "o",col = mycols[pos], ylim=c(0.8,1),xlab = "TriggerId", ylab = "Precision", main = "Model Performance")
      axis(1,at=1:length(triggerIds),labels=triggerIds,cex=0.1)
    } else {
      lines(result, type = "o", col = mycols[pos])
    }
    
    pos <- pos + 1
  }
  
  abline(h=0.98,col="red",lty=2,lwd=1)
  legend("bottomleft",legend=modelIds,col=mycols,pch=c(2,24),lty=1,cex = 0.5,y.intersp =1,x.intersp =1,ncol=4)
}
