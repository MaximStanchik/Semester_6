using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity.Interfaces
{
    public interface IMix <T, U>
    {
        List<U> GetLifeEventsByCelebrityId(int celebrityId);
        T? GetCelebrityByLifeeventId(int lifeeventId);
    }
}
