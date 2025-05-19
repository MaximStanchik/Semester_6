using ASPA007_1.Config;
using DAL_Celebrity_MSSQL;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Options;

namespace ASPA007_1.Pages
{
    public class celebritiesModel : PageModel
    {
        HttpClient _httpClient;
        private readonly CelebritiesConfig _config;

        public celebritiesModel(IHttpClientFactory httpClientFactory, IOptions<CelebritiesConfig> config)
        {
            _httpClient = httpClientFactory.CreateClient();
            _httpClient.BaseAddress = new Uri("https://localhost:7259");
            _config = config.Value;
        }

        public List<Celebrity> Celebrities { get; set; }
        public string ImagesPath => _config.PhotosRequestPath;

        public async Task OnGet()
        {
            Celebrities = await _httpClient.GetFromJsonAsync<List<Celebrity>>("/api/celebrities");
        }
    }
}
