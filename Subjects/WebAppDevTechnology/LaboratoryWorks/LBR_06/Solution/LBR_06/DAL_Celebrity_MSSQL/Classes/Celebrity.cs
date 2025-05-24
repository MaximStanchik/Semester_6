namespace DAL_Celebrity_MSSQL
{
    public class Celebrity 
    {
         public Celebrity() { FullName =  string.Empty; Nationality = string.Empty; }
         public int Id { get; set; }                        
         public string FullName       { get; set; }        
         public string Nationality    { get; set; }         
         public string? ReqPhotoPath  { get; set; }         
         public virtual bool  Update(Celebrity celebrity)   
         {
            if (!string.IsNullOrEmpty(celebrity.FullName))
            {
                FullName = celebrity.FullName;
            }
            if (!string.IsNullOrEmpty(celebrity.Nationality))
            {
                Nationality = celebrity.Nationality;
            }
            if (!string.IsNullOrEmpty(celebrity.ReqPhotoPath))
            {
                ReqPhotoPath = celebrity.ReqPhotoPath;
            }
             return  true;    
         } 
    }
}
