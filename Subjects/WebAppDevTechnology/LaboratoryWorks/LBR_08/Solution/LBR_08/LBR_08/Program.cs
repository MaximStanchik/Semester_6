using exceptions;
using DAL_Celebrity_MSSQL;
using LBR_08.Classes;
using Microsoft.Extensions.Options;
using System.Text.Json;
using LBR_08.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddJsonFile("Celebrities.config.json", optional: false, reloadOnChange: true);
builder.Services.Configure<CelebritiesConfig>(builder.Configuration.GetSection("Celebrities"));

builder.Services.AddScoped<IRepository, Repository>((IServiceProvider p) =>
{
    var config = p.GetRequiredService<IOptions<CelebritiesConfig>>().Value;
    return new Repository(config.ConnectionString);
});

builder.Services.AddControllersWithViews();
builder.Services.AddScoped<ICountryService, CountryService>();
builder.Services.AddScoped<WikipediaLinksFilter>();

var app = builder.Build();

app.UseMiddleware<ExceptionManagerMiddleware>();

app.UseDefaultFiles();
app.UseStaticFiles();

app.UseRouting();
app.UseAuthorization();
app.MapControllers();

var celebrities = app.MapGroup("/api/cel");
celebrities.MapGet("/", (IRepository repo) => Results.Json(repo.GetAllCelebrities(), new JsonSerializerOptions { WriteIndented = true }));
celebrities.MapGet("/{id:int:min(1)}", (IRepository repo, int id) => Results.Json(repo.GetCelebrityById(id), new JsonSerializerOptions { WriteIndented = true }));
celebrities.MapGet("/le/{id:int:min(1)}", (IRepository repo, int id) => Results.Json(repo.GetCelebrityByLifeeventId(id), new JsonSerializerOptions { WriteIndented = true }));
celebrities.MapDelete("/{id:int:min(1)}", (IRepository repo, int id) => Results.Content((repo.DelCelebrity(id) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));
celebrities.MapPost("/", (IRepository repo, Celebrity celebrity) => Results.Content((repo.AddCelebrity(celebrity) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));
celebrities.MapPut("/{id:int:min(1)}", (IRepository repo, int id, Celebrity celebrity) => Results.Content((repo.UpdCelebrity(id, celebrity) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));
celebrities.MapGet("/photo/{fname}", async (IOptions<CelebritiesConfig> iconfig, string fname) =>
{
    var filePath = Path.Combine(Directory.GetCurrentDirectory(), iconfig.Value.PhotosFolder, fname);
    return File.Exists(filePath)
        ? Results.File(await File.ReadAllBytesAsync(filePath), "image/jpeg")
        : Results.NotFound();
});

var lifeevents = app.MapGroup("/api/le");
lifeevents.MapGet("/", (IRepository repo) => Results.Json(repo.GetAllLifeevents(), new JsonSerializerOptions { WriteIndented = true }));
lifeevents.MapGet("/{id:int:min(1)}", (IRepository repo, int id) => Results.Json(repo.GetLifeevetById(id), new JsonSerializerOptions { WriteIndented = true }));
lifeevents.MapGet("/cel/{id:int:min(1)}", (IRepository repo, int id) => repo.GetLifeeventsByCelebrityId(id));
lifeevents.MapDelete("/{id:int:min(1)}", (IRepository repo, int id) => Results.Content((repo.DelLifeevent(id) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));
lifeevents.MapPost("/", (IRepository repo, Lifeevent lifeevent) => Results.Content((repo.AddLifeevent(lifeevent) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));
lifeevents.MapPut("/{id:int:min(1)}", (IRepository repo, int id, Lifeevent lifeevent) => Results.Content((repo.UpdLifeevent(id, lifeevent) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));

app.MapGet("/photo", async (IOptions<CelebritiesConfig> iconfig) =>
{
    var filePath = iconfig.Value.PhotosFolder;
    return File.Exists(filePath)
        ? Results.File(await File.ReadAllBytesAsync(filePath), "image/jpeg")
        : Results.NotFound();
});

app.MapGet("/geterror", () =>
{
    var zero = 0;
    return Results.Ok(15 / zero);
});

app.MapFallbackToFile("/index.html");

app.MapGet("/", async context =>
{
    context.Response.ContentType = "text/html";
    await context.Response.SendFileAsync(Path.Combine(app.Environment.WebRootPath, "index.html"));
});


app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Celebrities}/{action=Details}/{id?}");

app.MapControllerRoute(
    name: "newCelebrity",
    pattern: "new",
    defaults: new { controller = "Celebrities", action = "New" });

app.MapControllerRoute(
    name: "celebrityDetails",
    pattern: "Celebrities/Details/{id}",
    defaults: new { controller = "Celebrities", action = "Details" });

app.MapControllerRoute(
    name: "updateCelebrity",
    pattern: "Celebrities/Update/{id}",
    defaults: new { controller = "Celebrities", action = "Update" });

app.MapControllerRoute(
    name: "deleteCelebrity",
    pattern: "Celebrities/Delete/{id}",
    defaults: new { controller = "Celebrities", action = "Delete" });

app.Run();