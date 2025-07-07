using Microsoft.AspNetCore.Html;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace LBR_08.Helpers
{
    public static class CelebrityHelpers
    {
        public static IHtmlContent CelebrityPhoto(this IHtmlHelper html, int id, string photoPath, string fullName)
        {
            var imgTag = new TagBuilder("img");
            imgTag.AddCssClass("celebrity-photo");
            imgTag.Attributes.Add("src", $"/api/cel/photo/{photoPath}");
            imgTag.Attributes.Add("alt", fullName);
            imgTag.Attributes.Add("title", fullName);
            imgTag.Attributes.Add("onclick", $"location.href='/Celebrities/Details/{id}'");
            imgTag.Attributes.Add("onload", @"
                let h = this.height; 
                let w = this.width;
                let k = this.naturalWidth / this.naturalHeight;
                if(h != 0 && w == 0) { this.width = k * h; }
                if(h == 0 && w != 0) { this.height = w / k; }
            ");

            return imgTag;
        }
    }
}