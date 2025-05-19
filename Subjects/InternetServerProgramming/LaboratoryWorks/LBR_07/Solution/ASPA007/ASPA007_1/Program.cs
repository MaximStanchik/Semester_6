using DAL_Celebrity_MSSQL;
using Microsoft.Extensions.FileProviders;
using ASPA007_1.Extensions;
using ASPA007_1.Config;
using ASPA007_1.API;
internal class Program
{
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        builder.Services.AddRazorPages();

        builder.AddCelebritiesConfiguration();
        builder.AddCelebritiesServices();

        builder.Services.AddHttpClient("CelebritiesAPI", client =>
        {
            client.BaseAddress = new Uri("https://localhost:7259");
        });

        builder.Services.AddRazorPages(options =>
        {
            options.Conventions.AddPageRoute("/celebrities", "/");
            options.Conventions.AddPageRoute("/NewCelebrity", "/0");
            options.Conventions.AddPageRoute("/celebrity", "/{id:int:min(1)}");
        });

        var app = builder.Build();

        var configSection = builder.Configuration.GetSection("Celebrities").Get<CelebritiesConfig>();

        app.UseStaticFiles();
        app.UseStaticFiles(new StaticFileOptions
        {
            FileProvider = new PhysicalFileProvider(configSection.PhotosFolder),
            RequestPath = configSection.PhotosRequestPath,
        });

        if (!app.Environment.IsDevelopment())
        {
            app.UseExceptionHandler("/Error");
            app.UseHsts();
        }

        app.UseHttpsRedirection();
        app.UseAntiforgery();
        app.UseRouting();

        app.MapRazorPages();

        app.MapCelebritiesEndpoints();
        app.MapPhotoEndpoints();

        app.MapGet("/test-db", (IRepository repo) =>
        {
            try
            {
                var count = repo.GetAllCelebrities().Count;
                return Results.Ok($"DB connection OK. Celebrities count: {count}");
            }
            catch (Exception ex)
            {
                return Results.Problem($"DB connection FAILED: {ex.Message}");
            }
        });
        app.Run();
    }
}