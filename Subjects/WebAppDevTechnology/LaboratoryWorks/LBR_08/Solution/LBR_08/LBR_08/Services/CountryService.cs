using System.Text.Json;
using LBR_08.Models;

namespace LBR_08.Services
{
    public class CountryService : ICountryService
    {
        private readonly IWebHostEnvironment _env;
        private List<Country> _countries;

        public CountryService(IWebHostEnvironment env)
        {
            _env = env;
            _countries = new List<Country>();
        }

        public IEnumerable<Country> GetCountries()
        {
            var filePath = Path.Combine(_env.ContentRootPath, "CountryCodes", "Codes.json");

            try
            {
                var json = File.ReadAllText(filePath);
                _countries = JsonSerializer.Deserialize<List<Country>>(json) ?? _countries!;
                return _countries;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading countries: {ex.Message}");
                return new List<Country>();
            }
        }
    }
}