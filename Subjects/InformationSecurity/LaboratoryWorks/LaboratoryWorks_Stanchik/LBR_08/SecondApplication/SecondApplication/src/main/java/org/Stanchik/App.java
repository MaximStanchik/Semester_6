package org.Stanchik;

public class App 
{
    public static void main( String[] args )
    {
        RC4Encrypt rc4 = new RC4Encrypt();

        String data = "Maxim Stanchik";
        int key[] = {15, 14, 13, 12, 11, 10};

        long encrStartTime = System.nanoTime();
        String encryptedData = rc4.process(data, key);
        long encrEndTime = System.nanoTime();
        System.out.println("Зашифрованный текст: " + encryptedData);
        System.out.println("Время шифрования текста: " + (encrEndTime - encrStartTime) + " нс");

        System.out.println();

        long decrStartTime = System.nanoTime();
        String decryptedData = rc4.process(encryptedData, key);
        long decrEndTime = System.nanoTime();
        System.out.println("Расшифрованный текст: " + decryptedData);
        System.out.println("Время расшифрования текста: " + (decrEndTime - decrStartTime) + " нc");
    }
}
