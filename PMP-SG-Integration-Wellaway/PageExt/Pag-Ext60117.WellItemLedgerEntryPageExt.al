pageextension 60117 WellItemLedgerEntryPageExt extends "Item Ledger Entries"
{
    layout
    {
        addafter(SourceName)
        {
            field(PatientName; PatientName)
            {
                ApplicationArea = all;
                Caption = 'Patient Name';
                Visible = VisibleBool;
            }
            //DX        12 Oct 2021
            field("Created By"; WellCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Visible = VisibleBool;
            }
            //DX        12 Oct 2021
        }
    }


    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        PatientName := '';
        if WellCU.IsWellawayCompany() then begin
            if (Rec."Source Type" = Rec."Source Type"::Customer) AND (Rec."Entry Type" = Rec."Entry Type"::Sale) and (Rec."Document Type" = Rec."Document Type"::"Sales Shipment") then begin
                SHRec.reset;
                shrec.SetRange("No.", Rec."Document No.");
                if SHRec.FindFirst() then begin
                    PatientRec.reset;
                    PatientRec.SetRange("No.", SHRec."Patient No.");
                    if PatientRec.FindFirst() then
                        PatientName := PatientRec.Name
                    else
                        PatientName := SHRec."Patient Name"; // YF 31 Oct 2025
                end;
            end;
        end;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if WellCU.IsWellawayCompany() then
            VisibleBool := true else
            VisibleBool := false;
    end;

    var
        WellCU: Codeunit "Wellaway CU";
        PatientName: text[100];
        SHRec: Record "Sales Shipment Header";
        PatientRec: Record Patient;
        VisibleBool: Boolean;
}
