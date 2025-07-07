using DAL_Celebrity.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity
{
    public interface IRepository<T, U> : IMix<T, U>, ICelebrity<T>, ILifeEvent<U>
    {
    }
}
