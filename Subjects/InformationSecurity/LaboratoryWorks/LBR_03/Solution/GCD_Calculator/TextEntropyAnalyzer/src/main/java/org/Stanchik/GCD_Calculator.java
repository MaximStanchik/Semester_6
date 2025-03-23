package org.Stanchik;

public class GCD_Calculator {
    public double gcd(double firstNumber, double secondNumber, double thirdNumber) {
        firstNumber = Math.abs(firstNumber);
        secondNumber = Math.abs(secondNumber);

        if (thirdNumber == 0) {
            return gcd(firstNumber, secondNumber);
        } else {
            thirdNumber = Math.abs(thirdNumber);
            double gcdAB = gcd(firstNumber, secondNumber);
            return gcd(gcdAB, thirdNumber);
        }
    }

    public double gcd(double firstNumber, double secondNumber) {
        firstNumber = Math.abs(firstNumber);
        secondNumber = Math.abs(secondNumber);

        return secondNumber == 0 ? firstNumber : gcd(secondNumber, firstNumber % secondNumber);
    }

};
