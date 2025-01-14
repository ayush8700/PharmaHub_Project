using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PharmaHub.DataAccessLayer.Models;

namespace PharmaHub.DataAccessLayer
{
    public class PharmaHubRepository
    {
        PharmaHubDbContext _context;

        public PharmaHubRepository(PharmaHubDbContext context)
        {
            _context = context;
        }
            

    }
}
