using DAL_Celebrity_Pg.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity_Pg.Interfaces
{
    public interface IRepository : DAL_Celebrity.IRepository<Celebrity, LifeEvent>
    {
    }
}
