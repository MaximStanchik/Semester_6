var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseStaticFiles();  
app.MapGet("/", async context =>
{
    context.Response.Redirect("/Index.html");
});

app.MapGet("/Neumann", async context =>
{
    context.Response.Redirect("/Neumann.html");
});

app.MapGet("/aspnetcore", async context =>
{
    await context.Response.WriteAsync("<h1>Welcome to ASP.NET Core!</h1>");
});

app.Run();

