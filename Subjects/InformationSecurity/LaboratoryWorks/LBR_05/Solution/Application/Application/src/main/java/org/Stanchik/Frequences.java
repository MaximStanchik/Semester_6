package org.Stanchik;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Map;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;

import java.util.HashMap;


public class Frequences {
    public void saveFrequenciesToExcel(Map<Character, Double> frequencies, String filename) {


        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Frequencies");

        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("Символ");
        headerRow.createCell(1).setCellValue("Частота");

        int rowNum = 1;
        for (Map.Entry<Character, Double> entry : frequencies.entrySet()) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(entry.getKey().toString());
            row.createCell(1).setCellValue(entry.getValue());
        }

        try (FileOutputStream fileOut = new FileOutputStream(filename)) {
            workbook.write(fileOut);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("Частота символов сохранена в " + filename);
    }

    public void saveHistogramToExcel(Map<Character, Double> frequencies, String excelFilePath) {
        CategoryDataset dataset = createDataset(frequencies);

        JFreeChart histogram = ChartFactory.createBarChart(
                "Частоты символов",
                "Символ",
                "Частота",
                dataset
        );

        String imagePath = "histogram.png";
        try {
            ChartUtils.saveChartAsPNG(new File(imagePath), histogram, 800, 600);
            System.out.println("Гистограмма сохранена в " + imagePath);
        }
        catch (IOException e) {
            e.printStackTrace();
        }

        insertImageToExcel(imagePath, excelFilePath);
    }

    private CategoryDataset createDataset(Map<Character, Double> frequencies) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for (Map.Entry<Character, Double> entry : frequencies.entrySet()) {
            dataset.addValue(entry.getValue(), "Частота", entry.getKey().toString());
        }
        return dataset;
    }
    private void insertImageToExcel(String imagePath, String excelFilePath) {
        try (FileInputStream fis = new FileInputStream(imagePath);
             Workbook workbook = new XSSFWorkbook(new FileInputStream(excelFilePath))) {

            Sheet sheet = workbook.getSheetAt(0);

            int pictureIdx = workbook.addPicture(fis.readAllBytes(), Workbook.PICTURE_TYPE_PNG);
            CreationHelper helper = workbook.getCreationHelper();
            Drawing<?> drawing = sheet.createDrawingPatriarch();
            ClientAnchor anchor = helper.createClientAnchor();
            anchor.setCol1(3);
            anchor.setRow1(3);
            drawing.createPicture(anchor, pictureIdx).resize();

            try (FileOutputStream fileOut = new FileOutputStream(excelFilePath)) {
                workbook.write(fileOut);
            }
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
    public Map<Character, Double> calculateProbabilities(String text) {
        Map<Character, Integer> frequencyMap = new HashMap<>();
        int totalCount = 0;

        for (char c : text.toCharArray()) {
            frequencyMap.put(c, frequencyMap.getOrDefault(c, 0) + 1);
            totalCount++;
        }

        Map<Character, Double> probabilities = new HashMap<>();

        for (Map.Entry<Character, Integer> entry : frequencyMap.entrySet()) {
            char character = entry.getKey();
            int frequency = entry.getValue();
            double probability = (double) frequency / totalCount;
            probabilities.put(character, probability);
        }

        return probabilities;
    }

}
