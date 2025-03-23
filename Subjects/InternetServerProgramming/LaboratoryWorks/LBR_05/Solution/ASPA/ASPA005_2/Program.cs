using DAL004;
using Microsoft.AspNetCore.Diagnostics;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();

var app = builder.Build();

CelebrityRepository.JSONFileName = "Celebrities.json";
using (IRepository repository = CelebrityRepository.Create("Celebrities"))
{
    app.UseExceptionHandler("/Celebrities/Error");

    app.MapGet("/Celebrities", () => repository.getAllCelebrities());

    app.MapGet("/Celebrities/{id:int}", (int id) => {
        Celebrity? celebrity = repository.getCelebrityById(id);
        if (celebrity == null)
        {
            throw new FoundByIdException($"Celebrity Id = {id}");
        }
        return celebrity;
    });

    // Установка репозитория для фильтров
    SurnameFilter.Repository = PhotoExistFilter.Repository = repository;

    app.MapPost("/Celebrities", async (Celebrity celebrity) => {
        int? id = repository.addCelebrity(celebrity);
        if (id == null)
        {
            throw new AddCelebrityException("/Celebrities error, id == null");
        }

        int saveResult = repository.SaveChanges();
        if (saveResult <= 0)
        {
            throw new SaveException("/Celebrities error, SaveChanges() <= 0");
        }

        return Results.Created($"/Celebrities/{id}", celebrity with { Id = (int)id });
    })
    .AddEndpointFilter<SurnameFilter>()
    .AddEndpointFilter<PhotoExistFilter>();

    // Группа маршрутов для MapPut и MapDelete
    var celebritiesGroup = app.MapGroup("/Celebrities");

    celebritiesGroup.MapDelete("/{id:int}", async (int id) =>
    {
        bool deleted = repository.delCelebrityById(id);
        if (!deleted)
        {
            throw new DeleteCelebrityException($"{id}");
        }
        repository.SaveChanges();
        return Results.Ok(new { message = $"Celebrity with Id = {id} deleted." });
    })
    .AddEndpointFilter<DeleteCelebrityFilter>();

    celebritiesGroup.MapPut("/{id:int}", async (int id, Celebrity celebrity) =>
    {
        celebrity = celebrity with { Id = id };
        var updatedId = repository.updCelebrityById(id, celebrity);
        if (updatedId == null)
        {
            throw new SaveException("Failed to update the celebrity.");
        }
        repository.SaveChanges();
        return Results.Ok(new { message = $"Celebrity with Id = {updatedId} updated." });
    })
    .AddEndpointFilter<UpdateCelebrityFilter>();

    app.MapFallback((HttpContext ctx) => Results.NotFound(new { error = $"path {ctx.Request.Path} not supported" }));

    app.Map("/Celebrities/Error", (HttpContext ctx) => {
        Exception? ex = ctx.Features.Get<IExceptionHandlerFeature>()?.Error;
        IResult rc = Results.Problem(detail: "Panic", instance: app.Environment.EnvironmentName, title: "ASPA004", statusCode: 500);

        if (ex != null)
        {
            if (ex is PutCelebrityException || ex is DeleteCelebrityException || ex is FoundByIdException || ex is AddCelebrityException || ex is SaveException)
            {
                rc = Results.Text($"{ex.Message}");
            }
            else if (ex is BadHttpRequestException)
            {
                rc = Results.BadRequest(ex.Message);
            }
        }
        return rc;
    });

    app.Run();
}

// Исключения
public class PutCelebrityException : Exception { public PutCelebrityException(string message) : base($"Put by Id: {message}") { } }
public class DeleteCelebrityException : Exception { public DeleteCelebrityException(string message) : base($"Delete by Id: {message}") { } }
public class FoundByIdException : Exception { public FoundByIdException(string message) : base($"Found by Id: {message}") { } }
public class SaveException : Exception { public SaveException(string message) : base($"SaveChanges error: {message}") { } }
public class AddCelebrityException : Exception { public AddCelebrityException(string message) : base($"AddCelebrityException error: {message}") { } }

// Классы фильтров
public class SurnameFilter : IEndpointFilter
{
    public static IRepository Repository { get; set; }

    public async ValueTask<object?> InvokeAsync(EndpointFilterInvocationContext context, EndpointFilterDelegate next)
    {
        var celebrity = context.GetArgument<Celebrity>(0);
        if (string.IsNullOrWhiteSpace(celebrity.Surname) || celebrity.Surname.Length < 2)
        {
            throw new SaveException("Invalid surname.");
        }

        return await next(context);
    }
}

public class PhotoExistFilter : IEndpointFilter
{
    public static IRepository Repository { get; set; }

    public async ValueTask<object?> InvokeAsync(EndpointFilterInvocationContext context, EndpointFilterDelegate next)
    {
        var celebrity = context.GetArgument<Celebrity>(0);
        var basePath = Path.Combine(Directory.GetCurrentDirectory(), "Celebrities");
        var fileName = Path.GetFileName(celebrity.PhotoPath);
        var filePath = Path.Combine(basePath, fileName);

        if (!File.Exists(filePath))
        {
            context.HttpContext.Response.OnStarting(() =>
            {
                context.HttpContext.Response.Headers.Append("X-Celebrity", $"Not Found = {fileName}");
                return Task.CompletedTask;
            });

            throw new SaveException($"Photo not found: {fileName}.");
        }

        return await next(context);
    }
}

public class UpdateCelebrityFilter : IEndpointFilter
{
    public static IRepository Repository { get; set; }

    public async ValueTask<object?> InvokeAsync(EndpointFilterInvocationContext context, EndpointFilterDelegate next)
    {
        var id = context.GetArgument<int>(1);
        var existingCelebrity = Repository.getCelebrityById(id);
        if (existingCelebrity == null)
        {
            throw new FoundByIdException($"Celebrity with Id = {id} not found.");
        }

        return await next(context);
    }
}

public class DeleteCelebrityFilter : IEndpointFilter
{
    public static IRepository Repository { get; set; }

    public async ValueTask<object?> InvokeAsync(EndpointFilterInvocationContext context, EndpointFilterDelegate next)
    {
        var id = context.GetArgument<int>(0);
        var celebrity = Repository.getCelebrityById(id);
        if (celebrity == null)
        {
            throw new FoundByIdException($"Celebrity with Id = {id} not found.");
        }

        return await next(context);
    }
}