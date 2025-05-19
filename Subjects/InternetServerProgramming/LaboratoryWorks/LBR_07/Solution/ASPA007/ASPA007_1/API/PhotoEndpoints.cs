using ASPA007_1.Config;
using Microsoft.Extensions.Options;

namespace ASPA007_1.API
{
    public static class PhotoEndpoints
    {
        public static void MapPhotoEndpoints(this IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/api/photos")
                          .WithTags("Photos API")
                          .DisableAntiforgery();

            group.MapPost("/upload", async (IFormFile file, IOptions<CelebritiesConfig> config) =>
            {
          
                if (file == null || file.Length == 0)
                    return Results.BadRequest("No file uploaded");

                var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".gif" };
                var fileExtension = Path.GetExtension(file.FileName).ToLowerInvariant();

                if (!allowedExtensions.Contains(fileExtension))
                    return Results.BadRequest("Invalid file type");

                var uploadsFolder = config.Value.PhotosFolder;
                Directory.CreateDirectory(uploadsFolder);
                var fileName = $"{Guid.NewGuid()}{fileExtension}";
                var filePath = Path.Combine(uploadsFolder, fileName);

                await using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }
                var publicUrl = $"/{fileName}";
                return Results.Ok(new { Path = publicUrl });
            })
            .Accepts<IFormFile>("multipart/form-data")
            .Produces(StatusCodes.Status200OK, typeof(PhotoUploadResponse))
            .Produces(StatusCodes.Status400BadRequest)
            .WithName("UploadPhoto");

            group.MapDelete("/{fileName}", (string fileName, IOptions<CelebritiesConfig> config) =>
            {
                var uploadsFolder = config.Value.PhotosFolder;
                var filePath = Path.Combine(uploadsFolder, fileName);

                if (!System.IO.File.Exists(filePath))
                    return Results.NotFound();

                System.IO.File.Delete(filePath);
                return Results.NoContent();
            })
            .Produces(StatusCodes.Status204NoContent)
            .Produces(StatusCodes.Status404NotFound)
            .WithName("DeletePhoto");
        }

        private record PhotoUploadResponse(string Path);
    }
}
