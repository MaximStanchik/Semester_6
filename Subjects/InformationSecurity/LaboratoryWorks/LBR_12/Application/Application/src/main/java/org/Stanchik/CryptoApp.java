package org.Stanchik;

import java.math.BigInteger;

public class CryptoApp {
    public static void main(String[] args) {
        Schnorr schnorr = new Schnorr();
        RSA rsa = new RSA();
        ElGamal elGamal = new ElGamal();

        Object[] algorithms = {rsa, elGamal, schnorr};


        String plainText = "Maxim Stanchik Andreevich";
        System.out.println("Текст: " + plainText);

        for (int algo = 0; algo < algorithms.length; algo++) {
            System.out.println("----------------------------------------------------------------------------------------------------------------");
            System.out.println("Используемый алгоритм: " + algorithms[algo]);
            BigInteger[] publicKey = schnorr.getPublicKey();
            System.out.println("Публичный ключ: ");
            for (int k = 0; k < publicKey.length; k++) {
                System.out.println(publicKey[k]);
            }

            long startTime = System.nanoTime();
            BigInteger[] digitalSign = schnorr.createDigitalSignature(plainText);
            long endTime = System.nanoTime();
            System.out.println("Цифровая подпись: ");
            for (int k = 0; k < digitalSign.length; k++) {
                System.out.println(digitalSign[k]);
            }
            System.out.println("Время генерации цифровой подписи: " + (endTime - startTime) + " нс");


            startTime = System.nanoTime();
            boolean verified = schnorr.verifyDigitalSignature(plainText, digitalSign);
            endTime = System.nanoTime();
            System.out.println("Подпись достоверна? " + verified);
            System.out.println("Время проверки цифровой подписи: " + (endTime - startTime) + " нс");
        }


    }
}
