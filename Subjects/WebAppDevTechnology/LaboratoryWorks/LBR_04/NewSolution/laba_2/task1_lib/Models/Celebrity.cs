using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task1
{
    public record class Celebrity
    {
        public int Id { get; set; }
        public string Firstname { get; set; }
        public string Surname { get; set; }
        public string PhotoPath { get; set; }

        public Celebrity()
        {
            Firstname = string.Empty;
            Surname = string.Empty;
            PhotoPath = string.Empty;
        }
        public Celebrity(int _Id, string _Firstname, string _Surname, string _PhotoPath)
        {
            Id = _Id;
            Firstname = _Firstname;
            Surname = _Surname;
            PhotoPath = _PhotoPath;
        }
    }
}