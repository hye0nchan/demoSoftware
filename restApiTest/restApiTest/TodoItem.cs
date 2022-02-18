using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace restApiTest
{
    public class TodoItem
    {
        public int Id { get; set; }
        public string gwId { get; set; }
        public string deviceId { get; set; }
        public byte [] dataUnit { get; set; }
        public bool Iscomplete { get; set; }


    }
}
