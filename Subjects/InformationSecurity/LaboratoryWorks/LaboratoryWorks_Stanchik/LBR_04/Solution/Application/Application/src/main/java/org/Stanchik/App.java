package org.Stanchik;

import org.Stanchik.EncryptAndDecrypt.CaesarsCipher;
import org.Stanchik.EncryptAndDecrypt.PortCipher;

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

    public static void main( String[] args )
    {

        System.out.println("// ---------- Вариант 10 ---------- //");

        String polishTextfilePath = "text/polish.txt";
        String polishText = readFile(polishTextfilePath);
        String polishAlphabet = "AĄBCĆDEĘFGHIJKLŁMNŃOÓPQRSŚTUVWXYŹŻaąbcćdeęfghijklłmnńoópqrsśtuwvxyzźż .,!?";
        int polishAlphabetPower = polishAlphabet.length();
        int secretKey = 28;

        CaesarsCipher encryptAndDecrypt = new CaesarsCipher();
        PortCipher portCipher = new PortCipher();

        long startTimeEncryptCaesars = System.currentTimeMillis();
        String encryptedTextCaesers = encryptAndDecrypt.caesarEncrypt(polishText, secretKey, polishAlphabet, polishAlphabetPower);
        long endTimeEncryptCaesars = System.currentTimeMillis();
        long durationEncryptCaesers = endTimeEncryptCaesars - startTimeEncryptCaesars;
        System.out.println("Encrypted text: " + encryptedTextCaesers);
        System.out.println("Encryption time: " + durationEncryptCaesers + " ms");

        long startTimeDecryptCaesars = System.currentTimeMillis();
        String decryptedTextCaesers = encryptAndDecrypt.caesarDecrypt(encryptedTextCaesers, secretKey, polishAlphabet, polishAlphabetPower);
        long endTimeDecryptCaesers = System.currentTimeMillis();
        long durationDecryptCaesers = endTimeDecryptCaesers - startTimeDecryptCaesars;
        System.out.println("Decrypted text: " + decryptedTextCaesers);
        System.out.println("Decryption time: " + durationDecryptCaesers + " ms");

        long startTimeEncryptPort = System.currentTimeMillis();
        String portCipherEncryptedText = portCipher.portCipherEncrypt(polishText, polishAlphabet, polishAlphabetPower);
        long endTimeEncryptPort = System.currentTimeMillis();
        long durationEncryptPort = endTimeEncryptPort - startTimeEncryptPort;
        System.out.println("Encrypted text: " + portCipherEncryptedText);
        System.out.println("Encryption time: " + durationEncryptPort + " ms");

        long startTimeDecryptPort = System.currentTimeMillis();
        String portCipherDecryptedText = portCipher.portCipherDecrypt(portCipherEncryptedText, polishAlphabet, polishAlphabetPower);
        long endTimeDecryptPort = System.currentTimeMillis();
        long durationDecryptPort = endTimeDecryptPort - startTimeDecryptPort;
        System.out.println("Decrypted text: " + portCipherDecryptedText);
        System.out.println("Decryption time: " + durationDecryptPort + " ms");

        Frequences frequences = new Frequences();
        Map<Character, Double> encryptedTextProbabilitiesCaesers = frequences.calculateProbabilities(encryptedTextCaesers);
        Map<Character, Double> decryptedTextProbabilitiesCaesers = frequences.calculateProbabilities(decryptedTextCaesers);
        Map<Character, Double> encryptedTextProbabilitiesPort = frequences.calculateProbabilities(portCipherEncryptedText);
        Map<Character, Double> decryptedTextProbabilitiesPort = frequences.calculateProbabilities(portCipherDecryptedText);

        frequences.saveFrequenciesToExcel(encryptedTextProbabilitiesCaesers, "schemes/encryptedPolishTextCaesers.xlsx");
        frequences.saveFrequenciesToExcel(decryptedTextProbabilitiesCaesers, "schemes/decryptedPolishTextCaesers.xlsx");
        frequences.saveHistogramToExcel(encryptedTextProbabilitiesCaesers,"schemes/encryptedPolishTextCaesers.xlsx");
        frequences.saveHistogramToExcel(decryptedTextProbabilitiesCaesers, "schemes/decryptedPolishTextCaesers.xlsx");

        frequences.saveFrequenciesToExcel(encryptedTextProbabilitiesPort, "schemes/encryptedPolishTextPort.xlsx");
        frequences.saveFrequenciesToExcel(decryptedTextProbabilitiesPort, "schemes/decryptedPolishTextPort.xlsx");
        frequences.saveHistogramToExcel(encryptedTextProbabilitiesPort,"schemes/encryptedPolishTextPort.xlsx");
        frequences.saveHistogramToExcel(decryptedTextProbabilitiesPort, "schemes/decryptedPolishTextPort.xlsx");

    }
}
