using DAL_Celebrity_MSSQL;
using Microsoft.Extensions.Options;
using System.Text.Json;
using ASPA006_1.classes;
using ASPA006_1.Middleware;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddJsonFile("Celebrities.config.json", optional: false, reloadOnChange: true);
builder.Services.Configure<CelebritiesConfig>(builder.Configuration.GetSection("Celebrities"));

builder.Services.AddScoped<IRepository, Repository>(p =>
{
    var config = p.GetRequiredService<IOptions<CelebritiesConfig>>().Value;
    return new Repository(config.ConnectionString);
});

var app = builder.Build();

app.UseMiddleware<ErrorHandlingMiddleware>();

app.UseDefaultFiles();
app.UseStaticFiles();

var celebrities = app.MapGroup("/api/cel");

celebrities.MapGet("/", (IRepository repo) =>
    Results.Json(repo.GetAllCelebrities(), new JsonSerializerOptions { WriteIndented = true }));

celebrities.MapGet("/{id}", (IRepository repo, string id) =>
{
    if (!int.TryParse(id, out int intId) || intId <= 0)
        return Results.BadRequest("ID должен быть положительным целым числом");

    var celebrity = repo.GetCelebrityById(intId);
    return celebrity != null
        ? Results.Json(celebrity, new JsonSerializerOptions { WriteIndented = true })
        : Results.NotFound($"Знаменитость с ID={intId} не найдена");
});

celebrities.MapGet("/le/{id}", (IRepository repo, string id) =>
{
    if (!int.TryParse(id, out int intId) || intId <= 0)
        return Results.BadRequest("ID события должен быть положительным целым числом");

    var celebrity = repo.GetCelebrityByLifeeventId(intId);
    return celebrity != null
        ? Results.Json(celebrity, new JsonSerializerOptions { WriteIndented = true })
        : Results.NotFound($"Знаменитость для события с ID={intId} не найдена");
});

celebrities.MapDelete("/{id}", (IRepository repo, string id) =>
{
    if (!int.TryParse(id, out int intId) || intId <= 0)
        return Results.BadRequest("ID должен быть положительным целым числом");

    var existing = repo.GetCelebrityById(intId);
    if (existing == null)
        return Results.NotFound($"Знаменитость с ID={intId} не найдена");

    bool deleted = repo.DelCelebrity(intId);
    return deleted
        ? Results.Content("<h1>Успешно удалено</h1>", "text/html")
        : Results.Content("<h1>Ошибка при удалении</h1>", "text/html");
});

celebrities.MapPost("/", (IRepository repo, Celebrity celebrity) =>
{
    if (celebrity == null)
        return Results.BadRequest("Данные знаменитости не могут быть пустыми");

    bool added = repo.AddCelebrity(celebrity);
    return added
        ? Results.Content("<h1>Успешно добавлено</h1>", "text/html")
        : Results.Content("<h1>Ошибка при добавлении</h1>", "text/html");
});

celebrities.MapPut("/{id}", (IRepository repo, string id, Celebrity celebrity) =>
{
    if (!int.TryParse(id, out int intId) || intId <= 0)
        return Results.BadRequest("ID должен быть положительным целым числом");

    if (celebrity == null)
        return Results.BadRequest("Данные знаменитости не могут быть пустыми");

    var existing = repo.GetCelebrityById(intId);
    if (existing == null)
        return Results.NotFound($"Знаменитость с ID={intId} не найдена");

    bool updated = repo.UpdCelebrity(intId, celebrity);
    return updated
        ? Results.Content("<h1>Успешно обновлено</h1>", "text/html")
        : Results.Content("<h1>Ошибка при обновлении</h1>", "text/html");
});

celebrities.MapGet("/photo/{fname}", async (IOptions<CelebritiesConfig> iconfig, string fname) =>
{
    if (string.IsNullOrWhiteSpace(fname))
        return Results.BadRequest("Имя файла не может быть пустым");

    var filePath = Path.Combine(iconfig.Value.PhotosFolder, fname);
    if (!File.Exists(filePath))
        return Results.NotFound("Файл не найден");

    var bytes = await File.ReadAllBytesAsync(filePath);
    return Results.File(bytes, "image/jpeg");
});

