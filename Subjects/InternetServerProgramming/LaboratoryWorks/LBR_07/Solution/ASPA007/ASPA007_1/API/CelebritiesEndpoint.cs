using DAL_Celebrity_MSSQL;
using Microsoft.AspNetCore.Mvc;

namespace ASPA007_1.API
{
    public static class CelebritiesEndpoints
    {
        public static void MapCelebritiesEndpoints(this IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/api/celebrities")
                          .WithTags("Celebrities API");

            // Получить всех знаменитостей
            group.MapGet("/", async (IRepository repo) =>
            {
                var celebrities = repo.GetAllCelebrities();
                return Results.Ok(celebrities);
            })
            .Produces<List<Celebrity>>(StatusCodes.Status200OK)
            .WithName("GetAllCelebrities");

            // Получить знаменитость по ID
            group.MapGet("/{id:int}", async (int id, IRepository repo) =>
            {
                var celebrity = repo.GetCelebrityById(id);
                return celebrity is not null
                    ? Results.Ok(celebrity)
                    : Results.NotFound();
            })
            .Produces<Celebrity>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status404NotFound)
            .WithName("GetCelebrityById");

            // Создать новую знаменитость
            group.MapPost("/", async ([FromBody] Celebrity celebrity, IRepository repo) =>
            {
                repo.AddCelebrity(celebrity);
                return Results.Created($"/api/celebrities/{celebrity.Id}", celebrity);
            })
            .Accepts<Celebrity>("application/json")
            .Produces<Celebrity>(StatusCodes.Status201Created)
            .WithName("CreateCelebrity");

            // Обновить знаменитость
            group.MapPut("/{id:int}", async (int id, [FromBody] Celebrity updatedCelebrity, IRepository repo) =>
            {
                var existing = repo.GetCelebrityById(id);
                if (existing is null)
                    return Results.NotFound();

                repo.UpdCelebrity(id, updatedCelebrity);
                return Results.NoContent();
            })
            .Produces(StatusCodes.Status204NoContent)
            .Produces(StatusCodes.Status404NotFound)
            .WithName("UpdateCelebrity");

            // Удалить знаменитость
            group.MapDelete("/{id:int}", async (int id, IRepository repo) =>
            {
                var success = repo.DelCelebrity(id);
                return success
                    ? Results.NoContent()
                    : Results.NotFound();
            })
            .Produces(StatusCodes.Status204NoContent)
            .Produces(StatusCodes.Status404NotFound)
            .WithName("DeleteCelebrity");
        }
    }
}
