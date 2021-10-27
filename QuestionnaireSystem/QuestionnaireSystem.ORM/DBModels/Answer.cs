namespace QuestionnaireSystem.ORM.DBModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Answer")]
    public partial class Answer
    {
        public int ID { get; set; }

        public Guid VoterID { get; set; }

        public Guid QuestionID { get; set; }

        public Guid? OptionID { get; set; }

        public string TextboxContent { get; set; }

        [Column(TypeName = "date")]
        public DateTime Timestamp { get; set; }

        public virtual Option Option { get; set; }

        public virtual Question Question { get; set; }

        public virtual Voter Voter { get; set; }
    }
}
