namespace laba4_asp.Classes
{
    public class CelebritiesConfig
    {
        public string ConnectionString { get; set; }
        public string PhotosFolder { get; set; }

        public CelebritiesConfig()
        {
            ConnectionString = string.Empty;
            PhotosFolder = string.Empty;
        }
    }
}
