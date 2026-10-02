page 56201 PurchReturnSelection
{

    ApplicationArea = All;
    Caption = 'List of Purchase Returns to retrieve:';
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
            action("Generate TO")
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
                    SelCustRec: Record "Transfer Shipment Header" temporary;

                begin
                    if CompanyName <> 'OHPL' then
                        Error('Please only execute this process in OHPL.');
                    if Confirm('Are you sure you wish to create TO for these returns?') then begin
                        SelCustRec.copy(rec, true);
                        CurrPage.SetSelectionFilter(SelCustRec);
                        if SelCustRec.FindSet() then
                            repeat

                                OHPLCU.CreateTOinOH(SelCustRec."No.");
                            until SelCustRec.next = 0;
                        Message('Return Order Created');
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
        SHRec: Record "Return Shipment Header";
        SSSetup: Record "Sales & Receivables Setup";
        TotalQty: Decimal;
        userRec: Record User;
    begin

        if Rec.IsTemporary then
            Rec.DeleteAll();

        SSSetup.reset;
        SSSetup.ChangeCompany('PMP');
        SSSetup.get;
        SHRec.reset;
        SHRec.ChangeCompany('PMP');
        SHRec.SetFilter("Interco Order No.", '%1', '');
        SHRec.SetFilter("Buy-from Vendor No.", SSSetup."Default OH Vendor Code");
        if SHRec.FindSet() then
            repeat
                clear(Rec);
                Rec."No." := SHRec."No.";
                rec."Transfer Order No." := SHRec."Return Order No.";
                Rec."Posting Date" := SHRec."Posting Date";
                Rec.Insert(FALSE);
            until SHRec.next = 0

    end;

    var
        OHPLCU: Codeunit "Hyphens PMP Interco CU";

}
