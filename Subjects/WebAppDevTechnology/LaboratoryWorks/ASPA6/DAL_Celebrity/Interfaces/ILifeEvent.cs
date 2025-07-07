using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity.Interfaces
{
    public interface ILifeEvent <U> : IDisposable
    {
        List<U> GetAllLifeevents();
        U? GetLifeeventById(int id);
        bool DelLifeevent(int id);
        bool AddLifeevent(U lifeevent);
        bool UpdataeLifeevent(int id, U lifeevent);
    }

}
