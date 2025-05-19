using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity.Interfaces
{
    public interface IMix<T1, T2> : IDisposable
    {
        List<T2> GetLifeeventsByCelebrityId(int celebrityId);
        T1? GetCelebrityByLifeeventId(int lifeeventId);
        string GetLifeeventByPhoto(string photoName);
    }
}
