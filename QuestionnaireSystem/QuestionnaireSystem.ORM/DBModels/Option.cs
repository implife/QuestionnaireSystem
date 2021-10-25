namespace QuestionnaireSystem.ORM.DBModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Option")]
    public partial class Option
    {
        public Guid OptionID { get; set; }

        public Guid QuestionID { get; set; }

        [Required]
        public string OptionContent { get; set; }

        public int Number { get; set; }

        public virtual Question Question { get; set; }
    }
}
