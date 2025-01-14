using System;
using System.Collections.Generic;

namespace PharmaHub.DataAccessLayer.Models;

public partial class CardDetail
{
    public decimal CardNumber { get; set; }

    public string NameOnCard { get; set; } = null!;

    public string CardType { get; set; } = null!;

    public decimal Cvvnumber { get; set; }

    public DateOnly ExpiryDate { get; set; }

    public decimal? Balance { get; set; }

    public string? CreatedBy { get; set; }

    public DateOnly? CreatedDate { get; set; }

    public string? UpdatedBy { get; set; }

    public DateOnly? UpdatedDate { get; set; }
}
