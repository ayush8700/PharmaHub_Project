using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmaHub.DataTranferObject
{
    public class UserDTO
    {
        public string EmailId { get; set; } = null!;

        public string UserPassword { get; set; } = null!;

        public byte? RoleId { get; set; }

        public string Gender { get; set; } = null!;

        public DateOnly DateOfBirth { get; set; }

        public string Address { get; set; } = null!;

        //public string City { get; set; }

        //public string Region { get; set; }

        //public string PostalCode { get; set; }

        //public string Country { get; set; }

        //public string Phone { get; set; }


    }
}
