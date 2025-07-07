using System.Text.Json.Serialization;

namespace laba_4_asp.Models
{
    public class Country
    {
        [JsonPropertyName("countryLabel")]
        public string CountryLabel { get; set; }

        [JsonPropertyName("code")]
        public string Code { get; set; }
    }
}
