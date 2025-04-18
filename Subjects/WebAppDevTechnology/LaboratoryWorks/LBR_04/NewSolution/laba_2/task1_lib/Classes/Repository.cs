using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace task1
{
    public class Repository : IRepository
    {
        public static string JSONFileName { get; set; } = "data.json";
        public string BasePath { get; }
        private List<Celebrity> _celebrities;
        private static int ChangesCount;

        private Repository(string directory)
        {
            BasePath = Path.Combine(Directory.GetCurrentDirectory(), directory);
            ChangesCount = 0;
            _celebrities = new List<Celebrity>();
            JsonDeserialize();
        }

        public IEnumerable<Celebrity> GetAllCelebrities() => _celebrities;
        public Celebrity? GetCelebrityById(int id) => _celebrities.FirstOrDefault(c => c.Id == id);
        public IEnumerable<Celebrity> GetCelebritiesBySurname(string surname) => _celebrities.Where(c => c.Surname.Equals(surname, StringComparison.OrdinalIgnoreCase)).ToArray();
        public string? GetPhotoPathById(int id) => GetCelebrityById(id)?.PhotoPath.ToString();
        public string GetFilePath() => Path.Combine(BasePath, JSONFileName);
        public void Dispose() { }

        public int AddCelebrity(Celebrity celebrity)
        {
            if (!FileIsExist())
            {
                return -3; // Error path
            }
            else if (_celebrities.Exists(c => c.Id == celebrity.Id) || celebrity.Id < 0)
            {
                return -1; // Incorrect Id
            }
            else if (string.IsNullOrEmpty(celebrity.Firstname) || celebrity.Firstname.Count() >= 50 ||
                string.IsNullOrEmpty(celebrity.Surname) || celebrity.Surname.Count() >= 50 ||
                string.IsNullOrEmpty(celebrity.PhotoPath) || celebrity.PhotoPath.Count() >= 150)
            {
                return -2; // Incorect values
            }

            _celebrities.Add(celebrity);
            ChangesCount++;

            return celebrity.Id; // All correct
        }


        public int UpdCelebrityById(int id, Celebrity celebrity)
        {
            if (!FileIsExist())
            {
                return -4; // Error path
            }
            else if (!_celebrities.Exists(c => c.Id == id))
            {
                return -1; // Incorrect first Id
            }
            else if (string.IsNullOrEmpty(celebrity.Id.ToString()) ||
                celebrity.Id < 0 ||
               (celebrity.Id != id && _celebrities.Exists(c => c.Id == celebrity.Id)))
            {
                return -2; // Incorrect second Id
            }
            else if (string.IsNullOrEmpty(celebrity.Firstname) || celebrity.Firstname.Count() >= 50 ||
                string.IsNullOrEmpty(celebrity.Surname) || celebrity.Surname.Count() >= 50 ||
                string.IsNullOrEmpty(celebrity.PhotoPath) || celebrity.PhotoPath.Count() >= 150)
            {
                return -3; // Incorect values
            }

            _celebrities.Remove(_celebrities.First(c => c.Id == id));
            _celebrities.Add(celebrity);
            ChangesCount++;

            return celebrity.Id;
        }
        public bool DeleteCelebrityById(int id)
        {
            var delCelebrity = _celebrities.FirstOrDefault(c => c.Id == id);

            if (delCelebrity == null)
            {
                return false;
            }

            _celebrities.Remove(delCelebrity);
            ChangesCount++;

            return true;
        }

        public int SaveChanges()
        {
            if (ChangesCount == 0)
            {
                return ChangesCount;
            }

            var changes = ChangesCount;

            UpdateJson();

            return changes;
        }

        // help 

        public static IRepository Create(string directory)
        {
            return new Repository(directory);
        }

        private void UpdateJson()
        {
            string jsonFilePath = GetFilePath();

            var options = new JsonSerializerOptions
            {
                WriteIndented = true
            };

            using (FileStream fs = new FileStream(jsonFilePath, FileMode.Create, FileAccess.Write))
            {
                JsonSerializer.Serialize(fs, _celebrities, options);
            }

            ChangesCount = 0;

            JsonDeserialize();
        }
        private void JsonDeserialize()
        {
            string jsonFilePath = GetFilePath();

            if (!File.Exists(jsonFilePath))
            {
                Directory.CreateDirectory(Path.GetDirectoryName(jsonFilePath) ?? "");
                using (File.Create(jsonFilePath))
                    _celebrities = new List<Celebrity>();
            }

            var options = new JsonSerializerOptions
            {
                WriteIndented = true
            };

            try
            {
                using (FileStream fs = new FileStream(jsonFilePath, FileMode.Open, FileAccess.Read))
                {
                    _celebrities = JsonSerializer.Deserialize<List<Celebrity>>(fs, options) ?? new List<Celebrity>();
                }
            }
            catch (JsonException ex)
            {
                if (_celebrities.Count <= 0)
                {
                    Console.WriteLine($"Errro: File is completely empty");
                }
                else
                {
                    Console.WriteLine($"Error with file: {ex.Message}");
                }
                _celebrities = new List<Celebrity>();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                _celebrities = new List<Celebrity>();
            }
        }

        public void ClearFile()
        {
            string jsonFilePath = GetFilePath();

            var options = new JsonSerializerOptions
            {
                WriteIndented = true
            };

            using (FileStream fs = new FileStream(jsonFilePath, FileMode.Create, FileAccess.Write))
            {
                JsonSerializer.Serialize(fs, new List<int>(), options);
            }
        }

        private bool FileIsExist() => File.Exists(GetFilePath());
    }
}
