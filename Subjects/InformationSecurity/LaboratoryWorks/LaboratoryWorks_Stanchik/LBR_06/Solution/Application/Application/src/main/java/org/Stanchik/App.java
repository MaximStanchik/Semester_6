package org.Stanchik;

import static java.lang.String.valueOf;

public class App {
    static Frequences frequences = new Frequences();
    public static char[] processMessage(int rightRotorPosition, int middleRotorPosition, int leftRotorPosition, char[] text, Operation operation) {
        Enigma enigmaObj = new Enigma(rightRotorPosition, middleRotorPosition, leftRotorPosition);
        long startTime = System.nanoTime();
        char[] resultMessage;

        if (operation == Operation.ENCRYPT) {
            resultMessage = enigmaObj.Encrypt(text);
            System.out.println("Время шифрования: " + (System.nanoTime() - startTime) + " нс");
            System.out.println("Зашифрованный текст: " + valueOf(resultMessage));
        }
        else {
            resultMessage = enigmaObj.Decrypt(text);
            System.out.println("Время расшифровки: " + (System.nanoTime() - startTime) + " нс");
            System.out.println("Расшифрованный текст: " + valueOf(resultMessage));
        }

        return resultMessage;
    }

    public static void saveFrequenciesAndHistograms(char[] encryptedText, char[] decryptedText, int variantIndex) {
        String encryptedFilePath = "schemes/encrypted/encryptedTextVariant" + variantIndex + ".xlsx";
        String decryptedFilePath = "schemes/decrypted/decryptedTextVariant" + variantIndex + ".xlsx";

        frequences.saveFrequenciesToExcel(frequences.calculateProbabilities(encryptedText), encryptedFilePath);
        frequences.saveHistogramToExcel(frequences.calculateProbabilities(encryptedText), encryptedFilePath);
        frequences.saveFrequenciesToExcel(frequences.calculateProbabilities(decryptedText), decryptedFilePath);
        frequences.saveHistogramToExcel(frequences.calculateProbabilities(decryptedText), decryptedFilePath);
    }
    public static void main(String[] args) {

        String NSP = "AA";

        int[][] rotorPositions = {
                {0, 0, 0},
                {0, 1, 0},
                {0, 0, 1},
                {0, 1, 1},
                {1, 1, 0}
        };

        for (int i = 0; i < rotorPositions.length; i++) {
            int right = rotorPositions[i][0];
            int middle = rotorPositions[i][1];
            int left = rotorPositions[i][2];

            System.out.println("Вариант " + (i + 1) + " начальных установок роторов (" + right + ", " + middle + ", " + left + "): ");
            char[] encryptedText = processMessage(right, middle, left, NSP.toCharArray(), Operation.ENCRYPT);
            char[] decryptedText = processMessage(right, middle, left, encryptedText, Operation.DECRYPT);

            saveFrequenciesAndHistograms(encryptedText, decryptedText, i);
        }
    }
}

