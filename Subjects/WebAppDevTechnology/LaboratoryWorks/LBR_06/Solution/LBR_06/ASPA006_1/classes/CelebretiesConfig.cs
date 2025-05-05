namespace ASPA006_1.classes
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
