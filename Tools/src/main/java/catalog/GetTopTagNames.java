package catalog;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Lists;
import com.google.common.collect.Multimap;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.*;
import java.util.stream.Collectors;

import static catalog.Catcher.safeGet;

@Slf4j
public class GetTopTagNames {

    private List<String> excludedFeatures = Lists.newArrayList("word2vec_sim","word2vec_diff","exposeSameAttr", "sizeAttr","priceDvalueNum", "elecAlphabetNumber", "fullNameAlphabetNumber1", "exposeAttr", "score", "priceDvalue", "varianceCompare", "alphabetNumberAttr", "sizeFullName", "productNameLastKorean", "fullNameAlphabetNumber2", "productNameLastAlphabetNumber", "nameContrast", "dlSimilarityScore", "sizeProductName", "alphabetNumber", "alphabetNumberTag");

    public Map<String, Double> parseItemBypassExcel(InputStream featureImportanceFile) {

        List<FeatureImportance> allFeatureImportances = Lists.newArrayList();

        try {
            Workbook excel = WorkbookFactory.create(featureImportanceFile);

            for (int sheetIndex = 0; sheetIndex < excel.getNumberOfSheets(); sheetIndex++) {
                Sheet sheet = excel.getSheetAt(sheetIndex);
//                log.info("rows count in sheet {} -- {}", sheet.getSheetName(), sheet.getLastRowNum() + 1);

                int topCount = 0;
                for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                    Row row = sheet.getRow(i);
                    if (row == null) {
                        break;
                    }

//                    log.info("{} -- {}", sheet.getSheetName(), i);

                    try {
                        double rank = row.getCell(0).getNumericCellValue();
                        String name = row.getCell(1).getStringCellValue();
                        double gain = row.getCell(3).getNumericCellValue();
                        double cover = row.getCell(4).getNumericCellValue();
                        double frequency = row.getCell(5).getNumericCellValue();

                        if (!excludedFeatures.contains(name)) {
                            FeatureImportance featureImportance = new FeatureImportance(rank, name, gain, cover, frequency);
                            allFeatureImportances.add(featureImportance);
                        }

                    } catch (Exception e) {
                        log.info("Break --");
                    }

                    if (++topCount == 10) {
                        continue;
                    }
                }
            }

            featureImportanceFile.close();

        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }

        Map<String, Double> finalMap = new LinkedHashMap<>();

        allFeatureImportances.stream().collect(Collectors.groupingBy(FeatureImportance::getName, Collectors.summingDouble(FeatureImportance::getGain)))
                             .entrySet().stream().sorted(Map.Entry.<String, Double>comparingByValue().reversed()).forEachOrdered(e -> finalMap.put(e.getKey(), e.getValue()));

        return finalMap;
    }

    public static void main(String[] args) {
        try {
            Map<String, Double> rankedResult = new GetTopTagNames().parseItemBypassExcel(new FileInputStream("/Users/huangwenbo/git/WbCodeBase/Tools/src/main/java/catalog/elec_model_feature_importance.xlsx"));
            log.info("\n result -- ");
            rankedResult.entrySet().forEach(o -> {
                log.info("{} - {}", o.getKey(), o.getValue());
            });
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

    }
}
