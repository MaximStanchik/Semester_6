package org.Stanchik.EncryptAndDecrypt;

public class PortCipher {
    public static String portCipherEncrypt(String text, String alphabet, int alphabetLength) {
        if (text.length() % 2 != 0) {
            text += "А";
        }

        StringBuilder encryptedText = new StringBuilder();

        for (int i = 0; i < text.length(); i += 2) {
            char firstChar = text.charAt(i);
            char secondChar = text.charAt(i + 1);
            int row = alphabet.indexOf(firstChar);
            int col = alphabet.indexOf(secondChar);

            if (row != -1 && col != -1) {
                int encryptedIndex = row * alphabetLength + col + 1;
                encryptedText.append(String.format("%03d ", encryptedIndex));
            }
        }

        return encryptedText.toString().trim();
    }

    public static String portCipherDecrypt(String encryptedText, String alphabet, int alphabetLength) {
        StringBuilder decryptedText = new StringBuilder();
        String[] indices = encryptedText.split(" ");

        for (String indexStr : indices) {
            int index = Integer.parseInt(indexStr) - 1;
            int row = index / alphabetLength;
            int col = index % alphabetLength;
            decryptedText.append(alphabet.charAt(row)).append(alphabet.charAt(col));
        }

        return decryptedText.toString();
    }

}
