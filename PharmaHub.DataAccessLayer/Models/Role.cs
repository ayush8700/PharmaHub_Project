using System;
using System.Collections.Generic;

namespace PharmaHub.DataAccessLayer.Models;

public partial class Role
{
    public byte RoleId { get; set; }

    public string? RoleName { get; set; }

    public string? CreatedBy { get; set; }

    public DateOnly? CreatedDate { get; set; }

    public string? UpdatedBy { get; set; }

    public DateOnly? UpdatedDate { get; set; }

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
