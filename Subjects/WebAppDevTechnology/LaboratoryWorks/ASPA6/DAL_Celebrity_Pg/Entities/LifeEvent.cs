using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity_Pg.Entities
{
    public class LifeEvent
    {
        public int Id { get; set; }
        public int CelebrityId { get; set; }
        //public Celebrity Celebrity { get; set; }
        public DateTime? Date { get; set; }
        public string Description { get; set; }
        public string? ReqPhotoPath { get; set; }
        public virtual bool Update(LifeEvent lifeevent)       // -- вспомогательный метод                                           
        {
            if (!(lifeevent.CelebrityId <= 0)) this.CelebrityId = lifeevent.CelebrityId;
            if (!lifeevent.Date.Equals(new DateTime())) this.Date = lifeevent.Date;
            if (!string.IsNullOrEmpty(lifeevent.Description)) this.Description = lifeevent.Description;
            if (!string.IsNullOrEmpty(lifeevent.ReqPhotoPath)) this.ReqPhotoPath = lifeevent.ReqPhotoPath;
            return true;     //  изменения были ?
        }
        
        public LifeEvent()
        {
            this.Description = string.Empty;
        }
    }
}
