namespace MyServer.Models
{
    public class Attendances
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public DateTime Time { get; set; }
        public String Type { get; set; }
        public String Source { get; set; }
        public String Status { get; set; }
    }
}