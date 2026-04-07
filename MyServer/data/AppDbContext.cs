using Microsoft.EntityFrameworkCore;
using MyServer.Models;

namespace MyServer.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }
        public DbSet<Attendances> Attendances { get; set; }

    }
}