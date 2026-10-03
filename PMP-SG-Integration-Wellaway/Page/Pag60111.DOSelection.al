page 60111 DOSelection
{

    ApplicationArea = All;
    Caption = 'List of DOs to reverse Status:';
    PageType = List;
    SourceTable = "Sales Shipment Header";
    SourceTableView = where("Order Invoiced in PMP" = const(true));
    UsageCategory = Tasks;
    //SourceTableTemporary = true;
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
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = all;
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
            action("Update Status")
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
                    SelSHRec: Record "Sales Shipment Header";
                begin
                    SelSHRec.reset;
                    CurrPage.SetSelectionFilter(SelSHRec);
                    if SelSHRec.Count > 0 then begin
                        if Confirm('Are you sure you wish to remove the invoiced status for these documents?') then begin
                            if SelSHRec.FindSet() then
                                repeat
                                    WellCU.UpdateInvoicedStatus(SelSHRec."No.");
                                until SelSHRec.next = 0;
                            Message('Documents have been updated to not invoiced. You can continue to invoice these documents again.');
                            //LoadData();     //Refresh the data in the page.
                        end;

                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //        LoadData();

    end;

    local procedure LoadData()
    var
        myInt: Integer;
        SHRec: Record "Sales Shipment Header";
        WellCU: Codeunit "Wellaway CU";
    begin

        if Rec.IsTemporary then
            Rec.DeleteAll();

        SHRec.reset;
        SHRec.ChangeCompany(WellCU.GetWellawayCompany());
        SHRec.SetRange("Order Invoiced in PMP", true);
        if SHRec.FindSet() then     //DX        25 July 2021        Get total unique combination of all item orders
            repeat
                clear(Rec);
                Rec.Copy(SHRec);
                rec.insert(FALSE);
            until SHRec.next = 0;

    end;

    var
        WellCU: Codeunit "Wellaway CU";


}
