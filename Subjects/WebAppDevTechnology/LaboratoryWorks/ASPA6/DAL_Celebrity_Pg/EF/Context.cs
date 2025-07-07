using DAL_Celebrity_Pg.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL_Celebrity_Pg.EF
{
    public class Context : DbContext
    {
        public string ConnectionString { get; private set; } = null;
        public Context() { }
        public Context(string connectionString)
        {
            ConnectionString = connectionString;
        }
        public DbSet<Celebrity> Celebrities { get; set; }
        public DbSet<LifeEvent> LifeEvents { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql(this.ConnectionString 
                ?? "Host=localhost;Port=5432;Database=LibDb;Username=postgres;Password=Qwerty1234");

            base.OnConfiguring(optionsBuilder);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Celebrity>().
                ToTable("Celebrities").
                HasKey(p => p.Id);

            modelBuilder.Entity<Celebrity>().Property(p => p.Id).IsRequired();

            modelBuilder.Entity<Celebrity>().
                Property(p => p.FullName).
                IsRequired().
                HasMaxLength(60);

            modelBuilder.Entity<Celebrity>().
                Property(p => p.Nationality).
                IsRequired().
                HasMaxLength(2);

            modelBuilder.Entity<Celebrity>().Property(p => p.ReqPhotoPath).HasMaxLength(200);

            ////
            
            modelBuilder.Entity<LifeEvent>().
                ToTable("Lifeevents").
                HasKey(p => p.Id);
            modelBuilder.Entity<LifeEvent>().
                HasOne<Celebrity>().
                WithMany().
                HasForeignKey(p => p.CelebrityId);

            modelBuilder.Entity<LifeEvent>().Property(p => p.Id).IsRequired();
            modelBuilder.Entity<LifeEvent>().Property(p => p.CelebrityId).IsRequired();
            modelBuilder.Entity<LifeEvent>().Property(p => p.Date);
            modelBuilder.Entity<LifeEvent>().Property(p => p.Description).HasMaxLength(256);
            modelBuilder.Entity<LifeEvent>().Property(p => p.ReqPhotoPath).HasMaxLength(256);


            base.OnModelCreating(modelBuilder);
        }
    }
}
