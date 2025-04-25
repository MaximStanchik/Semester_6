package org.Stanchik;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.jfree.ui.ApplicationFrame;
import org.jfree.ui.RefineryUtilities;

import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class App extends ApplicationFrame {

    public App(String title) {
        super(title);
    }

    public static void main(String[] args) {
        int[] aValues = {5, 10, 15, 20, 25, 30, 35};

        BigInteger[] xValues = {
                new BigInteger("1009"),
                new BigInteger("1013"),
                new BigInteger("1019"),
                new BigInteger("1021"),
                new BigInteger("1031")
        };

        BigInteger[] nValues = {
                new BigInteger(1024, new Random()),
                new BigInteger(2048, new Random())
        };

        String filePath = "Calculations.xlsx";

        List<Long> durations = new ArrayList<>(); // Для хранения времени
        List<Integer> aList = new ArrayList<>(); // Для хранения значений a
        List<BigInteger> xList = new ArrayList<>(); // Для хранения значений x
        List<String> nBinaryList = new ArrayList<>(); // Для хранения n в двоичном виде
        List<BigInteger> yList = new ArrayList<>(); // Для хранения значений y

        System.out.printf("%-10s %-20s %-20s %-20s %-15s\n", "a", "x", "n (binary)", "y", "Time (ms)");

        for (int a : aValues) {
            for (BigInteger x : xValues) {
                for (BigInteger n : nValues) {
                    long startTime = System.nanoTime();
                    BigInteger y = BigInteger.valueOf(a).multiply(x).mod(n);
                    long endTime = System.nanoTime();

                    long duration = endTime - startTime;

                    String nBinary = n.toString(2);
                    if (n == nValues[0]) {
                        nBinary = "1024 bits";
                    } else if (n == nValues[1]) {
                        nBinary = "2048 bits";
                    }

                    System.out.printf("%-10d %-20s %-20s %-20s %-15d\n", a, x, nBinary, y, duration);

                    // Сохранение данных для графика и Excel
                    durations.add(duration);
                    aList.add(a);
                    xList.add(x);
                    nBinaryList.add(nBinary);
                    yList.add(y); // Сохраняем y для Excel
                }
            }
        }

        // Создание графиков
        createChart("График времени от a", aList, durations);
        createChart("График времени от x", xList, durations);
        createChart("График времени от n", nBinaryList, durations);

        // Сохранение данных в Excel
        try {
            saveWorkbook(filePath, aList, xList, nBinaryList, yList, durations);
            System.out.println("Excel файл создан.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void createChart(String title, List<?> paramList, List<Long> durations) {
        XYSeries series = new XYSeries(title);

        for (int i = 0; i < paramList.size(); i++) {
            // Используем реальные значения параметров для оси X
            series.add(i + 1, durations.get(i)); // Индекс в качестве оси X
        }

        XYSeriesCollection dataset = new XYSeriesCollection(series);
        JFreeChart chart = ChartFactory.createXYLineChart(
                title,
                "Параметр",
                "Время (мс)",
                dataset
        );

        ChartPanel chartPanel = new ChartPanel(chart);
        App chartFrame = new App(title);
        chartFrame.setContentPane(chartPanel);
        chartFrame.setSize(800, 600);
        chartFrame.setVisible(true);
        RefineryUtilities.centerFrameOnScreen(chartFrame);
    }

    private static void saveWorkbook(String filePath, List<Integer> aList, List<BigInteger> xList, List<String> nBinaryList, List<BigInteger> yList, List<Long> durations) throws IOException {
        try (Workbook workbook = new XSSFWorkbook(); FileOutputStream fileOut = new FileOutputStream(filePath)) {
            Sheet sheet = workbook.createSheet("Calculations");
            createHeader(sheet);

            int rowNum = 1;
            for (int i = 0; i < aList.size(); i++) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(aList.get(i));
                row.createCell(1).setCellValue(xList.get(i).toString());
                row.createCell(2).setCellValue(nBinaryList.get(i)); // Используем двоичное представление n
                row.createCell(3).setCellValue(yList.get(i).toString()); // Сохраняем y
                row.createCell(4).setCellValue(durations.get(i));
            }
            workbook.write(fileOut);
        }
    }

    private static void createHeader(Sheet sheet) {
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("a");
        headerRow.createCell(1).setCellValue("x");
        headerRow.createCell(2).setCellValue("n (binary)");
        headerRow.createCell(3).setCellValue("y");
        headerRow.createCell(4).setCellValue("Time (ms)");
    }
}