using Microsoft.EntityFrameworkCore;
using System.Text;
using DAL_Celebrity;

namespace DAL_Celebrity_MSSQL
{
    public class Repository : IRepository
    {
        public const string DEFOULT_CS = @"Server=localhost,1433;
                                            Database=ASP;
                                            User Id=sa;
                                            Password=StrongP@ssw0rd;
                                            TrustServerCertificate=True;";
        private readonly Context _context;

        public Repository(string CS)
        {
            _context = new Context(string.IsNullOrEmpty(CS) ? DEFOULT_CS : CS);
        }

        public static IRepository Create(string CS) => new Repository(CS);
        public bool AddCelebrity(Celebrity celebrity)
        {
            _context.Celebrities.Add(celebrity);
            return _context.SaveChanges() > 0;
        }

        public bool AddLifeevent(Lifeevent lifeevent)
        {
            _context.Lifeevents.Add(lifeevent);
            return _context.SaveChanges() > 0;
        }

        public bool DelCelebrity(int id)
        {
            var del = _context.Celebrities.FirstOrDefault(c => c.Id == id);

            if (del == null)
            {
                return false;
            }

            _context.Celebrities.Remove(del!);

            return _context.SaveChanges() > 0;
        }

        public bool DelLifeevent(int id)
        {
            var del = _context.Lifeevents.FirstOrDefault(c => c.Id == id);

            if (del == null)
            {
                return false;
            }

            _context.Lifeevents.Remove(del!);

            return _context.SaveChanges() > 0;
        }

        public void Dispose()
        {
            _context?.Dispose();
        }

        public List<Celebrity> GetAllCelebrities()
        {
            return _context.Celebrities.ToList<Celebrity>();

            //ConnectionString = "Server=localhost/MSSQLSERVER02;Database=ASP;Integrated Security=True;TrustServerCertificate=True;" asp
            //ConnectionString = "Server=localhost\\MSSQLSERVER02;Database=ASP;Integrated Security=True;TrustServerCertificate=True;" console
        }

        public List<Lifeevent> GetAllLifeevents()
        {
            return _context.Lifeevents.ToList<Lifeevent>();
        }

        public Celebrity? GetCelebrityById(int Id)
        {
            return GetAllCelebrities().FirstOrDefault(c => c.Id == Id);
        }

        public Celebrity? GetCelebrityByLifeeventId(int lifeeventId)
        {
            var celId = GetAllLifeevents().FirstOrDefault(l => l.Id == lifeeventId);

            if (celId == null)
            {
                return null;
            }

            return GetAllCelebrities().FirstOrDefault(c => c.Id == celId.CelebrityId);
        }

        public int GetCelebrityIdByName(string name)
        {
            var cel = GetAllCelebrities().FirstOrDefault(c => c.FullName == name);

            if (cel == null)
            {
                return -1;
            }

            return cel.Id;
        }

        public List<Lifeevent> GetLifeeventsByCelebrityId(int celebrityId)
        {
            return GetAllLifeevents().Where(l => l.CelebrityId == celebrityId).ToList();
        }

        public Lifeevent? GetLifeevetById(int Id)
        {
            return GetAllLifeevents().FirstOrDefault(l => l.Id == Id);
        }

        public bool UpdCelebrity(int id, Celebrity celebrity)
        {
            var dbSet = _context.Set<Celebrity>();

            var exist = dbSet.Find(id);

            if (exist == null)
            {
                return _context.SaveChanges() > 0;
            }

            dbSet.Where(c => c.Id == id).First().FullName = celebrity.FullName;
            dbSet.Where(c => c.Id == id).First().Nationality = celebrity.Nationality;
            dbSet.Where(c => c.Id == id).First().ReqPhotoPath = celebrity.ReqPhotoPath;

            return _context.SaveChanges() > 0;
        }

        public bool UpdLifeevent(int id, Lifeevent lifeevent)
        {
            var dbSet = _context.Set<Lifeevent>();

            var exist = dbSet.Find(id);

            if (exist == null)
            {
                return _context.SaveChanges() > 0;
            }

            dbSet.Where(c => c.Id == id).First().CelebrityId = lifeevent.CelebrityId;
            dbSet.Where(c => c.Id == id).First().Date = lifeevent.Date;
            dbSet.Where(c => c.Id == id).First().Description = lifeevent.Description;
            dbSet.Where(c => c.Id == id).First().ReqPhotoPath = lifeevent.ReqPhotoPath;

            return _context.SaveChanges() > 0;
        }


        ///////////////////////////////////////////////
        public string GetLifeeventByPhoto(string photoName)
        {
            var dbSetCel = _context.Set<Celebrity>();
            var dbDetLe = _context.Set<Lifeevent>();
            var result = new StringBuilder();

            var exist = dbSetCel.Where(c => c.ReqPhotoPath == photoName).FirstOrDefault();

            if (exist == null)
            {
                return "Error: this photo not exists";
            }

            var resLifeevent = GetLifeeventsByCelebrityId(exist.Id);

            foreach (var l in resLifeevent)
            {
                result.Append($"<<{l.Date} || {l.Description}>>   ");
            }

            return result.ToString();
        }
    }
}
