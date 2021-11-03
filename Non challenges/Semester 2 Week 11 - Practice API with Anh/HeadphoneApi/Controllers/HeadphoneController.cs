using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using HeadphoneLib;

namespace HeadphoneApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HeadphoneController : ControllerBase
    {
        
        private DatabaseHandler _dbh;


        public HeadphoneController()
        {
            this._dbh = new DatabaseHandler();
        }

        [HttpGet]

        public string GetAll()
        {
            return this._dbh.TestConnection;
        }

        /*[HttpGet("{id}")]
        public Headphone GetHeadphoneById(int id) {
            if (id > -1 && id < this._headphones.Count()) {
                return this._headphones[id - 1];
            }

            return null;
            */
        }
    }
}
