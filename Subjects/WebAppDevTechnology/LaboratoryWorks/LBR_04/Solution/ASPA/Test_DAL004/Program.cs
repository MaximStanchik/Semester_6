//компоненты интернета
//4 компонента (по смеловски): http, стандарты, организации, tcp
//протоколы, службы, документация и организации

//у меня плохая реализация паттерна репозиторий и мне нужно будет рассказать почему у меня плохая реализация паттерна
//+ мап фолл бэк
//нужно разбираться в следующей лабораторной работе и найти метод мэп фолл бэк
//21, 21, исправить консольное приложение, рассказать про using и delete, рукопожатие

using DAL004;

namespace Test_DAL004
{
    class Program
    {
        private static void Main(string[] args)
        {
            CelebrityRepository.JSONFileName = "Celebrities.json";
            using (IRepository repository = CelebrityRepository.Create("Celebrities"))
            {
                void print(string label)
                {
                    Console.WriteLine("--- " + label + "------------");
                    foreach (Celebrity celebrity in repository.getAllCelebrities())
                    {
                        Console.WriteLine($"Id = {celebrity.Id}, Firstname = {celebrity.FirstName}, " +
                                          $"Surname = {celebrity.Surname}, PhotoPath = {celebrity.PhotoPath}");
                    }
                }

                print("start");
                
                int? testdel1 = repository.addCelebrity(new Celebrity(0, "TestDel1", "TestDel1", "Photo/TestDel1.jpg"));
                int? testdel2 = repository.addCelebrity(new Celebrity(0, "TestDel2", "TestDel2", "Photo/TestDel2.jpg"));
                int? testupd1 = repository.addCelebrity(new Celebrity(0, "TestUpd1", "TestUpd1", "Photo/TestUpd1.jpg"));
                int? testupd2 = repository.addCelebrity(new Celebrity(0, "TestUpd2", "TestUpd2", "Photo/TestUpd2.jpg"));
                repository.SaveChanges();

                print("add 4");

                if (testdel1 != null && repository.delCelebrityById((int)testdel1))
                {
                    Console.WriteLine($" delete {testdel1} ");
                }
                if (testdel2 != null && repository.delCelebrityById((int)testdel2))
                {
                    Console.WriteLine($" delete {testdel2} ");
                }
                if (!repository.delCelebrityById(1000))
                {
                    Console.WriteLine($"delete {1000} error");
                }

                repository.SaveChanges();
                print("del 2");

                if (testupd1 != null)
                {
                    var result = repository.updCelebrityById((int)testupd1, new Celebrity(0, "Updated1", "Updated1", "Photo/Updated1.jpg"));
                    Console.WriteLine(result != null ? $" update {testupd1} " : $" update {testupd1} error");
                }
                if (testupd2 != null)
                {
                    var result = repository.updCelebrityById((int)testupd2, new Celebrity(0, "Updated2", "Updated2", "Photo/Updated2.jpg"));
                    Console.WriteLine(result != null ? $" update {testupd2} " : $" update {testupd2} error");
                }
                if (repository.updCelebrityById(1000, new Celebrity(0, "Updated1000", "Updated1000", "Photo/Updated1000.jpg")) != null)
                {
                    Console.WriteLine($" update {1000} ");
                }
                else
                {
                    Console.WriteLine($" update {1000} error");
                }

                repository.SaveChanges();
                print("upd 2");
            }
        }
    }
}