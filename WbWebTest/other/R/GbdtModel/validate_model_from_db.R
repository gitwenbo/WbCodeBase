clearAll()
source('utils.R')

# modelIds=c(675,688,689,690,695,713)
triggerIds=list(11377,11392,11393,11676,11677,11693,11753,11930,11942,11943,12224,12225,12226,12255,12256,12257,12344,12345,12346,12475,12476,12477,12957,12983,12993)
# modelIds=c(675,690,695,713,720,722,727,729)
modelIds=c(695,720,727,756,767,770,772)
# triggerIds=list(12475,12476,12477)
# triggerIds=list(12255,12256,12257,12344,12345,12346,12475,12476,12477)

threshold=0.6

evaluationResults <- validateGbdtModels(modelIds, triggerIds, threshold)


validateGbdtComboModel(modelIds, triggerIds, threshold)

validateGbdtComboModel(c(695,720,727), c(12957,12983,12993), threshold)
validateGbdtComboModel(c(695,720,727,756), c(12957,12983,12993), threshold)
validateGbdtComboModel(c(695,720,727,767), c(12957,12983,12993), threshold)
validateGbdtComboModel(c(695,720,727,756,767), c(12957,12983,12993), threshold)
validateGbdtComboModel(c(695,720,727,756,772), c(12957,12983,12993), threshold)
validateGbdtComboModel(c(695,720,727,756,767,770), c(13310,13312,13313), threshold)
validateGbdtComboModel(c(695,720,727,756,767,770,777,792), c(13589,13590), threshold)

drawLineChart(modelIds, triggerIds, evaluationResults)

