namespace DAL_Celebrity_MSSQL
{
    public class Lifeevent 
    {
        public Lifeevent() { Description = string.Empty; }
        public int      Id            { get; set; }           
        public int      CelebrityId   { get; set; }          
        public DateTime? Date          { get; set; }           
        public string   Description   { get; set; }           
        public string?  ReqPhotoPath  { get; set; }           
        public virtual bool Update(Lifeevent lifeevent)                                           
        {
            if (!(lifeevent.CelebrityId <= 0))                  CelebrityId = lifeevent.CelebrityId;
            if (!lifeevent.Date.Equals(new DateTime()))         Date = lifeevent.Date; 
            if (!string.IsNullOrEmpty(lifeevent.Description))   Description  = lifeevent.Description;
            if (!string.IsNullOrEmpty(lifeevent.ReqPhotoPath))  ReqPhotoPath = lifeevent.ReqPhotoPath;
            return  true;     
        }
    }
}
