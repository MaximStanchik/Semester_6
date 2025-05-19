using Azure;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.SqlServer;
using DAL_Celebrity;
using DAL_Celebrity_MSSQL;
using System.Reflection.Emit;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;

namespace DAL_Celebrity_MSSQL
{ 
    public class Context : DbContext
    {
        const string  SCHEMA = "CELEBRITIES";
        public string? ConnectionString {get; private set;} = null;
        public Context(string connstring) : base()
        {
            this.ConnectionString = connstring;   //this.Database.EnsureDeleted();  //this.Database.EnsureCreated();
        }
        public Context() : base() { /*this.Database.EnsureDeleted(); this.Database.EnsureCreated();*/ }
        public DbSet<Celebrity> Celebrities { get; set; }
        public DbSet<Lifeevent> Lifeevents { get; set; }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (this.ConnectionString is null) this.ConnectionString = @"Data source=172.16.193.88; Initial Catalog=LES01;" +
                                                                       @"TrustServerCertificate=True;User Id=smw60;Password=21625";
            optionsBuilder.UseSqlServer(this.ConnectionString);
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Celebrity>().ToTable("Celebrities",SCHEMA).HasKey(p=>p.Id);
            modelBuilder.Entity<Celebrity>().Property(p => p.Id).IsRequired();
            modelBuilder.Entity<Celebrity>().Property(p => p.FullName).IsRequired().HasMaxLength(50);
            modelBuilder.Entity<Celebrity>().Property(p => p.Nationality).IsRequired().HasMaxLength(2);
            modelBuilder.Entity<Celebrity>().Property(p => p.ReqPhotoPath).HasMaxLength(200);
           
            modelBuilder.Entity<Lifeevent>().ToTable("Lifeevents", SCHEMA).HasKey(p => p.Id);
            //modelBuilder.Entity<Lifeevent>().ToTable("Lifeevents");
            modelBuilder.Entity<Lifeevent>().Property(p => p.Id).IsRequired();
            modelBuilder.Entity<Lifeevent>().ToTable("Lifeevents",SCHEMA).HasOne<Celebrity>().WithMany().HasForeignKey(p =>p.CelebrityId); 
            modelBuilder.Entity<Lifeevent>().Property(p => p.CelebrityId).IsRequired();
            modelBuilder.Entity<Lifeevent>().Property(p => p.Date);
            modelBuilder.Entity<Lifeevent>().Property(p => p.Description).HasMaxLength(256);
            modelBuilder.Entity<Lifeevent>().Property(p => p.ReqPhotoPath).HasMaxLength(256);
            base.OnModelCreating(modelBuilder);
        }
    }
    public class AuthDbContext : IdentityDbContext
    {
        public AuthDbContext(DbContextOptions<AuthDbContext> options)
            : base(options)
        {
            //this.Database.EnsureCreated();
        }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<IdentityUser>().ToTable("AspNetUsers", "IDENTITY");
            builder.Entity<IdentityRole>().ToTable("AspNetRoles", "IDENTITY");
            builder.Entity<IdentityUserRole<string>>().ToTable("AspNetUserRoles", "IDENTITY");
            builder.Entity<IdentityUserClaim<string>>().ToTable("AspNetUserClaims", "IDENTITY");
            builder.Entity<IdentityUserLogin<string>>().ToTable("AspNetUserLogins", "IDENTITY");
            builder.Entity<IdentityRoleClaim<string>>().ToTable("AspNetRoleClaims", "IDENTITY");
            builder.Entity<IdentityUserToken<string>>().ToTable("AspNetUserTokens", "IDENTITY");
        }
    }




}
//modelBuilder.Entity<Celebrity>().ToTable("Celebrities").HasKey(p => p.Id);
//modelBuilder.Entity<Celebrity>().Property(p => p.Id).IsRequired();
//modelBuilder.Entity<Celebrity>().Property(p => p.FullName).IsRequired().HasMaxLength(50);
//modelBuilder.Entity<Celebrity>().Property(p => p.Nationality).IsRequired().HasMaxLength(2);
//modelBuilder.Entity<Celebrity>().Property(p => p.ReqPhotoPath).HasMaxLength(200);

//modelBuilder.Entity<Lifeevent>().ToTable("Lifeevents").HasKey(p => p.Id);
//modelBuilder.Entity<Lifeevent>().ToTable("Lifeevents");
//modelBuilder.Entity<Lifeevent>().Property(p => p.Id).IsRequired();
//modelBuilder.Entity<Lifeevent>().ToTable("Lifeevents").HasOne<Celebrity>().WithMany().HasForeignKey(p => p.CelebrityId);
//modelBuilder.Entity<Lifeevent>().Property(p => p.CelebrityId).IsRequired();
//modelBuilder.Entity<Lifeevent>().Property(p => p.Date);
//modelBuilder.Entity<Lifeevent>().Property(p => p.Description).HasMaxLength(256);
//modelBuilder.Entity<Lifeevent>().Property(p => p.ReqPhotoPath).HasMaxLength(256);
//base.OnModelCreating(modelBuilder);