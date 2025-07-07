using LBR_08.Classes;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using DAL_Celebrity_MSSQL;
using LBR_08.Models;
using System.Text.Json;

public class CelebritiesController : Controller
{
    private readonly CelebritiesConfig _config;
    private readonly IRepository _repository;
    private readonly IWebHostEnvironment _env;

    public CelebritiesController(IOptions<CelebritiesConfig> options, IRepository repository, IWebHostEnvironment env)
    {
        _config = options.Value;
        _repository = repository;
        _env = env;
    }

    private List<Country> LoadCountries()
    {
        var path = Path.Combine(_env.ContentRootPath, "CountryCodes", "Codes.json");
        var json = System.IO.File.ReadAllText(path);

        var options = new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true 
        };

        var result = JsonSerializer.Deserialize<List<Country>>(json, options);
        return result ?? new List<Country>();
    }

    [HttpGet]
    public IActionResult New()
    {
        var countries = LoadCountries();
        if (countries == null || !countries.Any())
        {
            ViewBag.Error = "Could not load country list";
        }
        ViewBag.Countries = countries ?? new List<Country>();
        return View();
    }

    [HttpPost]
    public IActionResult New(string fullName, string nationality, IFormFile photoPath)
    {
        if (string.IsNullOrWhiteSpace(fullName))
            return ViewWithError("Full name error");

        nationality = nationality?.ToUpper() ?? "";
        if (nationality.Length != 2)
            return ViewWithError("Nationality error");

        if (photoPath == null || photoPath.Length == 0)
            return ViewWithError("Photo Error");

        string photoFileName = ProcessUploadedFile(photoPath);
        if (photoFileName == null)
            return ViewWithError("Photo error");

        var celebrity = new Celebrity
        {
            FullName = fullName,
            Nationality = nationality,
            ReqPhotoPath = photoFileName
        };

        if (!_repository.AddCelebrity(celebrity))
            return ViewWithError("Error with data base");

        return Redirect("/");
    }

    private IActionResult ViewWithError(string error)
    {
        ViewBag.Error = error;
        return View("New");
    }

    private string ProcessUploadedFile(IFormFile file)
    {
        var extension = Path.GetExtension(file.FileName).ToLower();
        if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
            return null!;

        var fileName = Path.GetFileNameWithoutExtension(file.FileName);
        var cleanFileName = string.Join("_", fileName.Split(Path.GetInvalidFileNameChars()));

        var timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");
        var finalFileName = $"{cleanFileName}_{timestamp}{extension}";

        var uploadsFolder = Path.Combine(_env.ContentRootPath, "Photos");
        Directory.CreateDirectory(uploadsFolder);

        var filePath = Path.Combine(uploadsFolder, finalFileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
        {
            file.CopyTo(stream);
        }

        return finalFileName;
    }

    [HttpGet]
    [ServiceFilter(typeof(WikipediaLinksFilter))]
    public IActionResult Details(int id)
    {
        var countries = LoadCountries();
        if (countries == null || !countries.Any())
        {
            ViewBag.Error = "Could not load country list";
        }
        ViewBag.Countries = countries ?? new List<Country>();

        var celebrity = _repository.GetCelebrityById(id);
        if (celebrity == null)
        {
            return NotFound();
        }

        var lifeEvents = _repository.GetLifeeventsByCelebrityId(id);

        ViewBag.LifeEvents = lifeEvents;
        return View(celebrity);
    }

    [HttpPost]
    public IActionResult Update(int id, string fullName, string nationality, IFormFile photoPath)
    {
        if (string.IsNullOrWhiteSpace(fullName))
            return RedirectToAction("Details", new { id });

        nationality = nationality?.ToUpper() ?? "";
        if (nationality.Length != 2)
            return RedirectToAction("Details", new { id });

        var celebrity = _repository.GetCelebrityById(id);
        if (celebrity == null)
            return NotFound();

        var photoFileName = celebrity.ReqPhotoPath!;

        if (photoPath != null && photoPath.Length > 0)
        {
            var oldPhotoPath = Path.Combine(_env.ContentRootPath, "Photos", celebrity.ReqPhotoPath!);
            if (System.IO.File.Exists(oldPhotoPath))
            {
                System.IO.File.Delete(oldPhotoPath);
            }

            photoFileName = ProcessUploadedFile(photoPath);
            if (photoFileName == null)
                return RedirectToAction("Details", new { id });
        }

        var updatedCelebrity = new Celebrity
        {
            FullName = fullName,
            Nationality = nationality,
            ReqPhotoPath = photoFileName
        };

        if (!_repository.UpdCelebrity(id, updatedCelebrity))
            return RedirectToAction("Details", new { id });

        return RedirectToAction("Details", new { id });
    }

    [HttpPost]
    public IActionResult Delete(int id)
    {
        var celebrity = _repository.GetCelebrityById(id);
        if (celebrity == null)
            return NotFound();

        var photoPath = Path.Combine(_env.ContentRootPath, "Photos", celebrity.ReqPhotoPath!);
        if (System.IO.File.Exists(photoPath))
        {
            System.IO.File.Delete(photoPath);
        }

        if (!_repository.DelCelebrity(id))
            return RedirectToAction("Details", new { id });

        return Redirect("/");
    }
} 