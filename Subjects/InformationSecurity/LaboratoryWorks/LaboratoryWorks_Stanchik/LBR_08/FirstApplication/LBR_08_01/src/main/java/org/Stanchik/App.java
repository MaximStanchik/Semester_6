package org.Stanchik;

public class App 
{
    public static void main( String[] args )
    {
        System.out.println("Вариант 10");
        System.out.println("==== Реализация ПСП на основе алгоритма линейного конгруэнтого генератора ====");

        LCG lcg = new LCG();

        int a = 421;
        int c = 1663;
        int n = 7875;

        int firstNumber = 1234;
        int sequenceLength = 10000;

        long startTime = System.nanoTime();
        System.out.println(lcg.lcg(firstNumber, sequenceLength, a, c, n));
        long endTime = System.nanoTime();
        long duration = endTime - startTime;

        System.out.println("Время генерации ПСП: " + duration + " нс");
    }
}
