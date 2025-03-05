using DAL003;
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.Extensions.FileProviders;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(
        Path.Combine(builder.Environment.ContentRootPath, "Celebrities")),
    RequestPath = "/Photo"
});

app.MapGet("/Photo/{filename}", async context =>
{
    var filename = context.Request.RouteValues["filename"].ToString();
    var filePath = Path.Combine(builder.Environment.ContentRootPath, "Celebrities", filename);

    if (System.IO.File.Exists(filePath))
    {
        context.Response.Headers.Add("Content-Disposition", $"attachment; filename=\"{filename}\"");
        await context.Response.SendFileAsync(filePath);
    }
    else
    {
        context.Response.StatusCode = 404; 
    }
});

app.MapGet("/Celebrities/download", async context =>
{
    var directoryPath = Path.Combine(builder.Environment.ContentRootPath, "Celebrities");
    var directoryContents = new PhysicalFileProvider(directoryPath).GetDirectoryContents("");

    var html = "<html><body>";
    html += "<h1>Index of /Celebrities/download</h1>";
    html += "<table border='1'><tr><th>File Name</th><th>Size (bytes)</th><th>Last Modified</th></tr>";

    foreach (var file in directoryContents)
    {
        var size = file.Length; 
        var lastModified = file.LastModified.ToString("dd.MM.yyyy HH:mm:ss"); 
        html += $"<tr><td><a href=\"/Photo/{file.Name}\">{file.Name}</a></td><td>{size}</td><td>{lastModified}</td></tr>";
    }

    html += "</table></body></html>";

    await context.Response.WriteAsync(html);
});

app.MapGet("/", () => "ASPA003!");

CelebrityRepository.JSONFileName = "Celebrities.json";
using (IRepository repository = CelebrityRepository.Create("Celebrities"))
{
    app.MapGet("/celebrities", () => repository.getAllCelebrities());

    app.MapGet("/celebrities/{id:int}", (int id) =>
    {
        var celebrity = repository.getCelebrityById(id);
        return celebrity != null ? Results.Ok(celebrity) : Results.NotFound("Celebrity not found.");
    });

    app.MapGet("/celebrities/bySurname/{surname}", (string surname) => repository.getCelebritiesBySurname(surname));

    app.MapGet("/celebrities/PhotoPath/{id:int}", (int id) =>
    {
        var photoPath = repository.getPhotoPathById(id);
        if (photoPath == null)
        {
            return Results.NotFound("Celebrity not found.");
        }

        return Results.Ok($"/Photo/{Path.GetFileName(photoPath)}");
    });
}

app.Run();