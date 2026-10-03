pageextension 55052 SalesLinePageExt extends "Sales Lines"
{
    layout
    {
        addafter("No.")
        {
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = all;
            }
        }

        addafter("Outstanding Quantity")
        {
            field(SystemModifiedByDescr; SystemModifiedByDescr)
            {
                Caption = 'Sales Header System Modified By';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }


    var
        SystemModifiedByGUID: Guid;
        SystemModifiedByDescr: Text;

    local procedure RefreshAdditionalData()
    var
        SHRec: Record "Sales Header";
        UserRec: Record User;
    begin
        SystemModifiedByDescr := '';

        SHRec.Reset;
        SHRec.SetRange("Document Type", Rec."Document Type");
        SHRec.SetRange("No.", Rec."Document No.");
        if SHRec.FindFirst() then begin
            SystemModifiedByGUID := SHRec.SystemModifiedBy;
            if UserRec.Get(SystemModifiedByGUID) then begin
                SystemModifiedByDescr := UserRec."User Name" + ' ' + SystemModifiedByGUID;
            end;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        RefreshAdditionalData();
    end;

    trigger OnAfterGetRecord()
    begin
        RefreshAdditionalData();
    end;
}
