using DAL_Celebrity;
using DAL_Celebrity_Pg.EF;
using DAL_Celebrity_Pg.Entities;
using DAL_Celebrity_Pg.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;

namespace DAL_Celebrity_Pg
{
    public class Repository : IRepository
    {
        private Context context;

        public Repository()
        {
            this.context = new Context();
        }

        public Repository(string conn)
        {
            this.context = new Context(conn);
        }

        public static Repository Create()
        {
            return new Repository();
        }
     
        public static Repository Create(string conn)
        {
            return new Repository(conn);
        }

        public bool AddCelebrity(Celebrity celebrity)
        {
            context.Celebrities.Add(celebrity);
            return context.SaveChanges() > 0;
        }

        public bool AddLifeevent(LifeEvent lifeevent)
        {
            context.LifeEvents.Add(lifeevent);
            return context.SaveChanges() > 0;
        }

        public bool DelCelebrity(int id)
        {
            var celebrity = context.Celebrities.Find(id);
            if (celebrity != null)
            {
                context.Celebrities.Remove(celebrity);
                return context.SaveChanges() > 0;
            }
            return false;
        }

        public bool DelLifeevent(int id)
        {
            var lifeevent = context.LifeEvents.Find(id);
            if (lifeevent != null)
            {
                context.LifeEvents.Remove(lifeevent);
                return context.SaveChanges() > 0;
            }
            return false;
        }

        public void Dispose()
        {
            context.Dispose();
        }

        public List<Celebrity> GetAllCelebrities()
        {
            return context.Celebrities.ToList();
        }

        public List<LifeEvent> GetAllLifeevents()
        {
            return context.LifeEvents.ToList();
        }

        public Celebrity? GetCelebrityById(int id)
        {
            return context.Celebrities.Find(id);
        }

        public Celebrity? GetCelebrityByLifeeventId(int lifeeventId)
        {
            var ev = context.LifeEvents.Find(lifeeventId);
            if(ev is null) return null;

            return context.Celebrities.Find(ev.CelebrityId);
        }

        public int GetCelebrityIdByName(string name)
        {
            var celebrity = context.Celebrities
                .FirstOrDefault(c => c.FullName.ToLower().Contains(name.ToLower()));
            return celebrity?.Id ?? -1; // Возвращаем -1, если не найдено
        }

        public LifeEvent? GetLifeeventById(int id)
        {
            return context.LifeEvents.Find(id);
        }

        public List<LifeEvent> GetLifeEventsByCelebrityId(int celebrityId)
        {
            return context.LifeEvents
                .Where(le => le.CelebrityId == celebrityId)
                .ToList();
        }

        public bool UpdataeLifeevent(int id, LifeEvent lifeevent)
        {
            var existingEvent = context.LifeEvents.Find(id);
            if (existingEvent != null)
            {
                existingEvent.Update(lifeevent);
                return context.SaveChanges() > 0;
            }
            return false;
        }

        public bool UpdateCelebrity(int id, Celebrity celebrity)
        {
            var existingCelebrity = context.Celebrities.Find(id);
            if (existingCelebrity != null)
            {
                existingCelebrity.Update(celebrity);
                return context.SaveChanges() > 0;
            }
            return false;
        }
    }
}