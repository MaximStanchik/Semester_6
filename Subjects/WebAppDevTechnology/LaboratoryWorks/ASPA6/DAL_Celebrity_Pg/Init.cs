using DAL_Celebrity_Pg.EF;
using DAL_Celebrity_Pg.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace DAL_Celebrity_Pg
{
    // Func<string, string> puri = (string f) => $"https://diskstation.belstu.by:5006/photo/Celebrities/{f}";

    public class Init
    {
        static string connstring = "Host=localhost;Port=5432;Database=LibDb;Username=postgres;Password=Qwerty1234";
        public Init() { }
        public Init(string conn) { connstring = conn; }
        public static void Execute(bool delete = true, bool create = true)
        {
            Context context = new Context(connstring);
            if (delete) context.Database.EnsureDeleted();   // если есть БД, то она удаляется
            if (create) context.Database.EnsureCreated();   // если нет  БД, то содается 


            Func<string, string> puri = (string f) => $"{f}";

            { //1
                Celebrity c = new Celebrity() { FullName = "Noam Chomsky", Nationality = "US", ReqPhotoPath = puri("Chomsky.jpg") };
                LifeEvent l1 = new LifeEvent() { CelebrityId = 1, Date = new DateTime(1928, 12, 7, 0, 0, 0, DateTimeKind.Utc), Description = "Дата рождения", ReqPhotoPath = null };
                LifeEvent l2 = new LifeEvent()
                {
                    CelebrityId = 1,
                    Date = new DateTime(1955, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                    Description = "Издание книги \"Логическая структура лингвистической теории\"",
                    ReqPhotoPath = null
                };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            { //2
                Celebrity c = new Celebrity() { FullName = "Tim Berners-Lee", Nationality = "UK", ReqPhotoPath = puri("Berners-Lee.jpg") };
                LifeEvent l1 = new  () { CelebrityId = 2, Date = new DateTime(1955, 6, 8, 0, 0, 0, DateTimeKind.Utc), Description = "Дата рождения", ReqPhotoPath = null };
                LifeEvent l2 = new LifeEvent()
                {
                    CelebrityId = 2,
                    Date = new DateTime(1989, 6, 8, 0, 0, 0, DateTimeKind.Utc),
                    Description = "В CERN предложил \"Гиппертекстовый проект\"",
                    ReqPhotoPath = null
                };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            { //3
                Celebrity c = new Celebrity() { FullName = "Edgar Codd", Nationality = "US", ReqPhotoPath = puri("Codd.jpg") };
                LifeEvent l1 = new LifeEvent() { CelebrityId = 3, Date = new DateTime(1923, 8, 23, 0, 0, 0, DateTimeKind.Utc), Description = "Дата рождения", ReqPhotoPath = null };
                LifeEvent l2 = new LifeEvent() { CelebrityId = 3, Date = new DateTime(2003, 4, 18, 0, 0, 0, DateTimeKind.Utc), Description = "Дата смерти", ReqPhotoPath = null };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            { //4
                Celebrity c = new Celebrity() { FullName = "Donald Knuth", Nationality = "US", ReqPhotoPath = puri("Knuth.jpg") };
                LifeEvent l1 = new LifeEvent() { CelebrityId = 4, Date = new DateTime(1938, 1, 10, 0, 0, 0, DateTimeKind.Utc), Description = "Дата рождения", ReqPhotoPath = null };
                LifeEvent l2 = new LifeEvent() { CelebrityId = 4, Date = new DateTime(1974, 1, 1, 0, 0, 0, DateTimeKind.Utc), Description = "Премия Тьюринга", ReqPhotoPath = null };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            { //5
                Celebrity c = new Celebrity() { FullName = "Linus Torvalds", Nationality = "US", ReqPhotoPath = puri("Linus.jpg") };
                LifeEvent l1 = new LifeEvent()
                {
                    CelebrityId = 5,
                    Date = new DateTime(1969, 12, 28, 0, 0, 0, DateTimeKind.Utc),
                    Description = "Дата рождения. Финляндия.",
                    ReqPhotoPath = null
                };
                LifeEvent l2 = new LifeEvent()
                {
                    CelebrityId = 5,
                    Date = new DateTime(1991, 9, 17, 0, 0, 0, DateTimeKind.Utc),
                    Description = "Выложил исходный код  OS Linus (версии 0.01)",
                    ReqPhotoPath = null
                };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            { //6
                Celebrity c = new Celebrity() { FullName = "John Neumann", Nationality = "US", ReqPhotoPath = puri("Neumann.jpg") };
                LifeEvent l1 = new LifeEvent()
                {
                    CelebrityId = 6,
                    Date = new DateTime(1903, 12, 28, 0, 0, 0, DateTimeKind.Utc),
                    Description = "Дата рождения. Венгрия",
                    ReqPhotoPath = null
                };
                LifeEvent l2 = new LifeEvent() { CelebrityId = 6, Date = new DateTime(1957, 2, 8, 0, 0, 0, DateTimeKind.Utc), Description = "Дата смерти", ReqPhotoPath = null };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            { //7
                Celebrity c = new Celebrity() { FullName = "Edsger Dijkstra", Nationality = "NL", ReqPhotoPath = puri("Dijkstra.jpg") };
                LifeEvent l1 = new LifeEvent() { CelebrityId = 7, Date = new DateTime(1930, 12, 28, 0, 0, 0, DateTimeKind.Utc), Description = "Дата рождения", ReqPhotoPath = null };
                LifeEvent l2 = new LifeEvent() { CelebrityId = 7, Date = new DateTime(2002, 8, 6, 0, 0, 0, DateTimeKind.Utc), Description = "Дата смерти", ReqPhotoPath = null };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            { //8
                Celebrity c = new Celebrity() { FullName = "Ada Lovelace", Nationality = "UK", ReqPhotoPath = puri("Lovelace.jpg") };
                LifeEvent l1 = new LifeEvent() { CelebrityId = 8, Date = new DateTime(1852, 11, 27, 0, 0, 0, DateTimeKind.Utc), Description = "Дата рождения", ReqPhotoPath = null };
                LifeEvent l2 = new LifeEvent() { CelebrityId = 8, Date = new DateTime(1815, 12, 10, 0, 0, 0, DateTimeKind.Utc), Description = "Дата смерти", ReqPhotoPath = null };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            { //9
                Celebrity c = new Celebrity() { FullName = "Charles Babbage", Nationality = "UK", ReqPhotoPath = puri("Babbage.jpg") };
                LifeEvent l1 = new LifeEvent() { CelebrityId = 9, Date = new DateTime(1791, 12, 26, 0, 0, 0, DateTimeKind.Utc), Description = "Дата рождения", ReqPhotoPath = null };
                LifeEvent l2 = new LifeEvent() { CelebrityId = 9, Date = new DateTime(1871, 10, 18, 0, 0, 0, DateTimeKind.Utc), Description = "Дата смерти", ReqPhotoPath = null };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            { //10
                Celebrity c = new Celebrity() { FullName = "Andrew Tanenbaum", Nationality = "NL", ReqPhotoPath = puri("Tanenbaum.jpg") };
                LifeEvent l1 = new LifeEvent() { CelebrityId = 10, Date = new DateTime(1944, 3, 16, 0, 0, 0, DateTimeKind.Utc), Description = "Дата рождения", ReqPhotoPath = null };
                LifeEvent l2 = new LifeEvent()
                {
                    CelebrityId = 10,
                    Date = new DateTime(1987, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                    Description = "Cоздал OS MINIX — бесплатную Unix-подобную систему",
                    ReqPhotoPath = null
                };
                context.Celebrities.Add(c);
                context.LifeEvents.Add(l1);
                context.LifeEvents.Add(l2);
            }
            context.SaveChanges();
        }
    }
}
