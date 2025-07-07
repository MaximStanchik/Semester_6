package org.Stanchik;

import java.math.BigInteger;
import java.util.List;

enum Encoding {
    ASCII,
    BASE64
}
public class App
{
    public static void main( String[] args )
    {
        CryptographyUtils cryptographyUtils = new CryptographyUtils();
        NumberUtils numberUtils = new NumberUtils();

        System.out.println("----------------------------------------ASCII----------------------------------------");
        long startTimePrivateKeyGenASCII = System.nanoTime();
        List<BigInteger> privateKeyASCII = cryptographyUtils.generatePrivateKey(cryptographyUtils.generateRandomNumber(100), 8);
        long endTimePrivateKeyGenASCII = System.nanoTime();
        System.out.println("Сгенерированный приватный ключ (для кодов ASCII): " + privateKeyASCII);
        System.out.println("Время генерации приватного ключа ASCII: " + (endTimePrivateKeyGenASCII - startTimePrivateKeyGenASCII) + " нс");


        BigInteger[] keyParamsASCII = cryptographyUtils.getPublicKeyParams(privateKeyASCII);
        System.out.println("Параметры приватного ключа: " + keyParamsASCII[0] + ", " + keyParamsASCII[1]);
        long startPublicTimeKeyGenASCII = System.nanoTime();
        List<BigInteger> publicKeyASCII = cryptographyUtils.generatePublicKey(privateKeyASCII, keyParamsASCII[0], keyParamsASCII[1]);
        long endPublicTimeKeyGenASCII = System.nanoTime();
        System.out.println("Сгенерированный публичный ключ (для кодов ASCII): " + publicKeyASCII);
        System.out.println("Время генерации публичного ключа ASCII: " + (endPublicTimeKeyGenASCII - startPublicTimeKeyGenASCII) + " нс");

        System.out.println("");

        System.out.println("----------------------------------------Base64----------------------------------------");
        long startPrivateTimeKeyGenBase64 = System.nanoTime();
        List<BigInteger> privateKeyBase64 = cryptographyUtils.generatePrivateKey(cryptographyUtils.generateRandomNumber(100), 6);
        long endPrivateTimeKeyGenBase64 = System.nanoTime();
        System.out.println("Сгенерированный приватный ключ (для кодов Base64): " + privateKeyBase64);
        System.out.println("Время генерации приватного ключа Base64: " + (endPrivateTimeKeyGenBase64 - startPrivateTimeKeyGenBase64) + " нс");

        BigInteger[] keyParamsBase64 = cryptographyUtils.getPublicKeyParams(privateKeyBase64);
        System.out.println("Параметры приватного ключа: " + keyParamsBase64[0] + ", " + keyParamsBase64[1]);
        long startPublicTimeKeyGenBase64 = System.nanoTime();
        List<BigInteger> publicKeyBase64 = cryptographyUtils.generatePublicKey(privateKeyBase64, keyParamsBase64[0], keyParamsBase64[1]);
        long endPublicTimeKeyGenBase64 = System.nanoTime();
        System.out.println("Сгенерированный публичный ключ (для кодов Base64): " + publicKeyBase64);
        System.out.println("Время генерации публичного ключа Base64: " + (endPublicTimeKeyGenBase64 - startPublicTimeKeyGenBase64) + " нс");

        System.out.println("");

        System.out.println("----------------------------------------Шифрование и расшифрование ФИО в ASCII----------------------------------------");

        String FIO_ASCII = "Stanchik Maxim Andreevich";
        System.out.println("ФИО в ASCII: " + FIO_ASCII);

        long startTimeEncrypt_ASCII = System.nanoTime();
        List<BigInteger> encryptedFIO_ASCII = cryptographyUtils.encrypt(publicKeyASCII, FIO_ASCII, Encoding.ASCII);
        long endTimeEncrypt_ASCII = System.nanoTime();
        System.out.println("Зашифрованный текст: " + encryptedFIO_ASCII);

        System.out.println("Время шифрования ФИО: " + (endTimeEncrypt_ASCII - startTimeEncrypt_ASCII) + " нс");

        long startTimeDecrypt_ASCII = System.nanoTime();
        Object[] decryptedFIO_ASCII = cryptographyUtils.decrypt(privateKeyASCII, encryptedFIO_ASCII, keyParamsASCII[0], keyParamsASCII[1]);
        long endTimeDecrypt_ASCII = System.nanoTime();

        byte[] decodedBytes = (byte[]) decryptedFIO_ASCII[0];
        String binaryString = (String) decryptedFIO_ASCII[1];

        String decryptedText = new String(decodedBytes, java.nio.charset.StandardCharsets.UTF_8);
        System.out.println("Расшифрованный текст: " + decryptedText);
        System.out.println("Двоичная строка: " + binaryString);
        System.out.println("Время расшифрования ФИО: " + (endTimeDecrypt_ASCII - startTimeDecrypt_ASCII) + " нс");

        System.out.println("");

        System.out.println("----------------------------------------Шифрование и расшифрование ФИО в Base64----------------------------------------");

        String FIO_base64 = numberUtils.base64Encode(FIO_ASCII);
        System.out.println("ФИО в base64: " + FIO_base64);

        long startTimeEncrypt_Base64 = System.nanoTime();
        List<BigInteger> encryptedFIO_Base64 = cryptographyUtils.encrypt(publicKeyBase64, FIO_base64, Encoding.BASE64);
        long endTimeEncrypt_Base64 = System.nanoTime();

        System.out.println("Зашифрованный текст: " + encryptedFIO_Base64);
        System.out.println("Время шифрования ФИО: " + (endTimeEncrypt_Base64 - startTimeEncrypt_Base64) + " нс");

        long startTimeDecrypt_Base64 = System.nanoTime();
        Object[] decryptedFIO_Base64 = cryptographyUtils.decrypt(privateKeyBase64, encryptedFIO_Base64, keyParamsBase64[0], keyParamsBase64[1]);
        long endTimeDecrypt_Base64 = System.nanoTime();

        byte[] decodedBytes_base64 = (byte[]) decryptedFIO_Base64[0];
        String binaryString_base64 = (String) decryptedFIO_Base64[1];

        String decryptedText_base64 = new String(decodedBytes_base64, java.nio.charset.StandardCharsets.UTF_8);
        System.out.println("Расшифрованный текст: " + decryptedText_base64);
        System.out.println("Двоичная строка: " + binaryString_base64);
        System.out.println("Время расшифрования ФИО: " + (endTimeDecrypt_Base64 - startTimeDecrypt_Base64) + " нс");
    }
}
