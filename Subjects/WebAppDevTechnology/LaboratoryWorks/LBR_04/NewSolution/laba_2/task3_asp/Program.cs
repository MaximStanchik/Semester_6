using Microsoft.AspNetCore.Diagnostics;
using task1;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();

var app = builder.Build();

Repository.JSONFileName = "Celebrities.json";
using (IRepository repository = Repository.Create("Celebrities"))
{
    app.UseExceptionHandler("/Celebrities/Error");

    app.MapGet("/Celebrities", () => repository.GetAllCelebrities());

    app.MapGet("/Celebrities/{id:int}", (int id) => {
        Celebrity? celebrity = repository.GetCelebrityById(id);
       
        if (celebrity == null)
        {
            throw new FoundByIdException($"{id}");
        }

        return celebrity;
    });

    app.MapPost("/Celebrities", (Celebrity celebrity) => {
        int? id = repository.AddCelebrity(celebrity);

        if (id < 0)
        {
            switch (id)
            {
                case -1:
                    throw new AddCelebrityException("/Celebrities error with id");
                case -2:
                    throw new AddCelebrityException("/Celebrities error with value");
                case -3:                 
                    throw new AddCelebrityException($"Could not find file: {repository.GetFilePath().Replace("\\", "/")}");
                default:
                    throw new AddCelebrityException("/Celebrities unknown error");
            }
        }

        int saveResult = repository.SaveChanges();

        return Results.Created($"/Celebrities/{id}", celebrity with { Id = (int)id });
    });

    app.MapDelete("/Celebrities/{id:int}", (int id) => {
        if (!repository.DeleteCelebrityById(id))
        {
            throw new DeleteCelebrityException($"{id}");
        }
        else
        {
            repository.SaveChanges();
            return Results.Ok(new { message = $"Celebrity with Id = {id} deleted" });
        }
    });

    app.MapPut("/Celebrities/{id:int}", (int id, Celebrity celebrity) =>
    {
        var updatedId = repository.UpdCelebrityById(id, celebrity);

        if (updatedId < 0)
        {
            switch (updatedId)
            {
                case -1:
                    throw new SaveException("Incorrect location Id");
                case -2:
                    throw new SaveException("Incorrect new Id");
                case -3:
                    throw new SaveException("Incorrect values");
                case -4:
                    throw new SaveException($"Could not find file: {repository.GetFilePath().Replace("\\", "/")}");
                default:
                    throw new SaveException("Unknown error");
            }
        }

        repository.SaveChanges();

        return Results.Ok(new { message = $"Celebrity with Id = {updatedId} updated" });
    });

    app.MapFallback((HttpContext ctx) => Results.NotFound(new { error = $"i dont know this path {ctx.Request.Path}" }));

    app.Map("/Celebrities/Error", (HttpContext context) => {
        Exception? exc = context.Features.Get<IExceptionHandlerFeature>()?.Error;
        IResult res = Results.Problem(detail: "Panic", instance: app.Environment.EnvironmentName, title: "task3", statusCode: 500);

        if (exc != null)
        {
            if (exc is DeleteCelebrityException)
            {
                res = Results.Text($"{exc.Message}");
            }
            else if (exc is FoundByIdException)
            {
                res = Results.Text($"{exc.Message}");
            }
            else if (exc is SaveException)
            {
                res = Results.Problem(title: "task3/SaveChanges", detail: exc.Message, instance: app.Environment.EnvironmentName, statusCode: 500);
            }
            else if (exc is AddCelebrityException)
            {
                res = Results.Problem(title: "task3/AddCelebrity", detail: exc.Message, instance: app.Environment.EnvironmentName, statusCode: 500);
            }
        }
        return res;
    });

    app.Run();
}
public class FoundByIdException : Exception { public FoundByIdException(string message) : base($"Error found with Id: {message}") { } };
public class SaveException : Exception { public SaveException(string message) : base($"SaveChanges error: {message}") { } };
public class DeleteCelebrityException : Exception { public DeleteCelebrityException(string message) : base($"Error delete with Id: {message}") { } };
public class AddCelebrityException : Exception { public AddCelebrityException(string message) : base($"AddCelebrityException error: {message}") { } };

//еще задания 20 и 21