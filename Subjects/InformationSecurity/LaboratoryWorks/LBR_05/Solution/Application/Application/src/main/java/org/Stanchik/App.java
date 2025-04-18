package org.Stanchik;

import org.Stanchik.EncryptAndDecrypt.MultiplePermutation;
import org.Stanchik.EncryptAndDecrypt.RouteRearrangement;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Map;

public class App
{
    public static String readFile (String filePath) {
        String content = "";
        try {
            content = new String(Files.readAllBytes(Paths.get(filePath)), "UTF-8");
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        return content;
    }
    public static long measureExecutionTime(Runnable method) {
        long startTime = System.nanoTime();
        method.run();
        long endTime = System.nanoTime();
        return endTime - startTime;
    }

    public static void main( String[] args ) throws IOException {
        System.out.println("// ---------- Вариант 10 ---------- //");

        String name = "Maxim";
        String surname = "Stanchik";

        String polishTextfilePath = "text/polish.txt";
        String polishText = readFile(polishTextfilePath);

        RouteRearrangement routeRear = new RouteRearrangement();
        MultiplePermutation multPerm = new MultiplePermutation();
        Frequences frequences = new Frequences();

        long startTimeEncryptRouteRear = System.nanoTime();
        String encryptedText = routeRear.encryptRouteSwap(50, 50, polishText);
        long endTimeEncryptRouteRear = System.nanoTime();
        long durationEncryptRouteRear = endTimeEncryptRouteRear - startTimeEncryptRouteRear;
        System.out.println("Зашифрованный текст: " + encryptedText);

        long startTimeDecryptRouteRear = System.nanoTime();
        String decryptedText = routeRear.decryptRouteSwap(50, 50, encryptedText);;
        long endTimeDecryptRouteRear = System.nanoTime();
        long durationDecryptRouteRear = endTimeDecryptRouteRear - startTimeDecryptRouteRear;
        System.out.println("Расшифрованный текст: " + decryptedText);

        frequences.saveFrequenciesToExcel(frequences.calculateProbabilities(encryptedText), "schemes/encryptedPolishTextMultPerm.xlsx");
        frequences.saveFrequenciesToExcel(frequences.calculateProbabilities(decryptedText), "schemes/decryptedPolishTextMultPerm.xlsx");
        frequences.saveHistogramToExcel(frequences.calculateProbabilities(encryptedText),"schemes/encryptedPolishTextMultPerm.xlsx");
        frequences.saveHistogramToExcel(frequences.calculateProbabilities(decryptedText), "schemes/decryptedPolishTextMultPerm.xlsx");

        long startTimeEncrypt = System.currentTimeMillis();
        encryptedText = multPerm.encodeMultiple(polishText, name, surname);
        long endTimeEncrypt = System.currentTimeMillis();
        long durationEncrypt = endTimeEncrypt - startTimeEncrypt;

        System.out.println("Зашифрованный текст: " + encryptedText);

        long startTimeDecrypt = System.currentTimeMillis();
        decryptedText = multPerm.decodeMultiple(encryptedText, name, surname);
        long endTimeDecrypt = System.currentTimeMillis();
        long durationDecrypt = endTimeDecrypt - startTimeDecrypt;

        System.out.println("Расшифрованный текст: " + decryptedText);
        System.out.println("-------------------------------------------------------------------------");
        System.out.println("Время шифрования (маршрутная перестановка): " + durationEncryptRouteRear + " ns");
        System.out.println("Время расшифрования (маршрутная перестановка): " + durationDecryptRouteRear + " ns");
        System.out.println("Время шифрования (множественная перестановка): " + durationEncrypt + " ms");
        System.out.println("Время расшифрования (множественная перестановка): " + durationDecrypt + " ms");

        frequences.saveFrequenciesToExcel(frequences.calculateProbabilities(encryptedText), "schemes/encryptedPolishTextRouteRear.xlsx");
        frequences.saveFrequenciesToExcel(frequences.calculateProbabilities(decryptedText), "schemes/decryptedPolishTextRouteRear.xlsx");
        frequences.saveHistogramToExcel(frequences.calculateProbabilities(encryptedText),"schemes/encryptedPolishTextRouteRear.xlsx");
        frequences.saveHistogramToExcel(frequences.calculateProbabilities(decryptedText), "schemes/decryptedPolishTextRouteRear.xlsx");

    }
}
