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
    });

    app.MapDelete("/Celebrities/{id:int}", (int id) => {
        Console.WriteLine($"Attempting to delete Celebrity with Id: {id}");
        bool deleted = repository.delCelebrityById(id);

        if (!deleted)
        {
            throw new DeleteCelebrityException($"{id}");
        }
        else
        {
            repository.SaveChanges();
            return Results.Ok(new { message = $"Celebrity with Id = {id} deleted." });
        }
    });

    app.MapPut("/Celebrities/{id:int}", (int id, Celebrity celebrity) =>
    {
        Console.WriteLine($"Attempting to update Celebrity with Id: {id}");

        var existingCelebrity = repository.getCelebrityById(id);
        if (existingCelebrity == null)
        {
            throw new PutCelebrityException($"id"); 
        }

        celebrity = celebrity with { Id = id }; 
        var updatedId = repository.updCelebrityById(id, celebrity);

        if (updatedId == null)
        {
            throw new SaveException("Failed to update the celebrity."); 
        }

        repository.SaveChanges();

        return Results.Ok(new { message = $"Celebrity with Id = {updatedId} updated." });
    });

    app.MapFallback((HttpContext ctx) => Results.NotFound(new { error = $"path {ctx.Request.Path} not supported" }));

    app.Map("/Celebrities/Error", (HttpContext ctx) => {
        Exception? ex = ctx.Features.Get<IExceptionHandlerFeature>()?.Error;
        IResult rc = Results.Problem(detail: "Panic", instance: app.Environment.EnvironmentName, title: "ASPA004", statusCode: 500);

        if (ex != null)
        {
            if (ex is PutCelebrityException)
            {
                rc = Results.Text($"{ex.Message}");
            }
            else if (ex is DeleteCelebrityException)
            {
                rc = Results.Text($"{ex.Message}");
            }
            else if (ex is FoundByIdException)
            {
                rc = Results.Text($"{ex.Message}");
            }
            else if (ex is BadHttpRequestException)
            {
                rc = Results.BadRequest(ex.Message);
            }
            else if (ex is SaveException)
            {
                rc = Results.Problem(title: "ASPA004/SaveChanges", detail: ex.Message, instance: app.Environment.EnvironmentName, statusCode: 500);
            }
            else if (ex is AddCelebrityException)
            {
                rc = Results.Problem(title: "ASPA004/addCelebrity", detail: ex.Message, instance: app.Environment.EnvironmentName, statusCode: 500);
            }
        }
        return rc;
    });

    app.Run();


}
public class PutCelebrityException : Exception { public PutCelebrityException(string message) : base($"Put by Id: {message}") { } };
public class DeleteCelebrityException : Exception { public DeleteCelebrityException(string message) : base($"Delete by Id: {message}") { } };
public class FoundByIdException : Exception { public FoundByIdException(string message) : base($"Found by Id: {message}") { } };
public class SaveException : Exception { public SaveException(string message) : base($"SaveChanges error: {message}") { } };
public class AddCelebrityException : Exception { public AddCelebrityException(string message) : base($"AddCelebrityException error: {message}") { } };

//21, 21, исправить консольное приложение, рассказать про using и delete, рукопожатие