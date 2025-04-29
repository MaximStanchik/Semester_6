using Newtonsoft.Json;

namespace DAL004
{
    public class CelebrityRepository : IRepository
    {
        private List<Celebrity> celebrities;
        public static string JSONFileName = "Celebrities.json";
        public string BasePath { get; }

        public static IRepository Create(string basepath)
        {
            return new CelebrityRepository(basepath);
        }

        public CelebrityRepository(string basepath)
        {
            BasePath = Path.Combine(Directory.GetCurrentDirectory(), basepath);
            loadData();
        }

        private void loadData()
        {
            var filePath = Path.Combine(BasePath, JSONFileName);
            if (!File.Exists(filePath))
            {
                throw new FileNotFoundException("JSON file not found.", filePath);
            }
            var jsonData = File.ReadAllText(filePath);
            this.celebrities = JsonConvert.DeserializeObject<List<Celebrity>>(jsonData) ?? new List<Celebrity>();
        }

        public Celebrity[] getAllCelebrities()
        {
            return celebrities.ToArray();
        }

        public Celebrity? getCelebrityById(int id)
        {
            return celebrities.FirstOrDefault(c => c.Id == id);
        }

        public Celebrity[] getCelebritiesBySurname(string Surname)
        {
            return celebrities.Where(c => c.Surname.Equals(Surname, StringComparison.OrdinalIgnoreCase)).ToArray();
        }

        public string? getPhotoPathById(int id)
        {
            return getCelebrityById(id)?.PhotoPath.ToString();
        }

        public int? addCelebrity(Celebrity celebrity)
        {
            if (!FileIsExist())
            {
                Console.WriteLine("Error path");
                return null;
            }
            else if (celebrity.Id < 0 || celebrity.Id != 0)
            {
                Console.WriteLine("Incorrect id");
                return null;
            }
            else if (celebrity == null)
            {
                Console.WriteLine("Celebrity is null");
                return null;
            }
            else
            {
                int newId = celebrities.Count > 0 ? celebrities.Max(c => c.Id) + 1 : 1;
                Console.WriteLine($"Assigning new ID: {newId} for {celebrity.FirstName} {celebrity.Surname}");
                celebrity = celebrity with { Id = newId };
                celebrities.Add(celebrity);
                SaveChanges();
                return newId;
            }
        }

        public bool delCelebrityById(int id)
        {
            var celebrity = getCelebrityById(id);
            if (celebrity == null)
            {
                return false;
            }
            celebrities.Remove(celebrity);
            SaveChanges();
            return true;
        }

        public int? updCelebrityById(int id, Celebrity celebrity)
        {
            var existingCelebrity = getCelebrityById(id);
            if (existingCelebrity == null)
            {
                return null;
            }
            var updatedCelebrity = existingCelebrity with { FirstName = celebrity.FirstName, Surname = celebrity.Surname, PhotoPath = celebrity.PhotoPath };
            var index = celebrities.FindIndex(c => c.Id == id);
            if (index != -1)
            {
                celebrities[index] = updatedCelebrity;
            }
            SaveChanges();
            return updatedCelebrity.Id;
        }

        public int SaveChanges()
        {
            var jsonData = JsonConvert.SerializeObject(celebrities, Formatting.Indented);
            File.WriteAllText(Path.Combine(BasePath, JSONFileName), jsonData);
            return celebrities.Count;
        }

        public void Dispose()
        {
            celebrities?.Clear();
            celebrities = null;
            GC.SuppressFinalize(this);
        }

        public string getFilePath() => Path.Combine(BasePath, JSONFileName);

        private bool FileIsExist() => File.Exists(getFilePath());
    }
}