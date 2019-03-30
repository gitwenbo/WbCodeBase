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

trainingModelId=688
jsonFeatureScoreFromLog <- '
{색상=0.0, 기타스포츠용품종류=0.0, 번들여부=0.0, word2vec_sim=0.91695815, exposeAttrType=-2.0, 휴대폰케이스적용모델=-2.0, word2vec_tag_diff_avg=0.23152252, 저장용량속성=0.0, 휴대폰통신사=0.0, 휴대폰충전기종류=0.0, 주파수대역속성=0.0, 여성용스킨/토너종류=0.0, 의류사이즈=0.0, productName=1.0, score=1.0, YEAR=0.0, 신발사이즈=0.0, GBDT_2296_L2_v10_Normalized=0.0, nameSimilarity=0.2, brand=0.5, 의류형태(소매/기장)=0.0, 의류종류=1.0, 타입속성=0.0, 키보드방식=0.0, productId=0.0, 건전지사이즈=0.0, TV액세서리종류=0.0, cmCount=6.9255953, 가전제품종류=1.0, 가전사용목적별=0.0, unresolved=0.5, qScore=1.0, properNoun=0.0, GBDT_2296_L2_v8_Normalized=0.0, roundScore=1.0, ELEC_2233-2296_79_Normalized=0.0, 형광등류색=0.0, 만년필펜촉=0.0, 구성품=0.0, 주방용품재질=0.0, 카시트액세서리종류=0.0, ELEC_2233-2296_56_Normalized=0.0, elecAlphabetNumber=0.6, priceDvalue=0.26, 생활용품향=0.0, 포장용품종류=0.0, manufacturer=0.33, 셔터스피드속성=0.0, 시리얼포장/용량=0.0, 잉크/레이져=0.0, 보호필름중요단어=0.0, cScore=1.0, 전기속성=0.0, 구성수량속성=0.0, GBDT_2296_L2_v9=0.08, GBDT_2296_L2_v8=0.04, 알파벳타입=0.0, 샴푸/린스종류=0.0, ELEC_2233-2296_31=0.55, categoryIdScore=5.7530573E8, 사탕류종류(맛)=0.0, 휴대폰케이스프로덕트라인=0.0, 통신기기용액세서리종류=0.0, 세제타입=0.0, 유아용품캐릭터=0.0, 생리대사이즈=0.0, BUNDLE_KOREAN=0.0, skuCodeScore=-2.0, 기타속성=0.0, 색연필타입=0.0, 가공식품맛=0.0, exposeAttr=0.67, 가방재질=0.0, 휴대폰케이블종류=0.0, dlSimilarityScore=1.0, 휴대폰보호필름프로덕트라인=0.0, 수용인원=0.0, 미분류=1.0, 잉크/토너타입=0.0, barcode=0.0, 헤어ACC디자인=0.0, NUMBER=-1.0, txtScore=0.004115039, 무게속성=0.0, 알파벳코드=1.0, qCount=6.9255953, 성별=1.0, 사이즈=0.0, 신발소재=0.0, ELEC_2233-2296_31_Normalized=1.0, simScore=1.0, ELEC_2233-2296_56=0.44, 길이속성=0.0, 화장품종류=0.0, word2vec_tag_diff_max=1.0423439, cCount=6.9255953, 용기=0.0, 네일케어색상=0.0, 휴대폰/태블릿적용모델=0.0, 물티슈타입=0.0, 건강식품타입=0.0, ELEC_2233-2296_100=0.69, 의류소재=0.0, 시계쥬얼리재질=0.0, 전구/형광등규격=0.0, qmCount=6.9255953, GBDT_2296_L2_v9_Normalized=0.0, 부피/용량속성=0.0, ELEC_2233-2296_100_Normalized=1.0, 메모/표시용품종류=0.0, 휴대폰케이스형태=1.0, 프린터/복사용지용지크기=0.0, modelNo=1.0, exposeSameAttr=0.0, GBDT_2296_L2_v10=0.05, ELEC_2233-2296_79=0.28, word2vec_diff=0.91807175, 설치형태=0.0, BUNDLE_NUMBER=0.0, 기타컴퓨터주변기기종류=0.0, 홍보문구=0.0, nameContrast=1.0, 저장용기형태=0.0}
'

# load model from DB
features <- dbGetQuery(channel, paste("select featureSequence from training_models where trainingModelId=",trainingModelId))
feature_names <- str_split(features, "\\|")[[1]]
modelData <- dbGetQuery(channel, paste("select HEX(trainingModelData) as trainingModelData from training_models where trainingModelId=",trainingModelId))
xgb_model <- xgb.load(hex2raw(modelData$trainingModelData[1]))

# normalize feature score
jsonFeatureScoreFromLog <- str_replace_all(jsonFeatureScoreFromLog,'=','":')
jsonFeatureScoreFromLog <- str_replace_all(jsonFeatureScoreFromLog,', ',',"')
jsonFeatureScoreFromLog <- str_replace_all(jsonFeatureScoreFromLog,'\\{','\\{"')
jsonFeatureScores <- sapply(jsonFeatureScoreFromLog,function(x) fromJSON(x), USE.NAMES=FALSE)
featureScoreFrame <- data.frame(t(jsonFeatureScores), check.names = FALSE)
for(i in 1:length(featureScoreFrame))
  featureScoreFrame[[i]] <- as.double(featureScoreFrame[[i]])
feature_scores <- cbind(featureScoreFrame)[c(feature_names)]

# predict
data_matrix <- as.matrix(feature_scores)
data_matrix_xgb <- xgb.DMatrix(data_matrix,label=c(0),missing=-100)
predict_score <- predict(xgb_model, data_matrix_xgb)

print (paste("predict_score:", predict_score))
