tableextension 70055 SalesLineTableExt extends "Sales Line"
{
    fields
    {
        field(70000; "I9G_OpenQuantity"; Decimal)
        {
            Caption = 'Open Quantity';
            DecimalPlaces = 2 : 2;
            Editable = false;
            trigger OnValidate()
            var
                CompanyInformationRec: Record "Company Information";
                SalesHeaderRec: Record "Sales Header";
            begin
                CompanyInformationRec.Get();
                if (CompanyInformationRec.I9G_Novem = true) and ("Document Type" = "Document Type"::"Blanket Order") then begin
                    SalesHeaderRec.Reset();
                    SalesHeaderRec.SetRange("Document Type", "Document Type");
                    SalesHeaderRec.SetRange("No.", "Document No.");
                    if SalesHeaderRec.FindFirst() then begin
                        if I9G_OpenQuantity = 0 then begin
                            SalesHeaderRec.Validate(I9G_TerminationDate, SalesHeaderRec.I9G_TerminationDate::Closed);
                        end else begin
                            SalesHeaderRec.Validate(I9G_TerminationDate, SalesHeaderRec.I9G_TerminationDate::Open);
                        end;
                        SalesHeaderRec.Modify(false);
                    end;
                end;
            end;
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
                SalesHeaderRec: Record "Sales Header";
                ItemRec: Record Item;
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    SalesHeaderRec.Reset();
                    SalesHeaderRec.SetRange("Document Type", "Document Type");
                    SalesHeaderRec.SetRange("No.", "Document No.");
                    if SalesHeaderRec.FindFirst() then begin
                        SalesHeaderRec.I9G_ProductCode := "No.";
                        SalesHeaderRec.Modify(false);
                    end;
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
        modify(Description)
        {
            trigger OnAfterValidate()
            var
                CompanyInformationRec: Record "Company Information";
                SalesHeaderRec: Record "Sales Header";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    SalesHeaderRec.Reset();
                    SalesHeaderRec.SetRange("Document Type", "Document Type");
                    SalesHeaderRec.SetRange("No.", "Document No.");
                    if SalesHeaderRec.FindFirst() then begin
                        SalesHeaderRec.I9G_ProductDescription := "No.";
                        SalesHeaderRec.Modify(false);
                    end;
                end;
            end;
        }
        modify("Description 2")
        {
            trigger OnAfterValidate()
            var
                CompanyInformationRec: Record "Company Information";
                SalesHeaderRec: Record "Sales Header";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    SalesHeaderRec.Reset();
                    SalesHeaderRec.SetRange("Document Type", "Document Type");
                    SalesHeaderRec.SetRange("No.", "Document No.");
                    if SalesHeaderRec.FindFirst() then begin
                        SalesHeaderRec.I9G_ProductDescription2 := "No.";
                        SalesHeaderRec.Modify(false);
                    end;
                end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                CompanyInformationRec: Record "Company Information";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    Validate(I9G_OpenQuantity, "Quantity" - "Quantity Invoiced");
                end;
            end;
        }
    }
}