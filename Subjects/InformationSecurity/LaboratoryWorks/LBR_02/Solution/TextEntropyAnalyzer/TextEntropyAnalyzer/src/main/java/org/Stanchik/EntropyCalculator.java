package org.Stanchik;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

public class EntropyCalculator {
    public double calculateEntropy(Map<Character, Double> charProbabilities) {
        double entropy = 0.0;
        for (double charProbability : charProbabilities.values()) {
            if (charProbability > 0) {
                entropy -= charProbability * (Math.log(charProbability) / Math.log(2));
            }
        }
        return entropy;
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

    public String readFile (String filePath) {
        String content = "";
        try {
            content = new String(Files.readAllBytes(Paths.get(filePath)), "UTF-8");
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        return content;
    }

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
        } catch (Exception e) {
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
        } catch (IOException e) {
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
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public int[] countZerosAndOnes(String text) {
        int countZero = 0;
        int countOne = 0;

        for (char c : text.toCharArray()) {
            if (c == '0') {
                countZero++;
            } else if (c == '1') {
                countOne++;
            }
        }

        return new int[]{countZero, countOne};
    }

    public double calculateBinaryEntropy(int countZero, int countOne) {
        int totalCount = countZero + countOne;

        if (totalCount == 0) {
            return 0.0;
        }

        double p0 = (double) countZero / totalCount;
        double p1 = (double) countOne / totalCount;

        if (p0 == 0 || p1 == 0) {
            return 0.0;
        }

        double entropy = - (p0 * (Math.log(p0) / Math.log(2)) + p1 * (Math.log(p1) / Math.log(2)));
        return entropy;
    }

    public double getEffectiveEntropy(String text, double p) {
        double q = 1 - p;
        if (isBinaryText(text) && (p == 0 || q == 0))
            return 1;
        if (!isBinaryText(text) && p == 1)
            return 0;
        return 1 - (-p * (Math.log(p) / Math.log(2)) - q * (Math.log(q) / Math.log(2)));
    }

    public double getInformationAmount(double entropy, String str, double effEntropy) {
        double informationAmount = entropy * str.length() * effEntropy;
        return Math.round(informationAmount * 1000.0) / 1000.0;
    }

    public boolean isBinaryText(String text) {
        for (char c : text.toCharArray()) {
            if (c != '0' && c != '1' && c != ' ') {
                return false;
            }
        }
        return true;
    }
}
