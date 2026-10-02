tableextension 70005 PurchaseLineTableExt extends "Purchase Line"
{
    fields
    {
        field(70000; I9G_CompletelyReceived; Boolean)
        {
            Caption = 'Completely Received';
            Editable = false;
        }
        field(70002; I9G_GSTBaseAmount; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'GST Base Amount';
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                CompanyInformationRec: Record "Company Information";
                ItemRec: Record Item;
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    ItemRec.Reset();
                    ItemRec.SetRange("No.", "No.");
                    ItemRec.SetFilter(I9G_ItemLocationCode, '<>%1', '');
                    if ItemRec.FindFirst() then begin
                        Validate("Location Code", ItemRec.I9G_ItemLocationCode);
                    end else begin
                        Validate("Location Code", '');
                    end;
                end;
            end;
        }
    }
    trigger OnAfterDelete()
    var
        PurchaseLineRec: Record "Purchase Line";
        PurchaseHeaderRec: Record "Purchase Header";
        CompanyInformationRec: Record "Company Information";
    begin
        CompanyInformationRec.Get();
        if CompanyInformationRec.I9G_Novem = true then begin
            PurchaseLineRec.Reset();
            PurchaseLineRec.SetRange("Document Type", "Document Type");
            PurchaseLineRec.SetRange("Document No.", "Document No.");
            PurchaseLineRec.SetRange("Completely Received", false);
            PurchaseLineRec.SetFilter("Line No.", '<>%1', "Line No.");
            if not PurchaseLineRec.FindFirst() then begin
                PurchaseHeaderRec.Reset();
                PurchaseHeaderRec.SetRange("Document Type", "Document Type");
                PurchaseHeaderRec.SetRange("No.", "Document No.");
                if PurchaseHeaderRec.FindFirst() then begin
                    PurchaseHeaderRec.I9G_CompletelyReceived := true;
                    PurchaseHeaderRec.Modify();
                end;
            end else begin
                PurchaseHeaderRec.Reset();
                PurchaseHeaderRec.SetRange("Document Type", "Document Type");
                PurchaseHeaderRec.SetRange("No.", "Document No.");
                if PurchaseHeaderRec.FindFirst() then begin
                    PurchaseHeaderRec.I9G_CompletelyReceived := false;
                    PurchaseHeaderRec.Modify();
                end;
            end;
        end;
    end;
}