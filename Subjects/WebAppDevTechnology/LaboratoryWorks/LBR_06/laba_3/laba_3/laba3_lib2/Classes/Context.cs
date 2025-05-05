using Microsoft.EntityFrameworkCore;

namespace DAL_Celebrity_MSSQL
{
    public class Context : DbContext
    {
        public string? ConnectionString { get; private set; } = null;
        public Context(string connstring) : base()
        {
            this.ConnectionString = connstring;
            //this.Database. EnsureDeleted();
            //this. Database. EnsureCreated();
        }
        public Context() : base()
        {
            //this.Database. EnsureDeleted();
            //this. Database. EnsureCreated();
        }
        public DbSet<Celebrity> Celebrities { get; set; }
        public DbSet<Lifeevent> Lifeevents { get; set; }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (string.IsNullOrEmpty(this.ConnectionString))
            {
                this.ConnectionString = @"Server=localhost\MSSQLSERVER02;
                                          Database=ASP;
                                          Integrated Security=True;
                                          TrustServerCertificate=True;";
            }

            optionsBuilder.UseSqlServer(this.ConnectionString);
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Celebrity>().ToTable("Celebrity").HasKey(p=>p.Id);
            modelBuilder.Entity<Celebrity>().Property(p => p.Id).IsRequired();
            modelBuilder.Entity<Celebrity>().Property(p => p.FullName).IsRequired().HasMaxLength(50);
            modelBuilder.Entity<Celebrity>().Property(p => p.Nationality).IsRequired().HasMaxLength(2);
            modelBuilder.Entity<Celebrity>().Property(p => p.ReqPhotoPath).HasMaxLength(200);

            modelBuilder.Entity<Lifeevent>().ToTable("Lifeevent").HasKey(p => p.Id);
            modelBuilder.Entity<Lifeevent>().ToTable("Lifeevent");
            modelBuilder.Entity<Lifeevent>().Property(p => p.Id).IsRequired();
            modelBuilder.Entity<Lifeevent>().ToTable("Lifeevent").HasOne<Celebrity>().WithMany().HasForeignKey(p => p.CelebrityId);
            modelBuilder.Entity<Lifeevent>().Property(p => p.CelebrityId).IsRequired();
            modelBuilder.Entity<Lifeevent>().Property(p => p.Date);
            modelBuilder.Entity<Lifeevent>().Property(p => p.Description).HasMaxLength(256);
            modelBuilder.Entity<Lifeevent>().Property(p => p.ReqPhotoPath).HasMaxLength(256);

            base.OnModelCreating(modelBuilder);
        }
    }
}