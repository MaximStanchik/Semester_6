package org.Stanchik.EncryptAndDecrypt;

public class CaesarsCipher {
    public static String caesarEncrypt(String message, int secretKey, String alphabet, int alphabetPower) {
        StringBuilder encryptedMessage = new StringBuilder();

        for (char character : message.toCharArray()) {
            int index = alphabet.indexOf(character);
            if (index != -1) {
                int encryptedIndex = (index + secretKey) % alphabetPower;
                encryptedMessage.append(alphabet.charAt(encryptedIndex));
            }
            else {
                System.out.println("Символ " + character + " не найден в алфавите, добавили без изменений");
                encryptedMessage.append(character);
            }
        }

        return encryptedMessage.toString();
    }

    public static String caesarDecrypt(String encryptedMessage, int key, String alphabet, int alphabetPower) {
        StringBuilder decryptedMessage = new StringBuilder();

        for (char character : encryptedMessage.toCharArray()) {
            int index = alphabet.indexOf(character);
            if (index != -1) {
                int decryptedIndex = (index - key + alphabetPower) % alphabetPower;
                decryptedMessage.append(alphabet.charAt(decryptedIndex));
            }
            else {
                System.out.println("Символ " + character + " не найден в алфавите, добавили без изменений");
                decryptedMessage.append(character);
            }
        }

        return decryptedMessage.toString();
    }
}
