tableextension 70200 ItemJournalTableExt extends "Item Journal Line"
{
    fields
    {
        field(70000; "I9G_CaseNumber"; Code[150])
        {
            Caption = 'Case No.';
        }
        field(70001; "I9G_CaseDR"; Text[100])
        {
            Caption = 'Case DR';
        }
        field(70002; "I9G_ShipToDistrictCode"; Code[20])
        {
            Caption = 'Ship-to District Code';
        }
        field(70003; "I9G_ShipToPostCode"; Code[20])
        {
            Caption = 'Ship-to Post Code';
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
}