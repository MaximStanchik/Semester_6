package org.Stanchik;

import org.apache.commons.imaging.ImageReadException;
import org.apache.commons.imaging.ImageWriteException;

import java.io.IOException;
import java.util.Scanner;

public class App
{
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Вариант 10");

        String containerPath = "D:\\User\\Documents\\GitHub\\Semester_6\\Subjects\\InformationSecurity\\LaboratoryWorks\\LBR_14\\Application\\LBR_13\\files\\cosmos.png";
        System.out.println("Путь к файлу-контейнеру: " + containerPath);

        String message = "Maxim Stanchik Andreevich";
        System.out.print("Изначальный текст: " + message);

        System.out.print("Введите метод (ROWS или COLS): ");
        String method = scanner.nextLine().toUpperCase();

        String outputFilePath = "D:\\User\\Documents\\GitHub\\Semester_6\\Subjects\\InformationSecurity\\LaboratoryWorks\\LBR_14\\Application\\LBR_13\\files\\cosmos.png";
        String originalMatrixPath = "D:\\User\\Documents\\GitHub\\Semester_6\\Subjects\\InformationSecurity\\LaboratoryWorks\\LBR_14\\Application\\LBR_13\\files\\cosmos_original.bmp";
        String embeddedMatrixPath = "D:\\User\\Documents\\GitHub\\Semester_6\\Subjects\\InformationSecurity\\LaboratoryWorks\\LBR_14\\Application\\LBR_13\\files\\cosmos_embedded.bmp";

        Steganography steganography = new Steganography();

        try {
            steganography.getColorMatrix(containerPath, originalMatrixPath);
            System.out.println("Цветовая матрица исходного файла сохранена.");

            steganography.embedMessage(containerPath, message, outputFilePath, Steganography.Method.valueOf(method));
            System.out.println("Сообщение успешно встраивается.");

            steganography.getColorMatrix(outputFilePath, embeddedMatrixPath);
            System.out.println("Цветовая матрица файла с встраиваемым сообщением сохранена.");

        } catch (IOException | ImageReadException | ImageWriteException e) {
            System.err.println("Ошибка: " + e.getMessage());
        }

        try {
            String extractedMessage = steganography.extractMessage(outputFilePath, Steganography.Method.valueOf(method));
            System.out.println("Извлеченное сообщение: " + extractedMessage);
        } catch (IOException | ImageReadException e) {
            System.err.println("Ошибка: " + e.getMessage());
        }
        scanner.close();
    }
}
