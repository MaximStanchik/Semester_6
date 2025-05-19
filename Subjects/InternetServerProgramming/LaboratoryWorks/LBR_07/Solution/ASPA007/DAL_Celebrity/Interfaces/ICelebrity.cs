using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity.Interfaces
{
    public interface ICelebrity<T> : IDisposable
    {
        List<T> GetAllCelebrities();
        T? GetCelebrityById(int Id);
        bool DelCelebrity(int id);
        bool AddCelebrity(T celebrity);
        bool UpdCelebrity(int id, T celebrity);
        int GetCelebrityIdByName(string name);
    }
}
