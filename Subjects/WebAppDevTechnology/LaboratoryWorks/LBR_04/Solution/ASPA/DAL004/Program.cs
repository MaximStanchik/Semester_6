using Newtonsoft.Json;

namespace DAL004
{
    public class CelebrityRepository : IRepository
    {
        public static string JSONFileName = "Celebrities.json";
        private List<Celebrity> celebrities;
        public string BasePath
        {
            get;
        }
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
            celebrities = JsonConvert.DeserializeObject<List<Celebrity>>(jsonData) ?? new List<Celebrity>();
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
            var celebrity = getCelebrityById(id);
            return celebrity?.PhotoPath;
        }
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }

        public int? addCelebrity(Celebrity celebrity) 
        {
            if (celebrity == null)
            {
                return null;
            }

            celebrities.Add(celebrity);
            return celebrity.Id; 
        }

        public bool delCelebrityById(int id) 
        {
            var celebrity = getCelebrityById(id);
            if (celebrity == null)
            {
                return false; 
            }

            celebrities.Remove(celebrity);
            return true; 
        }
        public int? updCelebrityById(int id, Celebrity celebrity)
        {
            var existingCelebrity = getCelebrityById(id);
            if (existingCelebrity == null)
            {
                return null; 
            }

            var updatedCelebrity = existingCelebrity with
            {
                FirstName = celebrity.FirstName, 
                Surname = celebrity.Surname, 
                PhotoPath = celebrity.PhotoPath 
            };

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
            var jsonData = JsonConvert.SerializeObject(celebrities);
            File.WriteAllText(Path.Combine(BasePath, JSONFileName), jsonData);

            return celebrities.Count; 
        }
    }
}
