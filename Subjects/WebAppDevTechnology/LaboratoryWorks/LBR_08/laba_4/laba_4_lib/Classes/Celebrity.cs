namespace DAL_Celebrity_MSSQL
{
    public class Celebrity
    {
        public Celebrity() { this.FullName = string.Empty; this.Nationality = string.Empty; }
        public int Id { get; set; }                     // Id Знаменитости
        public string FullName { get; set; }            // полное имя Знаменитости
        public string Nationality { get; set; }         // гражданство Знаменитости ( 2 символа ISO )
        public string? ReqPhotoPath { get; set; }       // reguest path Фотографии
        public virtual bool Update(Celebrity celebrity) // -- вспомогательный метод
        {
            return true;
        }
    }
}
