using ASPA007_1.Config;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Options;
using System.Net.Http;
using DAL_Celebrity_MSSQL;
namespace ASPA007_1.Pages
{
    public class celebrityModel : PageModel
    {
        HttpClient _httpClient;
        private readonly CelebritiesConfig _config;

        public Celebrity Celebrity { get; set; }
        public string ImagesPath => _config.PhotosRequestPath;

        public celebrityModel(IHttpClientFactory httpClientFactory, IOptions<CelebritiesConfig> config)
        {
            _httpClient = httpClientFactory.CreateClient();
            _httpClient.BaseAddress = new Uri("https://localhost:7259");
            _config = config.Value;
        }

        public async Task<IActionResult> OnGet(int id)
        {
            Celebrity = await _httpClient.GetFromJsonAsync<Celebrity>($"/api/celebrities/{id}");
            if (Celebrity == null)
                return NotFound();

            return Page();
        }
    }
}
