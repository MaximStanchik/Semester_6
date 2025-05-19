using ASPA007_1.Config;
using DAL_Celebrity_MSSQL;
using Microsoft.Extensions.Options;

namespace ASPA007_1.Extensions
{
    public static class CelebritiesExtensions
    {
        public static WebApplicationBuilder AddCelebritiesConfiguration(this WebApplicationBuilder builder)
        {
            builder.Configuration.AddJsonFile("Celebrities.config.json", optional: false, reloadOnChange: true);

            builder.Services.Configure<CelebritiesConfig>(builder.Configuration.GetSection("Celebrities"));

            return builder;
        }

        public static WebApplicationBuilder AddCelebritiesServices(this WebApplicationBuilder builder)
        {
            builder.Services.AddScoped<IRepository, Repository>((IServiceProvider provider) => {
                CelebritiesConfig config = provider.GetRequiredService<IOptions<CelebritiesConfig>>().Value;
                return new Repository(config.ConnectionString);
            });
            return builder;
        }   
    }
}
