using Lab7;
using System;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;

public class Program
{
    public static string originalMessage = "";
    public static void Main()
    {
        Console.WriteLine("// 1. ---------- Использование обычных ключей 1 ---------- //");

        Stopwatch sw = new Stopwatch();
        Console.WriteLine($"Изначальный текст: {originalMessage}");

        string firstKey = "1110110110101101";
        string secondKey = "1110111001010101";

        sw.Start();
        string encryptMessage = DESS.Encrypt(firstKey, secondKey, originalMessage);
        sw.Stop();
        Console.WriteLine($"Время шифрования: {sw.Elapsed.TotalMilliseconds} ms");

        sw.Restart();
        originalMessage = DESS.Decrypt(firstKey, secondKey, encryptMessage);
        sw.Stop();
        Console.WriteLine($"Время расшифрования: {sw.Elapsed.TotalMilliseconds} ms");

        Console.WriteLine("Размер текста: " + (originalMessage).Length * 8);
        Console.WriteLine("Размер зашифрованного текста: " + (encryptMessage).Length * 6);

        Console.WriteLine("// 2. ---------- Использование обычных ключей 2 ---------- //");

        sw = new Stopwatch();

        firstKey = "1110110110101101";
        secondKey = "1110111001010100";

        sw.Start();
        encryptMessage = DESS.Encrypt(firstKey, secondKey, originalMessage);
        sw.Stop();
        Console.WriteLine($"Время шифрования: {sw.Elapsed.TotalMilliseconds} ms");

        sw.Restart();
        originalMessage = DESS.Decrypt(firstKey, secondKey, encryptMessage);
        sw.Stop();
        Console.WriteLine($"Время расшифрования: {sw.Elapsed.TotalMilliseconds} ms");

        Console.WriteLine("Размер текста: " + (originalMessage).Length * 8);
        Console.WriteLine("Размер зашифрованного текста: " + (encryptMessage).Length * 6);

        Console.WriteLine("// 3. ---------- Использование слабых ключей ---------- //");

        sw = new Stopwatch();

        firstKey = "1F1F1F1F1F1F1F1F";
        secondKey = "FEFEFEFEFEFEFEFE";

        sw.Start();
        encryptMessage = DESS.Encrypt(firstKey, secondKey, originalMessage);
        sw.Stop();
        Console.WriteLine($"Время шифрования: {sw.Elapsed.TotalMilliseconds} ms");

        sw.Restart();
        originalMessage = DESS.Decrypt(firstKey, secondKey, encryptMessage);
        sw.Stop();
        Console.WriteLine($"Время расшифрования: {sw.Elapsed.TotalMilliseconds} ms");

        Console.WriteLine("Размер текста: " + (originalMessage).Length * 8);
        Console.WriteLine("Размер зашифрованного текста: " + (encryptMessage).Length * 6);

        Console.WriteLine("// 4. ---------- Использование полуслабых ключей ---------- //");

        sw = new Stopwatch();

        firstKey = "FEE0FEE0FEE0FEE0";
        secondKey = "0E010E010E010E01";

        sw.Start();
        encryptMessage = DESS.Encrypt(firstKey, secondKey, originalMessage);
        sw.Stop();
        Console.WriteLine($"Время шифрования: {sw.Elapsed.TotalMilliseconds} ms");

        sw.Restart();
        originalMessage = DESS.Decrypt(firstKey, secondKey, encryptMessage);
        sw.Stop();
        Console.WriteLine($"Время расшифрования: {sw.Elapsed.TotalMilliseconds} ms");

        Console.WriteLine("Размер текста: " + (originalMessage).Length * 8);
        Console.WriteLine("Размер зашифрованного текста: " + (encryptMessage).Length * 6);
    }
}