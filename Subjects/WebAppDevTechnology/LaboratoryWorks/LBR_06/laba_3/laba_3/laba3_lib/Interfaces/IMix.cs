namespace DAL_Celebrity
{
    public interface IMix<T1, T2>: IDisposable
    {
        List<T2> GetLifeeventsByCelebrityId(int celebrityId);   // получить все События по Id Знаменитости
        T1? GetCelebrityByLifeeventId(int lifeeventId);         // получить Знаменитость по Id События
        string GetLifeeventByPhoto(string photoName);
    }
}
