using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity.Interfaces
{
    public interface ILifeevent<T> : IDisposable
    {
        List<T> GetAllLifeevents();
        T? GetLifeevetById(int Id);
        bool DelLifeevent(int id);
        bool AddLifeevent(T lifeevent);
        bool UpdLifeevent(int id, T lifeevent);
    }
}
