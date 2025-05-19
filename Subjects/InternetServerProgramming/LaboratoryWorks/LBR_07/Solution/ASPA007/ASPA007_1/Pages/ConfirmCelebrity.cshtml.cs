using ASPA007_1.Config;
using DAL_Celebrity_MSSQL;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Options;
using System.Net;
using System.Net.Http.Json;

namespace ASPA007_1.Pages
{
    public class ConfirmCelebrityModel : PageModel
    {
        private readonly HttpClient _httpClient;
        private readonly CelebritiesConfig _config;

        public ConfirmCelebrityModel(
            IHttpClientFactory httpClientFactory,
            IOptions<CelebritiesConfig> config)
        {
            //_httpClient = httpClientFactory.CreateClient("CelebritiesAPI");
            _httpClient = httpClientFactory.CreateClient();
            _httpClient.BaseAddress = new Uri("https://localhost:7259");
            _config = config.Value;
        }

        [BindProperty]
        public Celebrity Celebrity { get; set; }
        public string PhotoPath => _config.PhotosRequestPath;

        public IActionResult OnGet()
        {
            if (TempData["Name"] == null || TempData["Nationality"] == null)
            {
                return RedirectToPage("/NewCelebrity");
            }

            Celebrity = new Celebrity
            {
                FullName = TempData["Name"]?.ToString(),
                Nationality = TempData["Nationality"]?.ToString(),
                ReqPhotoPath = TempData["ImagePath"]?.ToString()
            };

            TempData.Keep();
            return Page();
        }

        public async Task<IActionResult> OnPostConfirmAsync()
        {
            try
            {
                var celebrity = new Celebrity
                {
                    FullName = TempData["Name"]?.ToString(),
                    Nationality = TempData["Nationality"]?.ToString(),
                    ReqPhotoPath = TempData["ImagePath"]?.ToString()
                };

                var response = await _httpClient.PostAsJsonAsync("/api/celebrities", celebrity);

                if (response.IsSuccessStatusCode)
                {
                    return RedirectToPage("celebrities");
                }

                ModelState.AddModelError("", $"API error: {response.StatusCode}");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "An error occurred. Please try again.");
            }

            return Page();
        }

        public async Task<IActionResult> OnPostCancelAsync()
        {
            try
            {
                var imagePath = TempData["ImagePath"]?.ToString();
                if (!string.IsNullOrEmpty(imagePath))
                {
                    var fileName = Path.GetFileName(imagePath);
                    var response = await _httpClient.DeleteAsync($"/api/photos/{WebUtility.UrlEncode(fileName)}");

                    
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message, "Error while canceling celebrity creation");
            }

            return RedirectToPage("celebrities");
        }
    }
}