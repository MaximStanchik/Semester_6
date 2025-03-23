package org.Stanchik;
import java.util.Map;

public class App
{
    public static void main( String[] args )
    {
        EntropyCalculator entrCalc = new EntropyCalculator();

        System.out.println();
        System.out.println("//-------------------------------------- а --------------------------------------//");
        System.out.println();

        String spanishAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz";
        String serbianAlphabet =  "АБВГДЂЕЖЗИЈКЛЉМНЊОПРСТЋУФХЦЧЏШабвгдЂежзијклљмнњопрстћуфхцчџш";

        String spanishTextfilePath = "text/fishtextInSpanish.txt";
        String serbianTextfilePath = "text/fishtextInSerbian.txt";
        String spanishTextfile = entrCalc.readFile(spanishTextfilePath);
        String serbianTextfile = entrCalc.readFile(serbianTextfilePath);

        Map<Character, Double> spanishAlphabetProbabilities = entrCalc.calculateProbabilities(spanishAlphabet);
        Map<Character, Double> serbianAlphabetProbabilities = entrCalc.calculateProbabilities(serbianAlphabet);
        Map<Character, Double> spanishTextfileProbabilities = entrCalc.calculateProbabilities(spanishTextfile);
        Map<Character, Double> serbianTextfileProbabilities = entrCalc.calculateProbabilities(serbianTextfile);

        double entropyOfTheSpanishAlphabet = entrCalc.calculateEntropy (spanishAlphabetProbabilities);
        double entropyOfTheSerbianAlphabet = entrCalc.calculateEntropy (serbianAlphabetProbabilities);
        double entropyOfTheSpanishTextfile = entrCalc.calculateEntropy (spanishTextfileProbabilities);
        double entropyOfTheSerbianTextfile = entrCalc.calculateEntropy (serbianTextfileProbabilities);

        System.out.println("Энтропия испанского алфавита: " + entropyOfTheSpanishAlphabet);
        System.out.println("Энтропия сербского алфавита: " + entropyOfTheSerbianAlphabet);
        System.out.println("Энтропия текста на испанском: " + entropyOfTheSpanishTextfile);
        System.out.println("Энтропия текста на сербском: " + entropyOfTheSerbianTextfile);

        entrCalc.saveFrequenciesToExcel(spanishAlphabetProbabilities, "schemes/spanish_frequencies.xlsx");
        entrCalc.saveFrequenciesToExcel(serbianAlphabetProbabilities, "schemes/serbian_frequencies.xlsx");
        entrCalc.saveFrequenciesToExcel(spanishTextfileProbabilities, "schemes/spanish_text_frequencies.xlsx");
        entrCalc.saveFrequenciesToExcel(serbianTextfileProbabilities, "schemes/serbian_text_frequencies.xlsx");

        entrCalc.saveHistogramToExcel(spanishTextfileProbabilities,"schemes/spanish_frequencies.xlsx");
        entrCalc.saveHistogramToExcel(spanishTextfileProbabilities,"schemes/serbian_frequencies.xlsx");
        entrCalc.saveHistogramToExcel(spanishTextfileProbabilities,"schemes/spanish_text_frequencies.xlsx");
        entrCalc.saveHistogramToExcel(serbianTextfileProbabilities,"schemes/serbian_text_frequencies.xlsx");

        System.out.println();
        System.out.println("//-------------------------------------- б --------------------------------------//");
        System.out.println();

        String binaryTextfilePath = "text/binaryText.txt";
        String binaryTextfile = entrCalc.readFile(binaryTextfilePath);
        int[] binaryTextfileCounts = entrCalc.countZerosAndOnes(binaryTextfile);
        double entropyOfTheBinaryAlphabet = entrCalc.calculateBinaryEntropy(binaryTextfileCounts[0], binaryTextfileCounts[1]);
        System.out.println("Энтропия бинарного алфавита в документе: " + entropyOfTheBinaryAlphabet);

        System.out.println();
        System.out.println("//-------------------------------------- в --------------------------------------//");
        System.out.println();

        String serbianFIO = "Станчик Максим Андрејевић";
        String spanishFIO = "Stanchik Maxim Andreyevich";

        int lengthSerbianFIO = serbianFIO.length();
        int lengthSpanishFIO = spanishFIO.length();

        double informationSerbian = entropyOfTheSerbianAlphabet * lengthSerbianFIO;
        double informationSpanish = entropyOfTheSpanishAlphabet * lengthSpanishFIO;

        System.out.println("Количество информации для сербского ФИО: " + informationSerbian);
        System.out.println("Количество информации для испанского ФИО: " + informationSpanish);

        String ASCIIFIO = "11010001 11110010 11100000 11101101 11110111 11101000 11101010 11001100 11100000 11101010 11110001 11101000 11101100 110000000 11101101 11100100 11110000 11100101 11100101 11100010 11101000 11110111";
        int lengthASCIIFIO = ASCIIFIO.length();
        int[] ASCIIFIOCount = entrCalc.countZerosAndOnes(ASCIIFIO);
        double entropyOfTheASCIIFIO = entrCalc.calculateBinaryEntropy(ASCIIFIOCount[0], ASCIIFIOCount[1]);

        double informationASCII = entropyOfTheASCIIFIO * lengthASCIIFIO;

        System.out.println("Количество информации для ФИО в ASCII в двоичном виде: " + informationASCII);

        System.out.println();
        System.out.println("//-------------------------------------- г --------------------------------------//");
        System.out.println();

        double[] errorProbabilities = {0.1, 0.5, 1.0};

        for (double Pe : errorProbabilities) {
            double entropySerbian = entrCalc.calculateEntropy(entrCalc.calculateProbabilities(serbianFIO));
            double entropySpanish = entrCalc.calculateEntropy(entrCalc.calculateProbabilities(spanishFIO));
            double entropyASCII = entrCalc.calculateBinaryEntropy(entrCalc.countZerosAndOnes(ASCIIFIO)[0], entrCalc.countZerosAndOnes(ASCIIFIO)[1]);

            double effectiveEntropySerbian = entrCalc.getEffectiveEntropy(serbianFIO, Pe);
            double effectiveEntropySpanish = entrCalc.getEffectiveEntropy(spanishFIO, Pe);
            double effectiveEntropyASCII = entrCalc.getEffectiveEntropy(ASCIIFIO, Pe);

            informationSerbian = entrCalc.getInformationAmount(entropySerbian, serbianFIO, effectiveEntropySerbian);
            informationSpanish = entrCalc.getInformationAmount(entropySpanish, spanishFIO, effectiveEntropySpanish);
            informationASCII = entrCalc.getInformationAmount(entropyASCII, ASCIIFIO, effectiveEntropyASCII);

            System.out.printf("Количество информации для сербского ФИО при вероятности ошибки = %.1f: %.10f%n", Pe, informationSerbian);
            System.out.printf("Количество информации для испанского ФИО при вероятности ошибки = %.1f: %.10f%n", Pe, informationSpanish);
            System.out.printf("Количество информации для ФИО в ASCII при вероятности ошибки = %.1f: %.10f%n", Pe, informationASCII);
        }
    }
}
