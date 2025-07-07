package org.Stanchik;

import java.util.List;

import static java.lang.Math.log;
import static org.Stanchik.PrimeFactors.formatPrimeFactors;

public class Main
{
    public static void main( String[] args )
    {
        GCD_Calculator GCD = new GCD_Calculator();
        SieveOfEratosthenes sieveOfEratosthenes = new SieveOfEratosthenes();
        PrimeFactors primeFactors = new PrimeFactors();

        int firstNumber = 587;
        int secondNumber = 621;

        System.out.println("\n//-------------------- Другие примеры, не входящие в задания --------------------//");

        System.out.println("НОД(" + firstNumber + ", " + secondNumber + ", 1000.00) = " + GCD.gcd(firstNumber, secondNumber, 1000.00));

        System.out.println("НОД(25, 100, 725.00) = " + GCD.gcd(25, 100, 725.00));

        System.out.println("НОД(48, -18, 0) = " + GCD.gcd(48, -18, 0));
        System.out.println("НОД(48, 18, 30) = " + GCD.gcd(48, 18, 30));
        System.out.println("НОД(-48, -18, -30) = " + GCD.gcd(-48, -18, -30));

        System.out.println("Число 5 является простым? " + primeFactors.isPrime(5));  // true
        System.out.println("Число 10 является простым? " + primeFactors.isPrime(10)); // false
        System.out.println("Число 13 является простым? " + primeFactors.isPrime(13)); // true
        System.out.println("Число 1 является простым? " + primeFactors.isPrime(1));  // false

        System.out.println("\n//-------------------- 1 --------------------//");

        List<Integer> primes_1 = sieveOfEratosthenes.sieveOfEratosthenes(2, secondNumber);
        System.out.println("Простые числа от " + 2 + " до " + secondNumber + ": " + primes_1);
        int numberOfPrimes = primes_1.size();
        System.out.println("Количество простых чисел: " + numberOfPrimes);
        double nln = secondNumber / log(secondNumber);
        System.out.println("Предполагаемое кол-во простых чисел (n/ln(n)): " + nln);

        if (numberOfPrimes > nln) {
            System.out.println("Количество простых чисел больше, чем n/ln(n)");
        }
        else if (numberOfPrimes < nln) {
            System.out.println("Количество простых чисел меньше, чем n/ln(n)");
        }
        else {
            System.out.println("Количество простых чисел и n/ln(n) равны");
        }

        System.out.println("\n//-------------------- 2 --------------------//");

        List<Integer> primes_2 = sieveOfEratosthenes.sieveOfEratosthenes(firstNumber, secondNumber);
        System.out.println("Простые числа от " + firstNumber + " до " + secondNumber + ": " + primes_2);
        System.out.println("Количество простых чисел: " + primes_2.size());

        System.out.println("\n//-------------------- 3 --------------------//");
        List<Integer> firstNumberFactors = primeFactors.findPrimeFactors(firstNumber);
        List<Integer> secondNumberFactors = primeFactors.findPrimeFactors(secondNumber);

        System.out.println(formatPrimeFactors(firstNumberFactors));
        System.out.println(formatPrimeFactors(secondNumberFactors));

        System.out.println("\n//-------------------- 4 --------------------//");
        String concatenated = firstNumber + String.valueOf(secondNumber);
        int concatenatedNumber = Integer.parseInt(concatenated);
        System.out.println("Число, полученное конкатенацией " + firstNumber + " и " + secondNumber + ": " + concatenatedNumber);

        boolean isConcatenatedPrime = primeFactors.isPrime(concatenatedNumber);
        System.out.println("Число " + concatenatedNumber + " является простым? " + isConcatenatedPrime);

        System.out.println("\n//-------------------- 5 --------------------//");

        System.out.println("НОД(" + firstNumber + ", " + secondNumber + ") = " + GCD.gcd(firstNumber, secondNumber));
    }
}
