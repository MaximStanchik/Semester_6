using ASPA06.Exceptions;
using System.Net;

namespace ASPA06.Middleware
{
    public class ErrorHandlingMiddleware
    {
        private readonly RequestDelegate _next;

        public ErrorHandlingMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch(ObjectNotFoundException ex)
            {
                context.Response.StatusCode = (int)HttpStatusCode.NotFound;
                await HandleExceptionAsync(context, ex);
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                await HandleExceptionAsync(context, ex);
            }
        }

        private Task HandleExceptionAsync(HttpContext context, Exception ex)
        {
            // Логируем ошибку (можно добавить более детальную логику логирования)
            Console.WriteLine($"An error occurred: {ex.Message}");

            context.Response.ContentType = "application/json";
            

            var result = new { message = "Internal Server Error", detail = ex.Message };
            return context.Response.WriteAsJsonAsync(result);
        }
    }
}
