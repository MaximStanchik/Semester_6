using System.Text.Json.Serialization;

namespace LBR_08.Models
{
    public class Country
    {
        [JsonPropertyName("countryLabel")]
        public string CountryLabel { get; set; }

        [JsonPropertyName("code")]
        public string Code { get; set; }
    }
}
