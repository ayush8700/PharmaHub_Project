using System;
using System.Collections.Generic;

namespace PharmaHub.DataAccessLayer.Models;

public partial class User
{
    public string EmailId { get; set; } = null!;

    public string UserPassword { get; set; } = null!;

    public byte? RoleId { get; set; }

    public string Gender { get; set; } = null!;

    public DateOnly DateOfBirth { get; set; }

    public string? CreatedBy { get; set; }

    public DateOnly? CreatedDate { get; set; }

    public string? UpdatedBy { get; set; }

    public DateOnly? UpdatedDate { get; set; }

    public virtual ICollection<PurchaseDetail> PurchaseDetails { get; set; } = new List<PurchaseDetail>();

    public virtual Role? Role { get; set; }
}
