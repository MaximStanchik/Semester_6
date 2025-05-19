using ASPA006_1.classes;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace ASPA006_1.controllers
{
    public class CelebritiesController : Controller
    {
        private readonly CelebritiesConfig _config;

        public CelebritiesController(IOptions<CelebritiesConfig> options)
        {
            _config = options.Value;
        }

        public IActionResult Index()
        {
            var connStr = _config.ConnectionString;
            var folder = _config.PhotosFolder;

            ViewBag.ConnStr = connStr;
            ViewBag.Photos = folder;

            return View();
        }
    }
}
