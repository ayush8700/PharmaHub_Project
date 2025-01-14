using System;
using System.Collections.Generic;

namespace PharmaHub.DataAccessLayer.Models;

public partial class Category
{
    public byte CategoryId { get; set; }

    public string CategoryName { get; set; } = null!;

    public string? CreatedBy { get; set; }

    public DateOnly? CreatedDate { get; set; }

    public string? UpdatedBy { get; set; }

    public DateOnly? UpdatedDate { get; set; }

    public virtual ICollection<Product> Products { get; set; } = new List<Product>();
}
