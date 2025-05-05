namespace DAL_Celebrity_MSSQL
{
    public class Lifeevent
    {
        public Lifeevent() 
        {
            this.Description = string.Empty; 
        }
        public int Id { get; set; }                     // Id События
        public int CelebrityId { get; set; }            // Id Знаменитости
        public DateTime? Date { get; set; }             // дата События
        public string Description { get; set; }         // описание События
        public string? ReqPhotoPath { get; set; }       // reguest path Фотографии
        public virtual bool Update(Lifeevent lifeevent) // -- вспомогательный метод
        {
            return true;
        }
    }
}
