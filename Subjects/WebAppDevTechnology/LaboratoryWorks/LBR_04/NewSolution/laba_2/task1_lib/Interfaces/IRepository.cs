using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task1
{
    public interface IRepository : IDisposable
    {
        string BasePath { get; }
        IEnumerable<Celebrity> GetAllCelebrities();
        Celebrity? GetCelebrityById(int id);
        IEnumerable<Celebrity> GetCelebritiesBySurname(string Surname);
        string? GetPhotoPathById(int id);
        int AddCelebrity(Celebrity celebrity);
        bool DeleteCelebrityById(int id);
        int UpdCelebrityById(int id, Celebrity celebrity);
        int SaveChanges();
        void ClearFile();
        string GetFilePath();
    }
}