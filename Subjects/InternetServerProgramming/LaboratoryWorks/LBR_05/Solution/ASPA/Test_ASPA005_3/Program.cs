using System.Net.Http.Json;
using System.Text.Json;

public static class Program
{
    public static async Task Main(string[] args)
    {
        var app = WebApplication.Create(); // Создание экземпляра WebApplication
        await Test.TestTask3(app); 
        app.Run();
    }
}
public static class Test // Сделать класс статическим
{
    private class Answer<T>
    {
        public T? X { get; set; } // Nullable
        public T? Y { get; set; } // Nullable
        public string Message { get; set; } = string.Empty;
    }

    public static readonly string Ok = "OK", Nok = "NOK";

    private static readonly HttpClient _httpClient = new(); // Сделать HttpClient статическим

    public static async Task ExecuteGET<T>(string path, Func<T?, T?, int, string> result)
    {
        var response = await _httpClient.GetAsync(path);
        await ResultPrint("GET", path, response, result);
    }

    public static async Task ExecutePOST<T>(string path, T content, Func<T?, T?, int, string> result)
    {
        var response = await _httpClient.PostAsJsonAsync(path, content);
        await ResultPrint("POST", path, response, result);
    }

    public static async Task ExecutePUT<T>(string path, T content, Func<T?, T?, int, string> result)
    {
        var response = await _httpClient.PutAsJsonAsync(path, content);
        await ResultPrint("PUT", path, response, result);
    }

    public static async Task ExecuteDELETE<T>(string path, Func<T?, T?, int, string> result)
    {
        var response = await _httpClient.DeleteAsync(path);
        await ResultPrint("DELETE", path, response, result);
    }

    private static async Task ResultPrint<T>(
        string method,
        string path,
        HttpResponseMessage responseMessage,
        Func<T?, T?, int, string> result)
    {
        var status = (int)responseMessage.StatusCode;

        try
        {
            var answer = await responseMessage.Content.ReadFromJsonAsync<Answer<T>>();

            T? x = answer.X;
            T? y = answer.Y;
            var res = result(x, y, status);

            Console.WriteLine($"{res} : {method} {path}, status = {status}, x = {x}, y = {y}, m = {answer?.Message}");
        }
        catch (JsonException ex)
        {
            var res = result(default, default, status);
            Console.WriteLine($"{res} : {method} {path}, status = {status}, x = {null}, y = {null}, m = {ex.Message}");
        }
    }
    public static async Task TestTask3(this WebApplication app) // Метод расширения
    {
        string baseUrl = "http://localhost:5285";

        // --- A ---
        await ExecuteGET<int?>($"{baseUrl}/A/3", (x, y, status) => (x == 3 && status == 200) ? Ok : Nok);
        await ExecutePOST<int?>($"{baseUrl}/A/50", 50, (x, y, status) => (x == 50 && status == 200) ? Ok : Nok);
        await ExecutePUT<IntPair>($"{baseUrl}/A/10/20", new IntPair { X = 10, Y = 20 }, (x, y, status) => (x?.X == 10 && y?.Y == 20 && status == 200) ? Ok : Nok);
        await ExecuteDELETE<int?>($"{baseUrl}/A/5-99", (x, y, status) => (x == 5 && y == 99 && status == 200) ? Ok : Nok);

        // --- B ---
        await ExecuteGET<float?>($"{baseUrl}/B/3.14", (x, y, status) => (x == 3.14f && status == 200) ? Ok : Nok);
        await ExecutePOST<FloatPair>($"{baseUrl}/B/2.5/4.8", new FloatPair { X = 2.5f, Y = 4.8f }, (x, y, status) => (x?.X == 2.5f && y?.Y == 4.8f && status == 200) ? Ok : Nok);
        await ExecuteDELETE<float?>($"{baseUrl}/B/1.1-9.9", (x, y, status) => (x == 1.1f && y == 9.9f && status == 200) ? Ok : Nok);

        // --- C ---
        await ExecuteGET<bool?>($"{baseUrl}/C/true", (x, y, status) => (x == true && status == 200) ? Ok : Nok);
        await ExecutePOST<BoolPair>($"{baseUrl}/C/false,true", new BoolPair { X = false, Y = true }, (x, y, status) => (x?.X == false && y?.Y == true && status == 200) ? Ok : Nok);

        // --- D ---
        await ExecuteGET<DateTime>($"{baseUrl}/D/2025-02-28", (x, y, status) => (x == DateTime.Parse("2025-02-28") && status == 200) ? Ok : Nok);
        await ExecutePOST<DateRange>($"{baseUrl}/D/2024-01-01|2025-12-31", new DateRange { X = DateTime.Parse("2024-01-01"), Y = DateTime.Parse("2025-12-31") }, (x, y, status) => (x?.X == DateTime.Parse("2024-01-01") && y?.Y == DateTime.Parse("2025-12-31") && status == 200) ? Ok : Nok);

        // --- E ---
        await ExecuteGET<string>($"{baseUrl}/E/12-Hello", (x, y, status) => (x == "Hello" && status == 200) ? Ok : Nok);
        await ExecutePUT<string>($"{baseUrl}/E/Example", "Example", (x, y, status) => (x == "Example" && status == 200) ? Ok : Nok);

        // --- F ---
        await ExecutePUT<string>($"{baseUrl}/F/test@example.by", "test@example.by", (x, y, status) => (x == "test@example.by" && status == 200) ? Ok : Nok);
    }
}

public class IntPair // Класс для передачи пар целых чисел
{
    public int X { get; set; }
    public int Y { get; set; }
}

public class FloatPair // Класс для передачи пар чисел с плавающей запятой
{
    public float X { get; set; }
    public float Y { get; set; }
}

public class BoolPair // Класс для передачи пар логических значений
{
    public bool X { get; set; }
    public bool Y { get; set; }
}

public class DateRange // Класс для диапазона дат
{
    public DateTime X { get; set; }
    public DateTime Y { get; set; }
}