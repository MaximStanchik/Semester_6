using LBR_08.Models;

namespace LBR_08.Services
{
    public interface ICountryService
    {
        IEnumerable<Country> GetCountries();
    }
}
