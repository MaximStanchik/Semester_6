using DAL_Celebrity_MSSQL;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

public class WikipediaLinksFilter : IActionFilter
{
    public void OnActionExecuting(ActionExecutingContext context) { }

    public void OnActionExecuted(ActionExecutedContext context)
    {
        if (context.Controller is Controller controller &&
            context.Result is ViewResult viewResult &&
            viewResult.Model is Celebrity celebrity)
        {
            string wikipediaUrl = GenerateWikipediaUrl(celebrity.FullName);

            controller.ViewBag.WikipediaLinks = new List<string> { wikipediaUrl };
        }
    }

    private string GenerateWikipediaUrl(string fullName)
    {
        string encodedName = Uri.EscapeDataString(fullName);
        return $"https://en.wikipedia.org/wiki/Special:Search?search={encodedName}&go=Go";
    }
}