using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace QuestionnaireSystem.ORM.DBModels
{
    public partial class ContextModel : DbContext
    {
        public ContextModel()
            : base("name=DefaultConnectionString")
        {
        }

        public virtual DbSet<Option> Options { get; set; }
        public virtual DbSet<Question> Questions { get; set; }
        public virtual DbSet<Questionnaire> Questionnaires { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Question>()
                .HasMany(e => e.Options)
                .WithRequired(e => e.Question)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Questionnaire>()
                .HasMany(e => e.Questions)
                .WithRequired(e => e.Questionnaire)
                .WillCascadeOnDelete(false);
        }
    }
}
