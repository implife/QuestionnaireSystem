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

        public virtual DbSet<Question> Questions { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
        }
    }
}
