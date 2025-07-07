package org.Stanchik.EncryptAndDecrypt;

import java.io.IOException;

public class RouteRearrangement {
    public static String encryptRouteSwap(int rows, int cols, String text) throws IOException {
        if (rows < 0) {
            rows = rows * (-1);
        }

        if (cols < 0) {
            cols =cols * (-1);
        }

        int totalChars = rows * cols;
        char[][] table = new char[rows][cols];

        if (text.length() < totalChars) {
            text = String.format("%-" + totalChars + "s", text).replace(' ', 'X');
        }

        if (text.length() > totalChars) {
            System.out.println("Кол-во символов в тексте больше, чем может вместиться в таблицу, поэтому текст будет обрезан");
            text = text.substring(0, totalChars);
        }

        int index = 0;
        for (int col = 0; col < cols; col++) {
            for (int row = 0; row < rows; row++) {
                table[row][col] = text.charAt(index++);
            }
        }

        StringBuilder result = new StringBuilder();
        for (int row = 0; row < rows; row++) {
            for (int col = 0; col < cols; col++) {
                result.append(table[row][col]);
            }
        }

        return result.toString();
    }

    public String decryptRouteSwap(int rows, int cols, String encryptedText) throws IOException {
        if (rows < 0) {
            rows = rows * (-1);
        }

        if (cols < 0) {
            cols = cols * (-1);
        }

        int totalChars = rows * cols;
        char[][] table = new char[rows][cols];

        if (encryptedText.length() != totalChars) {
            throw new IOException("Некорректная длина зашифрованного текста. Ожидается: " + totalChars);
        }

        int index = 0;
        for (int row = 0; row < rows; row++) {
            for (int col = 0; col < cols; col++) {
                table[row][col] = encryptedText.charAt(index++);
            }
        }

        StringBuilder result = new StringBuilder();
        for (int col = 0; col < cols; col++) {
            for (int row = 0; row < rows; row++) {
                result.append(table[row][col]);
            }
        }

        String decrypted = result.toString();
        if (decrypted.endsWith("X")) {
            decrypted = decrypted.replaceAll("X+$", "");
        }

        return decrypted;
    }
}
