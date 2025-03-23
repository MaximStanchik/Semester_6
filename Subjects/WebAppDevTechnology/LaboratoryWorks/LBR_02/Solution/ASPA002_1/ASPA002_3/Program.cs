using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics;

internal class Program
{
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);
        builder.Logging.AddFilter("Microsoft.AspNetCore.Diagnostics", LogLevel.None);
        builder.Logging.AddConsole();

        var app = builder.Build();

        app.UseExceptionHandler("/error"); 

        app.MapGet("/", () => "Start ");

        app.MapGet("/test1", () =>
        {
            throw new Exception("-- Exception Test --");
        });

        app.MapGet("/test2", () =>
        {
            int x = 0, y = 5, z = 0;
            z = y / x; 
            return "test 2";
        });

        app.MapGet("/test3", () =>
        {
            int[] x = new int[3] { 1, 2, 3 };
            int y = x[3];
            return "test 3";
        });

        app.Map("/error", async (ILogger<Program> logger, HttpContext context) =>
        {
            IExceptionHandlerFeature? exobj = context.Features.Get<IExceptionHandlerFeature>(); 
            await context.Response.WriteAsync($"<h1>Oops!</h1>");
            logger.LogError(exobj?.Error, "ExceptionHandled");
        });

        app.Run();
    }
}