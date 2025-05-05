package org.Stanchik;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import static org.Stanchik.NumberUtils.*;

public class CryptographyUtils {
    public static List<BigInteger> generatePrivateKey (BigInteger initialNumber, int z) {
        List<BigInteger> sequence = new ArrayList<>();
        BigInteger element = initialNumber;
        BigInteger sum = initialNumber;

        for (int i = 0; i < z; i++) {
            sequence.add(element);
            element = sum.add(BigInteger.valueOf(z));
            sum = sum.add(element);
        }

        return sequence;
    }
    public static BigInteger generateRandomNumber(int n) {
        StringBuilder randomBits = new StringBuilder();
        Random random = new Random();

        for (int i = 0; i < n; i++) {
            int bit = random.nextInt(2);
            randomBits.append(bit);
        }

        return new BigInteger(randomBits.toString(), 2);
    }
    public static List<BigInteger> encrypt(List<BigInteger> publicKey, String plaintext, Encoding encoding) {
        List<BigInteger> encryptedList = new ArrayList<>();

        if (encoding == Encoding.BASE64) {
            plaintext = base64Encode(plaintext);
        }

        for (int index = 0; index < plaintext.length(); index++) {
            char b = plaintext.charAt(index);
            String binaryString;

            if (encoding == Encoding.ASCII) {
                binaryString = String.format("%8s", Integer.toBinaryString(b)).replace(' ', '0');
            } else {
                binaryString = convertBase64ToBinary(String.valueOf(b));
            }

            List<Integer> positions = new ArrayList<>();
            for (int i = 0; i < binaryString.length(); i++) {
                if (binaryString.charAt(i) == '1') {
                    positions.add(i);
                }
            }

            BigInteger sum = BigInteger.ZERO;
            for (int position : positions) {
                if (position < publicKey.size()) {
                    sum = sum.add(publicKey.get(position));
                }
            }

            encryptedList.add(sum);
        }

        return encryptedList;
    }

    public static String getDecryptedBinary(BigInteger number, List<BigInteger> privateKey) {
        StringBuilder binaryString = new StringBuilder();

        for (int i = privateKey.size() - 1; i >= 0; i--) {
            if (number.compareTo(privateKey.get(i)) >= 0) {
                binaryString.append('1');
                number = number.subtract(privateKey.get(i));
            } else {
                binaryString.append('0');
            }
        }

        return binaryString.reverse().toString();
    }

    public static Object[] decrypt(List<BigInteger> privateKey, List<BigInteger> encryptedText, BigInteger a, BigInteger n) {
        StringBuilder binaryResult = new StringBuilder();
        BigInteger inverse = getInverseNumber(a, n);

        for (BigInteger cipher : encryptedText) {
            BigInteger decryptedValue = cipher.multiply(inverse).mod(n);
            String binaryString = getDecryptedBinary(decryptedValue, privateKey);
            binaryResult.append(binaryString);
        }

        byte[] byteArray = binaryStringToByteArray(binaryResult.toString());

        return new Object[]{byteArray, binaryResult.toString()};
    }
    public static BigInteger[]  getPublicKeyParams(List<BigInteger> privateKey) {
        BigInteger sum = privateKey.stream().reduce(BigInteger.ZERO, BigInteger::add);
        BigInteger n = sum.add(BigInteger.ONE);
        BigInteger a = generateCoprime(n);
        return new BigInteger[]{a, n};
    }
    public static List<BigInteger> generatePublicKey(List<BigInteger> privateKey, BigInteger a, BigInteger n) {
        List<BigInteger> sequence = new ArrayList<>();

        for (BigInteger d : privateKey) {
            BigInteger e = d.multiply(a).mod(n);
            sequence.add(e);
        }

        return sequence;
    }
}
