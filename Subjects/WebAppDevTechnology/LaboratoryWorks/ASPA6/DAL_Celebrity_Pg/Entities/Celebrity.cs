using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity_Pg.Entities
{
    public class Celebrity
    {
        public int Id { get; set; }
        public string FullName { get; set; }
        public string Nationality { get; set; }
        public string? ReqPhotoPath { get; set; }
        public virtual bool Update(Celebrity celebrity)   // --вспомогательный метод  
        {
            if (!string.IsNullOrEmpty(celebrity.FullName)) this.FullName = celebrity.FullName;
            if (!string.IsNullOrEmpty(celebrity.Nationality)) this.Nationality = celebrity.Nationality;
            if (!string.IsNullOrEmpty(celebrity.ReqPhotoPath)) this.ReqPhotoPath = celebrity.ReqPhotoPath;
            return true;     //  изменения были ?
        }

        public Celebrity()
        {
            this.FullName = string.Empty;
            this.Nationality = string.Empty;    
        }
    }
}
