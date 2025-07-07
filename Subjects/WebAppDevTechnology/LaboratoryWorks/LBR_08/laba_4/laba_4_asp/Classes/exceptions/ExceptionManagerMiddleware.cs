namespace exceptions
{
    public class ExceptionManagerMiddleware
    {
        private readonly RequestDelegate _next;

        public ExceptionManagerMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception e)
            {
                SetStatus(context);

                var response = new
                {
                    error = "Error",
                    details = e.Message
                };

                await context.Response.WriteAsJsonAsync(response);
            }
        }
        private void SetStatus(HttpContext context)
        {
            context.Response.StatusCode = 500;
            context.Response.ContentType = "application/json";
        }
    }
}
