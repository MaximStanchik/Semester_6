using System.Reflection.Emit;
using task1;

namespace task2
{
    class Test
    {
        private static void Main(string[] args)
        {
            Repository.JSONFileName = "newData.json";

            using (IRepository repository = Repository.Create("Celebrities"))
            {
                repository.ClearFile();

                void print(string label)
                {
                    Console.WriteLine("<-------------------( " + label + " )------------------->");
                    if (repository.GetAllCelebrities().Count() <= 0)
                    {
                        Console.WriteLine("Now list is empty");
                        return;
                    }
                    foreach (Celebrity celebrity in repository.GetAllCelebrities())
                    {
                        Console.WriteLine($"Id = {celebrity.Id}, Firstname = {celebrity.Firstname}, " +
                        $"Surname = {celebrity.Surname}, PhotoPath = {celebrity.PhotoPath} ");
                    }

                    Console.WriteLine("<-------------------------------------------------------->\n");
                };
                print("start");

                int testdel1 = repository.AddCelebrity(new Celebrity(0, "TestDel1", "TestDel1", "Photo/TestDel1.jpg"));
                int testdel2 = repository.AddCelebrity(new Celebrity(1, "TestDel2", "TestDel2", "Photo/TestDel2.jpg"));
                int testupd1 = repository.AddCelebrity(new Celebrity(2, "TestUpd1", "TestUpd1", "Photo/TestUpd1.jpg"));
                int testupd2 = repository.AddCelebrity(new Celebrity(3, "TestUpd2", "TestUpd2", "Photo/TestUpd2.jpg"));
                int testerr1 = repository.AddCelebrity(new Celebrity(0, "TestErr1", "TestErr1", "Photo/TestErr1.jpg"));
                int testerr2 = repository.AddCelebrity(new Celebrity(4, "", "TestErr1", "Photo/TestErr1.jpg"));

                print("First test");
                foreach (var i in new List<int> { testdel1, testdel2, testupd1, testupd2, testerr1, testerr2 }) 
                { 
                    switch (i) 
                    {
                        case -1:
                            Console.WriteLine("Error: Incorrect Id");
                            break;
                        case -2:
                            Console.WriteLine("Error: Incorrect value");
                            break;
                        default:
                            Console.WriteLine("Correct");
                            break;
                    }
                }

                print($"add {repository.SaveChanges()}");

                if (testdel1 >= 0)
                {
                    if (repository.DeleteCelebrityById((int)testdel1))
                    {
                        Console.WriteLine($"delete {testdel1} ");
                    }
                    else
                    {
                        Console.WriteLine($"delete {testdel1} error");
                    }
                }
                if (testdel2 >= 0)
                {
                    if (repository.DeleteCelebrityById((int)testdel2))
                    {
                        Console.WriteLine($"delete {testdel2} ");
                    }
                    else
                    {
                        Console.WriteLine($"delete {testdel2} error");
                    }
                }
                if (repository.DeleteCelebrityById(1000))
                {
                    Console.WriteLine($"delete {1000} ");
                }
                else
                {
                    Console.WriteLine($"delete {1000} error");
                }

                print($"del {repository.SaveChanges()}");

                if (testupd1 >= 0)
                {
                    testupd1 = repository.UpdCelebrityById((int)testupd1, new Celebrity(5, "Updated1", "Updated1", "Photo/Updated1.jpg"));
                    
                    if (testupd1 >= 0)
                    {
                        Console.WriteLine($"update_1_1 {testupd1}");
                    }
                    else
                    {
                        Console.WriteLine($"update_1_1 {testupd1} error");
                    }

                    testupd1 = repository.UpdCelebrityById(1000, new Celebrity(6, "Updated1", "Updated1", "Photo/Updated1.jpg"));

                    if (testupd1 >= 0)
                    {
                        Console.WriteLine($"update_1_2 {1000}");
                    }
                    else
                    {
                        Console.WriteLine($"update_1_2 {1000} error");
                    }
                }
                if (testupd2 >= 0)
                {
                    testupd2 = repository.UpdCelebrityById((int)testupd2, new Celebrity(6, "Updated2", "Updated2", "Photo/Updated2.jpg"));

                    if (testupd2 >= 0)
                    {
                        Console.WriteLine($"update_2_1 {testupd2} ");
                    }
                    else
                    {
                        Console.WriteLine($"update_2_1 {testupd2} error");
                    }

                    testupd2 = repository.UpdCelebrityById((int)testupd2, new Celebrity(5, "Updated2", "Updated2", "Photo/Updated2.jpg"));

                    if (testupd2 >= 0)
                    {
                        Console.WriteLine($"update_2_2 {5} ");
                    }
                    else
                    {
                        Console.WriteLine($"update_2_2 {5} error");
                    }
                }

                print($"upd {repository.SaveChanges()}");
            }
        }
    }
}