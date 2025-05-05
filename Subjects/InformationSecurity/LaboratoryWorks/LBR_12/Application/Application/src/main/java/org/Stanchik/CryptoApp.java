package org.Stanchik;

import java.util.Scanner;
public class CryptoApp {

    public static final String[] hashAlgorithms = {
            "SHA3-256",
            "MD5"
    };

    public static void main(String[] args) {
        HashGeneration hashGeneration = new HashGeneration();
        Scanner console = new Scanner(System.in);

        System.out.println("Введите сообщение, на основе которого необходимо генерировать хэш: ");
        String plaintext = console.nextLine();

        if (plaintext.isEmpty()) {
            System.out.println("Необходимо ввести сообщение");
        }

        System.out.println("Введите соль, которая будет использоваться при хэшировании: ");
        String salt = console.nextLine();

        if (salt.isEmpty()) {
            System.out.println("Необходимо ввести соль");
        }

        System.out.println("Введите размер соли. Соль будет автоматически сгенерирована и использована при генерации хэша");
        int saltSize = Integer.parseInt(console.nextLine());

        if (salt.isEmpty()) {
            System.out.println("Необходимо ввести размер соли");
        }

        else {
            for (int i = 0; i < hashAlgorithms.length; i ++) {
                System.out.println("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
                System.out.println("Используемый алгоритм: " + hashAlgorithms[i]);

                long startTime = System.nanoTime();
                String hashedValue_0 = hashGeneration.generateHash(plaintext, hashAlgorithms[i]);
                long endTime = System.nanoTime();

                System.out.println("Хэш без использования соли: " + hashedValue_0);
                System.out.println("Размер хэша: " + (hashedValue_0.length() / 2));
                System.out.println("Время генерации хэша: " + (endTime - startTime) + " нс.");

                startTime = System.nanoTime();
                String hashedValue_1 = hashGeneration.generateHash(plaintext, hashAlgorithms[i], salt);
                endTime = System.nanoTime();

                System.out.println("Хэш с использованием соли, введенной с консоли: " + hashedValue_1);
                System.out.println("Размер хэша: " + (hashedValue_1.length() /2));
                System.out.println("Время генерации хэша: " + (endTime - startTime) + " нс.");

                startTime = System.nanoTime();
                String hashedValue_2 = hashGeneration.generateHash(plaintext, hashAlgorithms[i], hashGeneration.createSalt(saltSize));
                endTime = System.nanoTime();

                System.out.println("Хэш с использованием соли, сгенерированной с помощью метода: " + hashedValue_2);
                System.out.println("Размер хэша: " + (hashedValue_2.length() / 2 ));
                System.out.println("Время генерации хэша: " + (endTime - startTime) + " нс.");
            }
        }
    }
}