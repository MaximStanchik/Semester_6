package org.Stanchik;

import java.math.BigInteger;
import java.security.SecureRandom;

public class MathUtils {
    private static SecureRandom random = new SecureRandom();
    public static BigInteger generatePrimeNumber(int bitLength) {
        BigInteger primeCandidate;
        do {
            primeCandidate = new BigInteger(bitLength, random);
        } while (!primeCandidate.isProbablePrime(100));

        return primeCandidate;
    }

    public static BigInteger generateCoprimeNumber(BigInteger fi) {
        BigInteger min = fi.add(BigInteger.ONE);
        BigInteger max = fi.multiply(BigInteger.TWO);
        BigInteger coprime;

        do {
            coprime = new BigInteger(max.bitLength(), random).mod(max.subtract(min)).add(min);
        } while (!isCoprime(fi, coprime));

        return coprime;
    }
    public static boolean isCoprime(BigInteger a, BigInteger b) {
        return a.gcd(b).equals(BigInteger.ONE);
    }
}
