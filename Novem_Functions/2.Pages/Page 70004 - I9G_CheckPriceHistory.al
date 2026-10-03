page 70004 I9G_CheckPriceHistory
{
    PageType = List;
    Caption = 'Check Price History';
    SourceTable = I9G_TempTable;
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec.Option1)
                {
                    Caption = 'Document Type';
                    ApplicationArea = All;
                }
                field("Document No."; Rec.Code1)
                {
                    Caption = 'Document No.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec.Date1)
                {
                    Caption = 'Posting Date.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Decimal1)
                {
                    Caption = 'Quantity.';
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec.Code2)
                {
                    Caption = 'Unit of Measure Code';
                    ApplicationArea = All;
                }
                field("Unit Price Excl. GST"; Rec.Decimal2)
                {
                    Caption = 'Unit Price Excl. GST';
                    ApplicationArea = All;
                }
                field("Line Discount Amount"; Rec.Decimal3)
                {
                    Caption = 'Line Discount Amount';
                    ApplicationArea = All;
                }
                field("Price After Disc."; Rec.Decimal5)
                {
                    Caption = 'Price After Disc.';
                    ApplicationArea = All;
                }
                field("VAT %"; Rec.Decimal4)
                {
                    Caption = 'VAT %';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Gross Price"; Rec.Decimal6)
                {
                    Caption = 'Gross Price';
                    ApplicationArea = All;
                }
                field("Gross Price After Disc."; Rec.Decimal7)
                {
                    Caption = 'Gross Price After Disc.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Show Document")
            {
                ApplicationArea = All;
                Caption = 'Show Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";

                    PurchaseHeader: Record "Purchase Header";
                    PurchInvoiceHeader: Record "Purch. Inv. Header";
                    PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                begin
                    case Rec.Option1 of
                        Rec.Option1::"Blanket Order":
                            begin
                                if TransactionType = 0 then begin
                                    SalesHeader.Reset();
                                    SalesHeader.SetRange("Document Type", Rec.Option1);
                                    SalesHeader.SetRange("No.", Rec.Code1);
                                    if SalesHeader.FindFirst() then begin
                                        Page.Run(Page::"Blanket Sales Order", SalesHeader);
                                    end;
                                end else begin
                                    PurchaseHeader.Reset();
                                    PurchaseHeader.SetRange("Document Type", Rec.Option1);
                                    PurchaseHeader.SetRange("No.", Rec.Code1);
                                    if PurchaseHeader.FindFirst() then begin
                                        Page.Run(Page::"Blanket Purchase Order", PurchaseHeader);
                                    end;
                                end;
                            end;
                        Rec.Option1::Quote:
                            begin
                                if TransactionType = 0 then begin
                                    SalesHeader.Reset();
                                    SalesHeader.SetRange("Document Type", Rec.Option1);
                                    SalesHeader.SetRange("No.", Rec.Code1);
                                    if SalesHeader.FindFirst() then begin
                                        Page.Run(Page::"Sales Quote", SalesHeader);
                                    end;
                                end else begin
                                    PurchaseHeader.Reset();
                                    PurchaseHeader.SetRange("Document Type", Rec.Option1);
                                    PurchaseHeader.SetRange("No.", Rec.Code1);
                                    if PurchaseHeader.FindFirst() then begin
                                        Page.Run(Page::"Purchase Quote", PurchaseHeader);
                                    end;
                                end;
                            end;
                        Rec.Option1::Order:
                            begin
                                if TransactionType = 0 then begin
                                    SalesHeader.Reset();
                                    SalesHeader.SetRange("Document Type", Rec.Option1);
                                    SalesHeader.SetRange("No.", Rec.Code1);
                                    if SalesHeader.FindFirst() then begin
                                        Page.Run(Page::"Sales Order", SalesHeader);
                                    end;
                                end else begin
                                    PurchaseHeader.Reset();
                                    PurchaseHeader.SetRange("Document Type", Rec.Option1);
                                    PurchaseHeader.SetRange("No.", Rec.Code1);
                                    if PurchaseHeader.FindFirst() then begin
                                        Page.Run(Page::"Purchase Order", PurchaseHeader);
                                    end;
                                end;
                            end;
                        Rec.Option1::Invoice:
                            begin
                                if TransactionType = 0 then begin
                                    SalesHeader.Reset();
                                    SalesHeader.SetRange("Document Type", Rec.Option1);
                                    SalesHeader.SetRange("No.", Rec.Code1);
                                    if SalesHeader.FindFirst() then begin
                                        Page.Run(Page::"Sales Invoice", SalesHeader);
                                    end;
                                end else begin
                                    PurchaseHeader.Reset();
                                    PurchaseHeader.SetRange("Document Type", Rec.Option1);
                                    PurchaseHeader.SetRange("No.", Rec.Code1);
                                    if PurchaseHeader.FindFirst() then begin
                                        Page.Run(Page::"Purchase Invoice", PurchaseHeader);
                                    end;
                                end;
                            end;
                        Rec.Option1::"Return Order":
                            begin
                                if TransactionType = 0 then begin
                                    SalesHeader.Reset();
                                    SalesHeader.SetRange("Document Type", Rec.Option1);
                                    SalesHeader.SetRange("No.", Rec.Code1);
                                    if SalesHeader.FindFirst() then begin
                                        Page.Run(Page::"Sales Return Order", SalesHeader);
                                    end;
                                end else begin
                                    PurchaseHeader.Reset();
                                    PurchaseHeader.SetRange("Document Type", Rec.Option1);
                                    PurchaseHeader.SetRange("No.", Rec.Code1);
                                    if PurchaseHeader.FindFirst() then begin
                                        Page.Run(Page::"Purchase Return Order", PurchaseHeader);
                                    end;
                                end;
                            end;
                        Rec.Option1::"Credit Memo":
                            begin
                                if TransactionType = 0 then begin
                                    SalesHeader.Reset();
                                    SalesHeader.SetRange("Document Type", Rec.Option1);
                                    SalesHeader.SetRange("No.", Rec.Code1);
                                    if SalesHeader.FindFirst() then begin
                                        Page.Run(Page::"Sales Credit Memo", SalesHeader);
                                    end;
                                end else begin
                                    PurchaseHeader.Reset();
                                    PurchaseHeader.SetRange("Document Type", Rec.Option1);
                                    PurchaseHeader.SetRange("No.", Rec.Code1);
                                    if PurchaseHeader.FindFirst() then begin
                                        Page.Run(Page::"Purchase Credit Memo", PurchaseHeader);
                                    end;
                                end;
                            end;
                        Rec.Option1::"Posted Invoice":
                            begin
                                if TransactionType = 0 then begin
                                    SalesInvoiceHeader.Reset();
                                    SalesInvoiceHeader.SetRange("No.", Rec.Code1);
                                    if SalesInvoiceHeader.FindFirst() then begin
                                        Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
                                    end;
                                end else begin
                                    PurchInvoiceHeader.Reset();
                                    PurchInvoiceHeader.SetRange("No.", Rec.Code1);
                                    if PurchInvoiceHeader.FindFirst() then begin
                                        Page.Run(Page::"Posted Purchase Invoice", PurchInvoiceHeader);
                                    end;
                                end;
                            end;
                        Rec.Option1::"Posted Credit Memo":
                            begin
                                if TransactionType = 0 then begin
                                    SalesCrMemoHeader.Reset();
                                    SalesCrMemoHeader.SetRange("No.", Rec.Code1);
                                    if SalesCrMemoHeader.FindFirst() then begin
                                        Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                    end;
                                end else begin
                                    PurchCrMemoHeader.Reset();
                                    PurchCrMemoHeader.SetRange("No.", Rec.Code1);
                                    if PurchCrMemoHeader.FindFirst() then begin
                                        Page.Run(Page::"Posted Purchase Credit Memo", PurchCrMemoHeader);
                                    end;
                                end;
                            end;
                        Rec.Option1::"Posted Receipt":
                            begin
                                if TransactionType = 0 then begin

                                end else begin
                                    PurchRcptHeader.Reset();
                                    PurchRcptHeader.SetRange("No.", Rec.Code1);
                                    if PurchRcptHeader.FindFirst() then begin
                                        Page.Run(Page::"Posted Purchase Receipt", PurchRcptHeader);
                                    end;
                                end;
                            end;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if TransactionType = 0 then
            GetSalesDetails()
        else
            GetPurchaseDetails();
    end;

    local procedure GetDocumentTypeText(DocumentType: Integer): Text[20]
    var
        DocumentTypeText: Text[20];
    begin
        case Rec.Integer1 of
            0:
                DocumentTypeText := 'Quote';
            1:
                DocumentTypeText := 'Order';
            2:
                DocumentTypeText := 'Invoice';
            3:
                DocumentTypeText := 'Credit Memo';
            4:
                DocumentTypeText := 'Blanket Order';
            5:
                DocumentTypeText := 'Return Order';
            11:
                DocumentTypeText := 'Posted Invoice';
            12:
                DocumentTypeText := 'Posted Credit Memo';
            13:
                DocumentTypeText := 'Posted Receipt';
            else
                DocumentTypeText := Format(Rec.Integer1);
        end;

        exit(DocumentTypeText);
    end;

    local procedure GetSalesDetails()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        EntryNo: Integer;
    begin
        EntryNo := 1;

        SalesLine.Reset();
        SalesLine.SetRange("Type", SalesLine.Type::Item);
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetRange("Sell-to Customer No.", SourceNo);
        if SalesLine.FindSet() then begin
            repeat
                if SalesLine."Document No." <> DocNo then begin
                    Rec.Init();
                    Rec."Entry No." := EntryNo;
                    Rec.Option1 := SalesLine."Document Type";
                    Rec.Code1 := SalesLine."Document No.";

                    if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                        Rec.Date1 := SalesHeader."Posting Date";

                    Rec.Decimal1 := SalesLine."Quantity";
                    Rec.Decimal2 := SalesLine."Unit Price";
                    Rec.Decimal3 := SalesLine."Line Discount Amount";
                    Rec.Decimal4 := SalesLine."VAT %";
                    Rec.Code2 := SalesLine."Unit of Measure Code";

                    if SalesLine."Quantity" > 0 then begin
                        Rec.Decimal5 := SalesLine."Line Amount" / SalesLine."Quantity";
                        Rec.Decimal7 := (SalesLine."Line Amount" / SalesLine."Quantity") * (1 + (SalesLine."VAT %" / 100));
                    end;

                    Rec.Decimal6 := SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100));
                    Rec.Insert();

                    EntryNo += 1;
                end;

            until SalesLine.Next() = 0;
        end;

        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Type", SalesLine.Type::Item);
        SalesInvoiceLine.SetRange("No.", ItemNo);
        SalesInvoiceLine.SetRange("Sell-to Customer No.", SourceNo);
        if SalesInvoiceLine.FindSet() then begin
            repeat
                if SalesInvoiceLine."Document No." <> DocNo then begin
                    Rec.Init();
                    Rec."Entry No." := EntryNo;
                    Rec.Option1 := Rec.Option1::"Posted Invoice";
                    Rec.Code1 := SalesInvoiceLine."Document No.";
                    Rec.Date1 := SalesInvoiceLine."Posting Date";
                    Rec.Decimal1 := SalesInvoiceLine.Quantity;
                    Rec.Decimal2 := SalesInvoiceLine."Unit Price";
                    Rec.Decimal3 := SalesInvoiceLine."Line Discount Amount";
                    Rec.Decimal4 := SalesInvoiceLine."VAT %";
                    Rec.Code2 := SalesInvoiceLine."Unit of Measure Code";

                    if SalesInvoiceLine.Quantity > 0 then begin
                        Rec.Decimal5 := SalesInvoiceLine."Line Amount" / SalesInvoiceLine.Quantity;
                        Rec.Decimal7 := (SalesInvoiceLine."Line Amount" / SalesInvoiceLine.Quantity) * (1 + (SalesInvoiceLine."VAT %" / 100));
                    end;

                    Rec.Decimal6 := SalesInvoiceLine."Unit Price" * (1 + (SalesInvoiceLine."VAT %" / 100));
                    Rec.Insert();

                    EntryNo += 1;
                end;

            until SalesInvoiceLine.Next() = 0;
        end;

        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetRange("Type", SalesLine.Type::Item);
        SalesCrMemoLine.SetRange("No.", ItemNo);
        SalesCrMemoLine.SetRange("Sell-to Customer No.", SourceNo);
        if SalesCrMemoLine.FindSet() then begin
            repeat
                if SalesCrMemoLine."Document No." <> DocNo then begin
                    Rec.Init();
                    Rec."Entry No." := EntryNo;
                    Rec.Option1 := Rec.Option1::"Posted Credit Memo";
                    Rec.Code1 := SalesCrMemoLine."Document No.";
                    Rec.Date1 := SalesCrMemoLine."Posting Date";
                    Rec.Decimal1 := SalesCrMemoLine."Quantity";
                    Rec.Decimal2 := SalesCrMemoLine."Unit Price";
                    Rec.Decimal3 := SalesCrMemoLine."Line Discount Amount";
                    Rec.Decimal4 := SalesCrMemoLine."VAT %";
                    Rec.Code2 := SalesCrMemoLine."Unit of Measure Code";

                    if SalesCrMemoLine."Quantity" > 0 then begin
                        Rec.Decimal5 := SalesCrMemoLine."Line Amount" / SalesCrMemoLine."Quantity";
                        Rec.Decimal7 := (SalesCrMemoLine."Line Amount" / SalesCrMemoLine."Quantity") * (1 + (SalesCrMemoLine."VAT %" / 100));
                    end;

                    Rec.Decimal6 := SalesCrMemoLine."Unit Price" * (1 + (SalesCrMemoLine."VAT %" / 100));
                    Rec.Insert();

                    EntryNo += 1;
                end;

            until SalesCrMemoLine.Next() = 0;
        end;

        if Rec.FindFirst() then;
    end;

    local procedure GetPurchaseDetails()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseInvoiceLine: Record "Purch. Inv. Line";
        PurchaseCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchaseRcptLine: Record "Purch. Rcpt. Line";
        PurchaseRcptHeader: Record "Purch. Rcpt. Header";
        EntryNo: Integer;
    begin
        EntryNo := 1;

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Type", PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", ItemNo);
        PurchaseLine.SetRange("Buy-from Vendor No.", SourceNo);
        if PurchaseLine.FindSet() then begin
            repeat
                if PurchaseLine."Document No." <> DocNo then begin
                    Rec.Init();
                    Rec."Entry No." := EntryNo;
                    Rec.Option1 := PurchaseLine."Document Type";
                    Rec.Code1 := PurchaseLine."Document No.";

                    if PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then
                        Rec.Date1 := PurchaseHeader."Posting Date";

                    Rec.Decimal1 := PurchaseLine."Quantity";
                    Rec.Decimal2 := PurchaseLine."Direct Unit Cost";
                    Rec.Decimal3 := PurchaseLine."Line Discount Amount";
                    Rec.Decimal4 := PurchaseLine."VAT %";
                    Rec.Code2 := PurchaseLine."Unit of Measure Code";

                    if PurchaseLine."Quantity" > 0 then begin
                        Rec.Decimal5 := PurchaseLine."Line Amount" / PurchaseLine."Quantity";
                        Rec.Decimal7 := (PurchaseLine."Line Amount" / PurchaseLine."Quantity") * (1 + (PurchaseLine."VAT %" / 100));
                    end;

                    Rec.Decimal6 := PurchaseLine."Direct Unit Cost" * (1 + (PurchaseLine."VAT %" / 100));
                    Rec.Insert();

                    EntryNo += 1;
                end;

            until PurchaseLine.Next() = 0;
        end;

        PurchaseInvoiceLine.Reset();
        PurchaseInvoiceLine.SetRange("Type", PurchaseLine.Type::Item);
        PurchaseInvoiceLine.SetRange("No.", ItemNo);
        PurchaseInvoiceLine.SetRange("Buy-from Vendor No.", SourceNo);
        if PurchaseInvoiceLine.FindSet() then begin
            repeat
                if PurchaseInvoiceLine."Document No." <> DocNo then begin
                    Rec.Init();
                    Rec."Entry No." := EntryNo;
                    Rec.Option1 := Rec.Option1::"Posted Invoice";
                    Rec.Code1 := PurchaseInvoiceLine."Document No.";
                    Rec.Date1 := PurchaseInvoiceLine."Posting Date";
                    Rec.Decimal1 := PurchaseInvoiceLine.Quantity;
                    Rec.Decimal2 := PurchaseInvoiceLine."Direct Unit Cost";
                    Rec.Decimal3 := PurchaseInvoiceLine."Line Discount Amount";
                    Rec.Decimal4 := PurchaseInvoiceLine."VAT %";
                    Rec.Code2 := PurchaseInvoiceLine."Unit of Measure Code";

                    if PurchaseInvoiceLine.Quantity > 0 then begin
                        Rec.Decimal5 := PurchaseInvoiceLine."Line Amount" / PurchaseInvoiceLine.Quantity;
                        Rec.Decimal7 := (PurchaseInvoiceLine."Line Amount" / PurchaseInvoiceLine.Quantity) * (1 + (PurchaseInvoiceLine."VAT %" / 100));
                    end;

                    Rec.Decimal6 := PurchaseInvoiceLine."Direct Unit Cost" * (1 + (PurchaseInvoiceLine."VAT %" / 100));
                    Rec.Insert();

                    EntryNo += 1;
                end;
            until PurchaseInvoiceLine.Next() = 0;
        end;

        PurchaseRcptLine.Reset();
        PurchaseRcptLine.SetRange("Type", PurchaseLine.Type::Item);
        PurchaseRcptLine.SetRange("No.", ItemNo);
        PurchaseRcptLine.SetRange("Buy-from Vendor No.", SourceNo);
        if PurchaseRcptLine.FindSet() then begin
            repeat
                if PurchaseRcptLine."Document No." <> DocNo then begin
                    Rec.Init();
                    Rec."Entry No." := EntryNo;
                    Rec.Option1 := Rec.Option1::"Posted Receipt";
                    Rec.Code1 := PurchaseRcptLine."Document No.";
                    Rec.Date1 := PurchaseRcptLine."Posting Date";
                    Rec.Decimal1 := PurchaseRcptLine."Quantity";
                    Rec.Decimal2 := PurchaseRcptLine."Direct Unit Cost";

                    Rec.Decimal4 := PurchaseRcptLine."VAT %";
                    Rec.Code2 := PurchaseRcptLine."Unit of Measure Code";

                    if PurchaseRcptHeader.Get(PurchaseRcptLine."Document No.") then begin
                        if PurchaseRcptHeader."Currency Code" = '' then
                            Currency.InitRoundingPrecision()
                        else begin
                            PurchaseRcptHeader.TestField("Currency Factor");
                            Currency.Get(PurchaseRcptHeader."Currency Code");
                            Currency.TestField("Amount Rounding Precision");
                        end;
                    end;

                    if PurchaseRcptLine."Quantity" > 0 then begin
                        Rec.Decimal5 := Round(PurchaseRcptLine.Quantity * PurchaseRcptLine."Direct Unit Cost", Currency."Amount Rounding Precision") / PurchaseRcptLine."Quantity";
                        Rec.Decimal7 := (Round(PurchaseRcptLine.Quantity * PurchaseRcptLine."Direct Unit Cost", Currency."Amount Rounding Precision") / PurchaseRcptLine."Quantity") * (1 + (PurchaseRcptLine."VAT %" / 100));
                    end;

                    if PurchaseLine.Get(PurchaseLine."Document Type"::Order, PurchaseRcptHeader."Order No.") then
                        Rec.Decimal3 := Round(Rec.Decimal5 * PurchaseRcptLine."Line Discount %" / 100, Currency."Amount Rounding Precision");

                    Rec.Decimal6 := PurchaseRcptLine."Direct Unit Cost" * (1 + (PurchaseRcptLine."VAT %" / 100));
                    Rec.Insert();

                    EntryNo += 1;
                end;

            until PurchaseRcptLine.Next() = 0;
        end;

        if Rec.FindFirst() then;
    end;

    procedure SetRec(NewItemNo: Code[20]; NewSourceNo: Code[20]; NewTransactionType: Integer; NewDocNo: Code[20])
    begin
        ItemNo := NewItemNo;
        SourceNo := NewSourceNo;
        TransactionType := NewTransactionType;
        DocNo := NewDocNo;
    end;

    var
        ItemNo: Code[20];
        SourceNo: Code[20];
        TransactionType: Integer;
        DocNo: Code[20];
        Currency: Record Currency;
}
