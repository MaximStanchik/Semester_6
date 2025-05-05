using DAL_Celebrity;
using DAL_Celebrity_MSSQL;
using laba4_asp.Classes;
using Microsoft.Extensions.Options;
using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddJsonFile("Celebrities.config.json", optional: false, reloadOnChange: true);
builder.Services.Configure<CelebritiesConfig>(builder.Configuration.GetSection("Celebrities"));

builder.Services.AddScoped<IRepository, Repository>((IServiceProvider p) =>
{
    var config = p.GetRequiredService<IOptions<CelebritiesConfig>>().Value;
    return new Repository(config.ConnectionString);
});

var app = builder.Build();

app.UseExceptionHandler("/error");
app.UseDefaultFiles();
app.UseStaticFiles();

var celebrities = app.MapGroup("/api/cel");

// все знаменитости
celebrities.MapGet("/", (IRepository repo) => Results.Json(repo.GetAllCelebrities(), new JsonSerializerOptions { WriteIndented = true }));

// знаменитость по ID
celebrities.MapGet("/{id:int:min(1)}", (IRepository repo, int id) => Results.Json(repo.GetCelebrityById(id), new JsonSerializerOptions { WriteIndented = true }));

// знаменитость по ID события
celebrities.MapGet("/le/{id:int:min(1)}", (IRepository repo, int id) => Results.Json(repo.GetCelebrityByLifeeventId(id), new JsonSerializerOptions { WriteIndented = true }));

// удалить знаменитость по ID
celebrities.MapDelete("/{id:int:min(1)}", (IRepository repo, int id) => Results.Content((repo.DelCelebrity(id) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));

// добавить новую знаменитость
celebrities.MapPost("/", (IRepository repo, Celebrity celebrity) => Results.Content((repo.AddCelebrity(celebrity) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));

// изменить знаменитость по ID
celebrities.MapPut("/{id:int:min(1)}", (IRepository repo, int id, Celebrity celebrity) => Results.Content((repo.UpdCelebrity(id, celebrity) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));

// получить файл фотографии по имени файла (fname) 
celebrities.MapGet("/photo/{fname}", async (IOptions<CelebritiesConfig> iconfig, string fname) =>
{
    var filePath = Path.Combine(iconfig.Value.PhotosFolder, fname);

    if (File.Exists(filePath))
    {
        return Results.File(await File.ReadAllBytesAsync(filePath), "image/jpeg");
    }

    return Results.NotFound();
});

//СОБЫТИЯ(Lifeevents)
var lifeevents = app.MapGroup("/api/le");

// все события
lifeevents.MapGet("/", (IRepository repo) => Results.Json(repo.GetAllLifeevents(), new JsonSerializerOptions { WriteIndented = true }));

// событие по ID
lifeevents.MapGet("/{id:int:min(1)}", (IRepository repo, int id) => Results.Json(repo.GetLifeevetById(id), new JsonSerializerOptions { WriteIndented = true }));

// все события по ID знаменитости
lifeevents.MapGet("/cel/{id:int:min(1)}", (IRepository repo, int id) => repo.GetLifeeventsByCelebrityId(id));

//удалить событие по ID
lifeevents.MapDelete("/{id:int:min(1)}", (IRepository repo, int id) => Results.Content((repo.DelLifeevent(id) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));

// добавить новое событие
lifeevents.MapPost("/", (IRepository repo, Lifeevent lifeevent) => Results.Content((repo.AddLifeevent(lifeevent) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));

//изменить событие по ID
lifeevents.MapPut("/{id:int:min(1)}", (IRepository repo, int id, Lifeevent lifeevent) => Results.Content((repo.UpdLifeevent(id, lifeevent) ? "<h1>All correct</h1>" : "<h1>Error</h1>"), "text/html"));

app.MapGet("/photo", async (IOptions<CelebritiesConfig> iconfig, HttpContext context) =>
{
    var filePath = Path.Combine(iconfig.Value.PhotosFolder);

    if (File.Exists(filePath))
    {
        return Results.File(await File.ReadAllBytesAsync(filePath), "image/jpeg");
    }

    return Results.NotFound();
});


app.MapGet("/api/GetLocalLe/{photoName}", (IRepository repo, string photoName) =>
{
    string result = repo.GetLifeeventByPhoto(photoName);

    return result;
});


app.Run();