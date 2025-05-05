package org.Stanchik;

import java.math.BigInteger;
import java.util.Base64;
import java.util.Random;

public class NumberUtils {
    public static String base64Encode(String text) {
        return Base64.getEncoder().encodeToString(text.getBytes());
    }
    static final String BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    public static BigInteger gcd(BigInteger a, BigInteger b) {
        while (!b.equals(BigInteger.ZERO)) {
            BigInteger temp = b;
            b = a.mod(b);
            a = temp;
        }
        return a;
    }

    public static BigInteger getInverseNumber(BigInteger number, BigInteger modulus) {
        BigInteger m0 = modulus;
        BigInteger y = BigInteger.ZERO;
        BigInteger x = BigInteger.ONE;

        if (modulus.equals(BigInteger.ONE)) {
            return BigInteger.ZERO;
        }

        while (number.compareTo(BigInteger.ONE) > 0) {
            BigInteger quotient = number.divide(modulus);
            BigInteger temp = modulus;

            modulus = number.mod(modulus);
            number = temp;

            temp = y;
            y = x.subtract(quotient.multiply(y));
            x = temp;
        }

        if (x.compareTo(BigInteger.ZERO) < 0) {
            x = x.add(m0);
        }

        return x;
    }

    public static BigInteger generateCoprime(BigInteger n) {
        BigInteger min = n.add(BigInteger.ONE);
        BigInteger max = n.multiply(BigInteger.TWO);
        BigInteger coprime;
        Random random = new Random();

        do {
            coprime = getRandomBetween(min, max, random);
        } while (!gcd(n, coprime).equals(BigInteger.ONE));

        return coprime;
    }
    private static BigInteger getRandomBetween(BigInteger min, BigInteger max, Random random) {
        BigInteger range = max.subtract(min);
        BigInteger randomValue = new BigInteger(range.bitLength(), random);
        return min.add(randomValue.mod(range.add(BigInteger.ONE)));
    }
    public static String convertBase64ToBinary(String base64String) {
        StringBuilder binaryString = new StringBuilder();

        for (int i = 0; i < base64String.length(); i++) {
            char base64Char = base64String.charAt(i);
            if (base64Char == '=') {
                binaryString.append("000000");
            } else {
                int index = BASE64_CHARS.indexOf(base64Char);
                String charBinary = Integer.toBinaryString(index);
                charBinary = String.format("%6s", charBinary).replace(' ', '0');
                binaryString.append(charBinary);
            }
        }

        return binaryString.toString();
    }
    public static byte[] binaryStringToByteArray(String binaryString) {
        int byteCount = (binaryString.length() + 7) / 8;
        byte[] bytes = new byte[byteCount];

        for (int i = 0; i < byteCount; i++) {
            int startIndex = i * 8;
            int endIndex = Math.min(startIndex + 8, binaryString.length());
            String byteString = binaryString.substring(startIndex, endIndex);

            while (byteString.length() < 8) {
                byteString = "0" + byteString;
            }

            bytes[i] = (byte) Integer.parseInt(byteString, 2);
        }

        return bytes;
    }
}
