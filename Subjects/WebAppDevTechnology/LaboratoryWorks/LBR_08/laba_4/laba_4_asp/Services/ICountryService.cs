using laba_4_asp.Models;

namespace laba_4_asp.Services
{
    public interface ICountryService
    {
        IEnumerable<Country> GetCountries();
    }
}
