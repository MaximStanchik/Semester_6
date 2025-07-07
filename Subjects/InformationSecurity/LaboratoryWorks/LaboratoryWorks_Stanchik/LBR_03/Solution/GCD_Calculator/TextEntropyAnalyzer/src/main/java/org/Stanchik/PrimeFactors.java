package org.Stanchik;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PrimeFactors {
    public static List<Integer> findPrimeFactors(int n) {
        List<Integer> factors = new ArrayList<>();
        int divisor = 2;

        while (n > 1) {
            if (n % divisor == 0) {
                factors.add(divisor);
                n /= divisor;
            } else {
                divisor++;
            }
        }

        return factors;
    }

    public boolean isPrime(int a) {
        if (a < 2) {
            return false;
        }
        else {
            int square = (int) Math.round(Math.sqrt(a));

            for (int i = 2; i <= square; i++) {
                if (a % i == 0) {
                    return false;
                }
            }

            return true;
        }
    }

    public static String formatPrimeFactors(List<Integer> factors) {
        Map<Integer, Integer> factorMap = new HashMap<>();

        for (int factor : factors) {
            factorMap.put(factor, factorMap.getOrDefault(factor, 0) + 1);
        }

        StringBuilder result = new StringBuilder();
        for (Map.Entry<Integer, Integer> entry : factorMap.entrySet()) {
            if (result.length() > 0) {
                result.append(" * ");
            }
            result.append(entry.getKey());
            if (entry.getValue() > 1) {
                result.append("^").append(entry.getValue());
            }
        }

        return result.toString();
    }
}
