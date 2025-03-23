using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using static System.Net.Mime.MediaTypeNames;

public static class TaskMapper
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);
        var app = builder.Build();
        TaskMapper.MapTask3(app);
        app.Run();
    }
    public static void MapTask3(this WebApplication app)
    {
        // --- A ---
        app.MapGet("/A/{x:int:max(100)}", (HttpContext context, int? x) =>
            Results.Ok(new { path = context.Request.Path.Value, x }));

        app.MapPost("/A/{x:int:range(0,100)}", (HttpContext context, int x) =>
            Results.Ok(new { path = context.Request.Path.Value, x }));

        app.MapPut("/A/{x:int:min(1)}/{y:int:min(1)}", (HttpContext context, int x, int y) =>
            Results.Ok(new { path = context.Request.Path.Value, x, y }));

        app.MapDelete("/A/{x:int:min(1)}-{y:int:range(1,100)}", (HttpContext context, int x, int y) =>
            Results.Ok(new { path = context.Request.Path.Value, x, y }));

        // --- B ---
        app.MapGet("/B/{x:float}", (HttpContext context, float x) =>
            Results.Ok(new { path = context.Request.Path.Value, x }));

        app.MapPost("/B/{x:float}/{y:float}", (HttpContext context, float x, float y) =>
            Results.Ok(new { path = context.Request.Path.Value, x, y }));

        app.MapDelete("/B/{x:float}-{y:float}", (HttpContext context, float x, float y) =>
            Results.Ok(new { path = context.Request.Path.Value, x, y }));

        // --- C ---
        app.MapGet("/C/{x:bool}", (HttpContext context, bool x) =>
            Results.Ok(new { path = context.Request.Path.Value, x }));

        app.MapPost("/C/{x:bool},{y:bool}", (HttpContext context, bool x, bool y) =>
            Results.Ok(new { path = context.Request.Path.Value, x, y }));

        // --- D ---
        app.MapGet("/D/{x:datetime}", (HttpContext context, DateTime x) =>
            Results.Ok(new { path = context.Request.Path.Value, x }));

        app.MapPost("/D/{x:datetime}|{y:datetime}", (HttpContext context, DateTime x, DateTime y) =>
            Results.Ok(new { path = context.Request.Path.Value, x, y }));

        // --- E ---
        app.MapGet("/E/12-{x}", (HttpContext context, string x) =>
            Results.Ok(new { path = context.Request.Path.Value, x }));

        app.MapPut("/E/{x:alpha:minlength(2):maxlength(12)}", (HttpContext context, string x) =>
            Results.Ok(new { path = context.Request.Path.Value, x }));

        // --- F ---
        app.MapPut("/F/{x:regex(^[\\w-\\.]+@([\\w-]+\\.)+by$)}", (HttpContext context, string x) =>
            Results.Ok(new { path = context.Request.Path.Value, x }));
        app.MapFallback((HttpContext ctx) => { return Results.NotFound(new { message = $"path {ctx.Request.Path.Value} not supported" }); });
        app.Map("/Error", (HttpContext ctx) =>
        {
            Exception? ex = ctx.Features.Get<IExceptionHandlerFeature>()?.Error;
            return Results.Ok(new { message = ex?.Message });
        });
    }
}