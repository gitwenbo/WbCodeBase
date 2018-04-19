CREATE TABLE `matching_error_details` (
  `requestItemId` int(11) NOT NULL,
  `duplicateItemId` int(11) NOT NULL,
  `comments` varchar(450) COLLATE utf8_bin DEFAULT NULL,
  `comments_translated` varchar(450) COLLATE utf8_bin DEFAULT NULL,
  `verifier` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `cagtegoryIdDetail` varchar(450) COLLATE utf8_bin DEFAULT NULL,
  `grayLogDetail` varchar(4500) COLLATE utf8_bin DEFAULT NULL,
  `grayLogFscoreUrl` varchar(4500) COLLATE utf8_bin DEFAULT NULL,
  `trainingFeatureDetail` varchar(450) COLLATE utf8_bin DEFAULT NULL,
  `liveTrainingFeatureDetail` varchar(450) COLLATE utf8_bin DEFAULT NULL,
  `requestItemDetail` varchar(450) COLLATE utf8_bin DEFAULT NULL,
  `duplicateItemDetail` varchar(450) COLLATE utf8_bin DEFAULT NULL,
  `score` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `tagDetail` varchar(450) COLLATE utf8_bin DEFAULT NULL,
  `fscoreDiff` varchar(450) COLLATE utf8_bin DEFAULT NULL,
  `isTrainingScoreConsistent` varchar(45) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE TABLE `training_error_pair_items` (
  `pairItemId` int(11) NOT NULL,
  `qitemid` int(11) DEFAULT NULL,
  `citemid` int(11) DEFAULT NULL,
  `score` float DEFAULT NULL,
  PRIMARY KEY (`pairItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE TABLE `tmp_item_category_info` (
  `itemId` int(11) NOT NULL,
  `itemName` varchar(4500) COLLATE utf8_bin DEFAULT NULL,
  `categoryId` int(11) DEFAULT NULL,
  `categoryName` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`itemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

