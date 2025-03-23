package org.Stanchik;

public class JavaExporter {
    public static void exportToExcel(DriverRecord driver, String fileName) {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Driver Info");

        // Заголовки
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("Login");
        headerRow.createCell(1).setCellValue("First Name");
        headerRow.createCell(2).setCellValue("Last Name");
        headerRow.createCell(3).setCellValue("Middle Name");
        headerRow.createCell(4).setCellValue("Address");
        headerRow.createCell(5).setCellValue("Birth Date");
        headerRow.createCell(6).setCellValue("Email");
        headerRow.createCell(7).setCellValue("Passport Number");
        headerRow.createCell(8).setCellValue("Phone Number");

        // Данные водителя
        Row dataRow = sheet.createRow(1);
        dataRow.createCell(0).setCellValue(driver.getLogin());
        dataRow.createCell(1).setCellValue(driver.getFirstName());
        dataRow.createCell(2).setCellValue(driver.getLastName());
        dataRow.createCell(3).setCellValue(driver.getMiddleName());
        dataRow.createCell(4).setCellValue(driver.getAddress());
        dataRow.createCell(5).setCellValue(driver.getBirthDate().toString());
        dataRow.createCell(6).setCellValue(driver.getEmail());
        dataRow.createCell(7).setCellValue(driver.getPassportNum());
        dataRow.createCell(8).setCellValue(driver.getPhoneNumber());

        // Запись в файл
        try (FileOutputStream fileOut = new FileOutputStream(fileName)) {
            workbook.write(fileOut);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                workbook.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