var lifeevents = app.MapGroup("/api/le");

lifeevents.MapGet("/", (IRepository repo) =>
    Results.Json(repo.GetAllLifeevents(), new JsonSerializerOptions { WriteIndented = true }));

lifeevents.MapGet("/{id}", (IRepository repo, string id) =>
{
    if (!int.TryParse(id, out int intId) || intId <= 0)
        return Results.BadRequest("ID должен быть положительным целым числом");

    var lifeevent = repo.GetLifeevetById(intId);
    return lifeevent != null
        ? Results.Json(lifeevent, new JsonSerializerOptions { WriteIndented = true })
        : Results.NotFound($"Событие с ID={intId} не найдено");
});

lifeevents.MapGet("/cel/{id}", (IRepository repo, string id) =>
{
    if (!int.TryParse(id, out int intId) || intId <= 0)
        return Results.BadRequest("ID знаменитости должен быть положительным целым числом");

    var events = repo.GetLifeeventsByCelebrityId(intId);
    return (events != null && events.Any())
        ? Results.Json(events, new JsonSerializerOptions { WriteIndented = true })
        : Results.NotFound($"События для знаменитости с ID={intId} не найдены");
});

lifeevents.MapDelete("/{id}", (IRepository repo, string id) =>
{
    if (!int.TryParse(id, out int intId) || intId <= 0)
        return Results.BadRequest("ID должен быть положительным целым числом");

    var existing = repo.GetLifeevetById(intId);
    if (existing == null)
        return Results.NotFound($"Событие с ID={intId} не найдено");

    bool deleted = repo.DelLifeevent(intId);
    return deleted
        ? Results.Content("<h1>Успешно удалено</h1>", "text/html")
        : Results.Content("<h1>Ошибка при удалении</h1>", "text/html");
});

lifeevents.MapPost("/", (IRepository repo, Lifeevent lifeevent) =>
{
    if (lifeevent == null)
        return Results.BadRequest("Данные события не могут быть пустыми");

    if (lifeevent.CelebrityId <= 0)
        return Results.BadRequest("ID знаменитости должен быть положительным числом");

    if (string.IsNullOrWhiteSpace(lifeevent.Description))
        return Results.BadRequest("Описание события не может быть пустым");

    var celebrityExists = repo.GetCelebrityById(lifeevent.CelebrityId) != null;
    if (!celebrityExists)
        return Results.NotFound($"Знаменитость с ID={lifeevent.CelebrityId} не найдена");

    bool added = repo.AddLifeevent(lifeevent);
    return added
        ? Results.Content("<h1>Успешно добавлено</h1>", "text/html")
        : Results.Content("<h1>Ошибка при добавлении</h1>", "text/html");
});

lifeevents.MapPut("/{id:int}", (IRepository repo, int id, Lifeevent lifeevent) =>
{
    if (lifeevent == null)
        return Results.BadRequest("Данные события не могут быть пустыми");

    if (lifeevent.CelebrityId <= 0)
        return Results.BadRequest("ID знаменитости должен быть положительным числом");

    if (string.IsNullOrWhiteSpace(lifeevent.Description))
        return Results.BadRequest("Описание события не может быть пустым");

    var existingEvent = repo.GetLifeevetById(id);
    if (existingEvent == null)
        return Results.NotFound($"Событие с ID={id} не найдено");

    var celebrityExists = repo.GetCelebrityById(lifeevent.CelebrityId) != null;
    if (!celebrityExists)
        return Results.NotFound($"Знаменитость с ID={lifeevent.CelebrityId} не найдена");

    bool updated = repo.UpdLifeevent(id, lifeevent);
    return updated
        ? Results.Content("<h1>Успешно обновлено</h1>", "text/html")
        : Results.Content("<h1>Ошибка при обновлении</h1>", "text/html");
});

app.MapGet("/api/GetLocalLe/{photoName}", (IRepository repo, string photoName) =>
{
    if (string.IsNullOrWhiteSpace(photoName))
        return Results.BadRequest("Имя файла не может быть пустым");

    string result = repo.GetLifeeventByPhoto(photoName);
    return string.IsNullOrEmpty(result)
        ? Results.NotFound("Информация по фото не найдена")
        : Results.Ok(result);
});

app.Run();
