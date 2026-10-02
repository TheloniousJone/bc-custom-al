page 56200 TransShipSelection
{

    ApplicationArea = All;
    Caption = 'List of Transfer Shipments to retrieve:';
    PageType = List;
    SourceTable = "Transfer Shipment Header";
    UsageCategory = Tasks;
    SourceTableTemporary = true;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                field("TO Created By"; Rec."TO Created By")
                {
                    ApplicationArea = all;
                }
                field("Transfer Order No."; Rec."Transfer Order No.")

                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Generate PO")
            {
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Create;
                trigger OnAction()
                var
                    myInt: Integer;
                    SelCustRec: Record "Transfer Shipment Header";
                begin
                    if CompanyName <> 'PMP' then
                        Error('Please only execute this process in PMP.');
                    if Confirm('Are you sure you wish to create PO for these transfers?') then begin
                        CurrPage.SetSelectionFilter(SelCustRec);
                        if SelCustRec.FindSet() then
                            repeat
                                OHPLCU.CreatePOinPMP(SelCustRec."No.");
                            until SelCustRec.next = 0;
                        Message('Purchase Order Created');
                        LoadData();     //Refresh the data in the page.

                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        LoadData();

    end;

    local procedure LoadData()
    var
        myInt: Integer;
        SLRec: Record "Sales Line";
        SHRec: Record "Transfer Shipment Header";
        SSSetup: Record "Sales & Receivables Setup";
        TotalQty: Decimal;
        userRec: Record User;
    begin

        if Rec.IsTemporary then
            Rec.DeleteAll();

        SSSetup.reset;
        SSSetup.ChangeCompany('OHPL');
        SSSetup.get;
        SHRec.reset;
        SHRec.ChangeCompany('OHPL');
        SHRec.SetFilter("Interco Order No", '%1', '');
        SHRec.SetFilter("Transfer-to Code", SSSetup."Def PMP WH Location");
        if SHRec.FindSet() then
            repeat
                clear(Rec);
                Rec."No." := SHRec."No.";
                Rec."Posting Date" := SHRec."Posting Date";
                rec."Transfer Order No." := shrec."Transfer Order No.";
                rec."Transfer-to Code" := shrec."Transfer-to Code";
                rec.Remarks := SHRec.Remarks;
                rec."TO Created By" := SHRec."TO Created By";
                Rec.SystemCreatedBy := SHRec.SystemCreatedBy;
                Rec.Insert(FALSE);
            until SHRec.next = 0

    end;

    var
        OHPLCU: Codeunit "Hyphens PMP Interco CU";

}
