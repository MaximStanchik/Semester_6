using Microsoft.AspNetCore.HttpLogging;
internal class Program 
{
    private static void Main(string[] args) 
    {
        var builder = WebApplication.CreateBuilder(args);

        builder.Services.AddHttpLogging(options =>
        {
            options.LoggingFields = HttpLoggingFields.All; 
        });

        var app = builder.Build();
        app.UseHttpLogging(); 

        app.Run(async (context) =>
        {
            app.Logger.LogInformation($"Processing request {context.Request.Path}");
            await context.Response.WriteAsync("Hello World!");
        });

        app.Run();
    }
}