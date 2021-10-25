namespace QuestionnaireSystem.ORM.DBModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Questionnaire")]
    public partial class Questionnaire
    {
        public Guid QuestionnaireID { get; set; }

        [Required]
        public string Title { get; set; }

        public string Discription { get; set; }

        public int Status { get; set; }

        [Column(TypeName = "date")]
        public DateTime StartDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? EndDate { get; set; }
    }
}
