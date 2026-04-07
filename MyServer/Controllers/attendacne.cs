using Microsoft.AspNetCore.Mvc;
using MyServer.Data;
using MyServer.Models;

namespace MyServer.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AttendanceController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AttendanceController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost("checkin")]
        public async Task<IActionResult> CheckIn([FromBody] CheckInRequest request)
        {
            var log = new TimeLog
            {
                EmployeeId = request.EmployeeId,
                Time = request.Time
            };

            _context.TimeLogs.Add(log);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Check in success",
                employeeId = request.EmployeeId,
                time = request.Time
            });
        }
    }

    public class CheckInRequest
    {
        public int EmployeeId { get; set; }
        public DateTime Time { get; set; }
    }
}