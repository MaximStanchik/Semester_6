var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseStaticFiles();

app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new Microsoft.Extensions.FileProviders.PhysicalFileProvider(
        Path.Combine(Directory.GetCurrentDirectory(), "Picture")),
    RequestPath = "/static"
});

app.MapGet("/aspnetcore", async context =>
{
    await context.Response.WriteAsync("<h1>Welcome to ASP.NET Core!</h1>");
});

app.MapGet("/", async context =>
{
    context.Response.Redirect("/Neumann.html");
});

app.Run();