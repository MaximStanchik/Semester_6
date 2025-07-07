package org.Stanchik;
import org.Stanchik.DES_EDE2.DES_EDE2;
import org.Stanchik.DES_EDE2.Operation;
import java.io.UnsupportedEncodingException;

public class App
{
    static DES_EDE2 DES_EDE2 = new DES_EDE2();
    public static String processMessage(String text, byte[] firstKey, byte[] secondKey, Operation operation) throws UnsupportedEncodingException {
        long startTime = System.nanoTime();

        if (operation == Operation.ENCRYPT) {
            text = DES_EDE2.encryptMes(firstKey, secondKey, text);
            System.out.println("Время шифрования: " + (System.nanoTime() - startTime) + " нс");
            System.out.println("Зашифрованный текст: " + text);
            System.out.println("// ---------------------------------------- //");
        }
        else {
            text = DES_EDE2.decryptMes(firstKey, secondKey, text);
            System.out.println("Время расшифровки: " + (System.nanoTime() - startTime) + " нс");
            System.out.println("Расшифрованный текст: " + text);
            System.out.println("// ---------------------------------------- //");
        }

        return text;
    }

    public static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X ", b));
        }
        return sb.toString().trim();
    }
    public static void main( String[] args ) throws UnsupportedEncodingException {
        System.out.println("// ---------------------------------------- //");
        String originalText = "Hello everyone, I'm Maxim Stanchik Andreevich! I hope I will pass this lab work with excellent marks";
        System.out.println("Изначальное сообщение: " + originalText);
        System.out.println("// ---------------------------------------- //");

        byte[] firstKey = "11111111".getBytes();
        byte[] secondKey = "11111122".getBytes();

        System.out.println("Первый ключ: " + bytesToHex(firstKey));
        System.out.println("Второй ключ: " + bytesToHex(secondKey));
        System.out.println("// ---------------------------------------- //");

        String encryptedText = processMessage(originalText, firstKey, secondKey, Operation.ENCRYPT);
        String decryptedText = processMessage(encryptedText, firstKey, secondKey, Operation.DECRYPT);

    }
}
