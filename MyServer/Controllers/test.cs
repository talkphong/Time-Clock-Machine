using Microsoft.AspNetCore.Mvc;

namespace MyServer.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TestController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            return Ok("API OK. This is api/test");
        }
    }
}