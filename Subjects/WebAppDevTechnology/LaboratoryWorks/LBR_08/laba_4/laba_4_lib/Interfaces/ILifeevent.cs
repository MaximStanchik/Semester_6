namespace DAL_Celebrity
{
    public interface ILifeevent<T> : IDisposable
    {
        List<T> GetAllLifeevents();                       // получить все События 
        T? GetLifeevetById(int Id);                       // получить Событие по Id 
        bool DelLifeevent(int id);                        // удалить Событие  по Id 
        bool AddLifeevent(T lifeevent);                   // добавить Событие  
        bool UpdLifeevent(int id, T lifeevent);           // изменить обытие по  Id  
    }
}
