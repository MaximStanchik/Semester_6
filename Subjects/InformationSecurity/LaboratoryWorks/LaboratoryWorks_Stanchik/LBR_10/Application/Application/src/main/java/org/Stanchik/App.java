package org.Stanchik;

import java.math.BigInteger;
import java.util.Random;

public class App {

    public static void main(String[] args) {
        int[] aValues = {5, 10, 15, 20, 25, 30, 35};

        BigInteger[] xValues = {
                new BigInteger("1009"),
                new BigInteger("1013"),
                new BigInteger("1019"),
                new BigInteger("1021"),
                new BigInteger("1031")
        };

        BigInteger[] nValues = {
                new BigInteger(1024, new Random()),
                new BigInteger(2048, new Random())
        };

        System.out.printf("%-10s %-20s %-20s %-20s %-15s\n", "a", "x", "n (binary)", "y", "Time (ms)");

        for (int a : aValues) {
            for (BigInteger x : xValues) {
                for (BigInteger n : nValues) {
                    long startTime = System.nanoTime();
                    BigInteger y = BigInteger.valueOf(a).multiply(x).mod(n);
                    long endTime = System.nanoTime();

                    long duration = endTime - startTime;

                    String nBinary = n.toString(2);
                    if (n == nValues[0]) {
                        nBinary = "1024 bits";
                    }
                    else if (n == nValues[1]) {
                        nBinary = "2048 bits";
                    }

                    System.out.printf("%-10d %-20s %-20s %-20s %-15d\n", a, x, nBinary, y, duration);
                }
            }
        }
    }
}