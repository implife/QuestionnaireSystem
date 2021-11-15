namespace QuestionnaireSystem.ORM.DBModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("UserInfo")]
    public partial class UserInfo
    {
        [Key]
        [Column(Order = 0)]
        public Guid UserID { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(50)]
        public string Account { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(50)]
        public string PWD { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(50)]
        public string Name { get; set; }

        [Key]
        [Column(Order = 4)]
        public string Email { get; set; }

        [StringLength(50)]
        public string Phone { get; set; }
    }
}
