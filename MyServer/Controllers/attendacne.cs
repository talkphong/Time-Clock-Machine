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
            var log_Attendances = new Attendances
            {
                UserId = request.UserId,
                Time = request.Time,
                Type = request.Type,
                Source = request.Source,
                Status = request.Status
            };

            _context.Attendances.Add(log_Attendances);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Check in success",
                UserId = request.UserId,
                time = request.Time
            });
        }

        [HttpGet("{UserId}")]
        public IActionResult GetAttendance(int UserId)
        {
            var attendance = _context.Attendances
                .Where(x => x.UserId == UserId)
                .ToList();
            return Ok(attendance);
        }
    }

    public class CheckInRequest
    {
        public int UserId { get; set; }
        public DateTime Time { get; set; }
        public String Type { get; set; }
        public String Source { get; set; }
        public String Status { get; set; }
    }
}