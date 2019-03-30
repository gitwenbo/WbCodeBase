source('utils.R')

modelId=1035
feature_names <- getModelFeatures(modelId)
xgb_model <- loadGbdtModle(modelId)
mat <- xgb.importance (feature_names = feature_names, model = xgb_model)
