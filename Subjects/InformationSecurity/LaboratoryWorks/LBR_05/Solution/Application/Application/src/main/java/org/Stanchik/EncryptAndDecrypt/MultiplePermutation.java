package org.Stanchik.EncryptAndDecrypt;

import java.util.HashSet;

public class MultiplePermutation {
    public String encodeMultiple(String text, String columnKey, String rowKey) {
        int columnLength = columnKey.length();
        int rowLength = rowKey.length();
        int index = 0;
        int size = (int) Math.ceil((double) text.length() / (rowLength * columnLength));
        char[][] matrix = new char[rowLength][columnLength];
        StringBuilder encryptedText = new StringBuilder();

        for (int k = 0; k < size; k++) {
            for (int i = 0; i < rowLength; i++) {
                for (int j = 0; j < columnLength; j++) {
                    if (index < text.length()) {
                        matrix[i][j] = text.charAt(index++);
                    }
                    else {
                        matrix[i][j] = '\0';
                    }
                }
            }
            char[][] buff1 = new char[rowLength][columnLength];
            int pr1 = 0;
            HashSet<Integer> processedIndexes1 = new HashSet<>();
            for (char column : columnKey.toCharArray()) {
                for (int columnIndex = 0; columnIndex < columnKey.length(); columnIndex++) {
                    if (column == columnKey.charAt(columnIndex) && !processedIndexes1.contains(columnIndex)) {
                        processedIndexes1.add(columnIndex);
                        for (int i = 0; i < rowLength; i++) {
                            buff1[i][pr1] = matrix[i][columnIndex];
                        }
                        pr1++;}}}
            char[][] buff2 = new char[rowLength][columnLength];
            int pr2 = 0;
            HashSet<Integer> processedIndexes2 = new HashSet<>();
            for (char row : rowKey.toCharArray()) {
                for (int rowIndex = 0; rowIndex < rowKey.length(); rowIndex++) {
                    if (row == rowKey.charAt(rowIndex) && !processedIndexes2.contains(rowIndex)) {
                        processedIndexes2.add(rowIndex);
                        for (int i = 0; i < columnLength; i++) {
                            buff2[pr2][i] = buff1[rowIndex][i];
                        }
                        pr2++;
                    }
                }
            }
            for (int i = 0; i < columnLength; i++) {
                for (int j = 0; j < rowLength; j++) {
                    encryptedText.append(buff2[j][i]);
                }
            }
        }
        return encryptedText.toString();
    }

    public String decodeMultiple(String text, String columnKey, String rowKey) {
        int columnLength = columnKey.length();
        int rowLength = rowKey.length();
        int index = 0;
        int size = (int) Math.ceil((double) text.length() / (rowLength * columnLength));
        char[][] matrix = new char[rowLength][columnLength];
        StringBuilder decodeText = new StringBuilder();
        for (int k = 0; k < size; k++) {
            for (int i = 0; i < rowLength; i++) {
                for (int j = 0; j < columnLength; j++) {
                    if (index < text.length()) {
                        matrix[i][j] = text.charAt(index++);
                    } else {
                        matrix[i][j] = '\0';
                    }
                }
            }
            char[][] buff1 = new char[rowLength][columnLength];
            int pr1 = 0;
            HashSet<Integer> processedIndexes1 = new HashSet<>();
            for (char row : rowKey.toCharArray()) {
                for (int rowIndex = 0; rowIndex < rowKey.length(); rowIndex++) {
                    if (row == rowKey.charAt(rowIndex) && !processedIndexes1.contains(rowIndex)) {
                        processedIndexes1.add(rowIndex);
                        for (int i = 0; i < columnLength; i++) {
                            buff1[rowIndex][i] = matrix[pr1][i];
                        }
                        pr1++;
                    }
                }
            }
            char[][] buff2 = new char[rowLength][columnLength];
            int pr2 = 0;
            HashSet<Integer> processedIndexes2 = new HashSet<>();
            for (char column : columnKey.toCharArray()) {
                for (int columnIndex = 0; columnIndex < columnKey.length(); columnIndex++) {
                    if (column == columnKey.charAt(columnIndex) && !processedIndexes2.contains(columnIndex)) {
                        processedIndexes2.add(columnIndex);
                        for (int i = 0; i < rowLength; i++) {
                            buff2[i][columnIndex] = buff1[i][pr2];
                        }
                        pr2++;
                    }
                }
            }
            for (int i = 0; i < columnLength; i++) {
                for (int j = 0; j < rowLength; j++) {
                    decodeText.append(buff2[j][i]);
                }
            }
        }
        return decodeText.toString().replaceAll("\0", "");
    }
}
