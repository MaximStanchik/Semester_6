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
        if (celebrity == null) throw new FoundByIdException($"Celebrity Id = {id}");
        return celebrity;
    });

    app.MapPost("/Celebrities", async (Celebrity celebrity) => {
        
        if (string.IsNullOrWhiteSpace(celebrity.FirstName) ||
            string.IsNullOrWhiteSpace(celebrity.Surname) ||
            string.IsNullOrWhiteSpace(celebrity.PhotoPath))
        {
            throw new Exception("Panic"); 
        }

        int? id = repository.addCelebrity(celebrity);
        if (id == null)
        {
            throw new AddCelebrityException($"Failed to add celebrity: {celebrity.FirstName} {celebrity.Surname}");
        }

        int saveResult = repository.SaveChanges();
        if (saveResult <= 0)
        {
            throw new SaveException("Failed to save changes to the repository.");
        }

        return Results.Created($"/Celebrities/{id}", celebrity with { Id = (int)id });
    });

    app.MapFallback((HttpContext ctx) => Results.NotFound(new { error = $"path {ctx.Request.Path} not supported" }));

    app.Map("/Celebrities/Error", (HttpContext ctx) => {
        Exception? ex = ctx.Features.Get<IExceptionHandlerFeature>()?.Error;
        IResult rc = Results.Problem(detail: "An unexpected error occurred.", instance: app.Environment.EnvironmentName, title: "ASPA004", statusCode: 500);

        if (ex != null)
        {
            if (ex.Message == "Panic")
            {
                rc = Results.Problem(detail: "panic", instance: app.Environment.EnvironmentName, title: "ASPA004", statusCode: 500);
            }
            else if (ex is FoundByIdException)
            {
                rc = Results.NotFound(new
                {
                    title = "Not Found",
                    detail = ex.Message,
                    instance = app.Environment.EnvironmentName
                });
            }
            else if (ex is BadHttpRequestException)
            {
                rc = Results.BadRequest(new
                {
                    title = "Bad Request",
                    detail = "The request was invalid. " + ex.Message,
                    instance = app.Environment.EnvironmentName
                });
            }
            else if (ex is SaveException)
            {
                rc = Results.Problem(
                    title: "ASPA004/SaveChanges",
                    detail: "Failed to save changes: " + ex.Message,
                    instance: app.Environment.EnvironmentName,
                    statusCode: 500);
            }
            else if (ex is AddCelebrityException)
            {
                rc = Results.Problem(
                    title: "ASPA004/AddCelebrity",
                    detail: "Error adding celebrity: " + ex.Message,
                    instance: app.Environment.EnvironmentName,
                    statusCode: 500);
            }
            else
            {
                rc = Results.Problem(
                    title: "Internal Server Error",
                    detail: "An unexpected error occurred: " + ex.Message,
                    instance: app.Environment.EnvironmentName,
                    statusCode: 500);
            }
        }
        return rc;
    });

    app.Run();
}

public class FoundByIdException : Exception
{
    public FoundByIdException(string message) : base($"Found by Id: {message}") { }
}
public class SaveException : Exception
{
    public SaveException(string message) : base($"SaveChanges error: {message}") { }
}
public class AddCelebrityException : Exception
{
    public AddCelebrityException(string message) : base($"AddCelebrityException error: {message}") { }
}