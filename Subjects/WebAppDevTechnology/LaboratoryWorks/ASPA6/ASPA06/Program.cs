using ASPA06.Config;
using ASPA06.Exceptions;
using ASPA06.Middleware;
using DAL_Celebrity_Pg;
using DAL_Celebrity_Pg.Entities;
using DAL_Celebrity_Pg.Interfaces;
using Microsoft.AspNetCore.DataProtection.Repositories;
using Microsoft.Extensions.Options;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddJsonFile("Celebrities.config.json", optional: true, reloadOnChange: true);
builder.Services.Configure<CelebritiesConfig>(builder.Configuration.GetSection("Celebrities"));

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

builder.Services.AddScoped<IRepository, Repository>((IServiceProvider provider ) => {
    CelebritiesConfig config = provider.GetRequiredService<IOptions<CelebritiesConfig>>().Value;
    return new Repository(config.ConnectionString);
});

var app = builder.Build();

app.UseMiddleware<ErrorHandlingMiddleware>();

app.UseCors("AllowAll");

app.UseDefaultFiles();
app.UseStaticFiles();

app.UseRouting();


// ------- ÇÍÀÌÅÍÈÒÎÑÒÈ (Celebrities)
var celebrities = app.MapGroup("/api/celebrities");

celebrities.MapGet("/", (IRepository repo) => repo.GetAllCelebrities());

celebrities.MapGet("/Lifeevents/{id:int}", (IRepository repo, int id) => repo.GetCelebrityByLifeeventId(id)
                                                                ?? throw new ObjectNotFoundException($"No celebrity with event id: {id}"));

celebrities.MapPost("/", (IRepository repo, Celebrity celebrity) => repo.AddCelebrity(celebrity));

celebrities.MapGet("/{id:int}", (IRepository repo, int id) => repo.GetCelebrityById(id) 
                                                                ?? throw new ObjectNotFoundException($"No celebrity with id: {id}"));

celebrities.MapPut("/{id:int}", (IRepository repo, int id, Celebrity celebrity) => repo.UpdateCelebrity(id, celebrity)? 
                                                                Results.Ok() : throw new ObjectNotFoundException($"Error on update: No celebrity with id: {id}"));

celebrities.MapDelete("/{id:int}", (IRepository repo, int id) => repo.DelCelebrity(id)?
                                                                Results.NoContent() : throw new ObjectNotFoundException($"Error on delete: No celebrity with id: {id}"));

celebrities.MapGet("/photo/{img:maxlength(200)}", (IServiceProvider provider, IRepository repo, string img) =>
{
    var foldPath = provider.GetRequiredService<IOptions<CelebritiesConfig>>().Value.PhotosFolder;
    var imagePath = Path.Combine(foldPath, img);

    if (!System.IO.File.Exists(imagePath))
    {
        return Results.NotFound("No file");
    }

    var fileBytes = System.IO.File.ReadAllBytes(imagePath);
    var contentType = "image/jpeg"; 

    return Results.File(fileBytes, contentType, enableRangeProcessing: false);
});


// ------- ÑÎÁÛÒÈß (Lifeevents)
var lifeevents = app.MapGroup("/api/lifeevents");

lifeevents.MapGet("/", (IRepository repo) => repo.GetAllLifeevents()    );

lifeevents.MapPost("/", (IRepository repo, LifeEvent lifeevent) => repo.AddLifeevent(lifeevent));

lifeevents.MapGet("/{id:int}", (IRepository repo, int id) => repo.GetLifeeventById(id)
                                                                ?? throw new ObjectNotFoundException($"No event with id: {id}"));

lifeevents.MapPut("/{id:int}", (IRepository repo, int id, LifeEvent lifeevent) => repo.UpdataeLifeevent(id, lifeevent)?
                                                                Results.Ok() : throw new ObjectNotFoundException($"Error on update: No event with id: {id}"));

lifeevents.MapDelete("/{id:int}", (IRepository repo, int id) => repo.DelLifeevent(id)?
                                                                Results.NoContent() : throw new ObjectNotFoundException($"Error on delete: No event with id: {id}"));

lifeevents.MapGet("/Celebrities/{id:int}", (IRepository repo, int id) => repo.GetLifeEventsByCelebrityId(id)
                                                                ?? throw new ObjectNotFoundException($"No events with celebrity id: {id}"));

app.Run();
