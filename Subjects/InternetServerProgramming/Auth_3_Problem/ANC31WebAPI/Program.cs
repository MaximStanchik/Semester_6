    
 using ANC25_WEBAPI_DLL;
using Microsoft.AspNetCore.Identity;

internal class Program
{
        private static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

        builder.AddCelebritiesConfiguration();
        builder.AddCelebritiesServices();
        
        builder.AddCelebritiesAuthServices();
        builder.Services.AddAuthorization();

        builder.Services.AddControllers();

        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();

        var app = builder.Build();
                 
        if (app.Environment.IsDevelopment())
        {
                app.UseSwagger();
                app.UseSwaggerUI();
        }
        app.UseCookiePolicy();
        app.UseAuthentication();
        app.UseAuthorization();

         app.MapCelebrities();
        // app.MapLifeevents();
        //app.MapPhotoCelebrities();
              
         app.MapControllers();
         app.Run();
         Console.ReadLine();    
        }
    }

//CookiePolicyOptions oo = new CookiePolicyOptions();
//oo.HttpOnly = Microsoft.AspNetCore.CookiePolicy.HttpOnlyPolicy.Always;
//oo.OnDeleteCookie = (cookie) => { 
//    int  k = 1;
//};
// app.UseCelerbritiesErrorHandler("ANC28");