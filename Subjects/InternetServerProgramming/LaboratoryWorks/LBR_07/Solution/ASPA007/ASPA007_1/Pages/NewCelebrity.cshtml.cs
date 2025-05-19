using ASPA007_1.Config;
using DAL_Celebrity_MSSQL;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Options;
using System.Net.Http.Json;

namespace ASPA007_1.Pages
{
    public class NewCelebrityModel : PageModel
    {
        private readonly HttpClient _httpClient;
        private readonly IWebHostEnvironment _env;
        private readonly CelebritiesConfig _config;

        [BindProperty]
        public Celebrity Celebrity { get; set; }

        [BindProperty]
        public IFormFile ImageFile { get; set; }
        public string FolderPath => _config.PhotosRequestPath;
        public string NewCelImageName => "add-new.jpg";

        public NewCelebrityModel(
            IHttpClientFactory httpClientFactory,
            IWebHostEnvironment env,
            IOptions<CelebritiesConfig> config)
        {
            //_httpClient = httpClientFactory.CreateClient("CelebritiesAPI");
            _httpClient = httpClientFactory.CreateClient();
            _httpClient.BaseAddress = new Uri("https://localhost:7259");
            _env = env;
            _config = config.Value;
        }

        public void OnGet() { }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
                return Page();

            if (ImageFile != null && ImageFile.Length > 0)
            {
                // фотки
                var photoContent = new MultipartFormDataContent();
                photoContent.Add(new StreamContent(ImageFile.OpenReadStream()), "file", ImageFile.FileName);

                var photoResponse = await _httpClient.PostAsync("/api/photos/upload", photoContent);

                if (!photoResponse.IsSuccessStatusCode)
                {
                    ModelState.AddModelError("", "Ошибка загрузки фото");
                    return Page();
                }

                var photoResult = await photoResponse.Content.ReadFromJsonAsync<PhotoUploadResult>();
                Celebrity.ReqPhotoPath = photoResult.Path;
            }

            // Сохраняем данные для ConfirmCelebrity
            TempData["Name"] = Celebrity.FullName;
            TempData["Nationality"] = Celebrity.Nationality;
            TempData["ImagePath"] = Celebrity.ReqPhotoPath;
            TempData.Keep();

            return RedirectToPage("/ConfirmCelebrity");
        }

        private record PhotoUploadResult(string Path);
    }
}