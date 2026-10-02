page 60110 CustSelection
{

    ApplicationArea = All;
    Caption = 'List of customers with invoices to bill:';
    PageType = List;
    SourceTable = Customer;
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
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Generate Invoices")
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
                    SelCustRec: Record customer;
                begin
                    if Confirm('Are you sure you wish to create invoices for these customers?') then begin
                        CurrPage.SetSelectionFilter(SelCustRec);
                        if SelCustRec.FindSet() then
                            repeat
                                WellCU.GenConsolidatedInv(SelCustRec."No.");

                            until SelCustRec.next = 0;

                        Message('Sales Invoices Created.');
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
        SHRec: Record "Sales Shipment Header";
        WellCU: Codeunit "Wellaway CU";
        CustRec: Record customer temporary;
        CustRec2: Record Customer temporary;
        SLLoopChec: Record "Sales Line" temporary;
        TotalQty: Decimal;
    begin

        if Rec.IsTemporary then
            Rec.DeleteAll();

        SHRec.reset;
        SHRec.ChangeCompany(WellCU.GetWellawayCompany());
        SHRec.SetRange("Order Invoiced in PMP", false);
        if SHRec.FindSet() then     //DX        25 July 2021        Get total unique combination of all item orders
            repeat

                CustRec.reset;
                CustRec.SetRange("No.", SHRec."Sell-to Customer No.");
                if not CustRec.FindFirst() then begin
                    CustRec2.reset;
                    CustRec2.Init();
                    CustRec2."No." := SHRec."Sell-to Customer No.";
                    CustRec2."Bill-to Customer No." := SHRec."Bill-to Customer No.";
                    CustRec2.Name := SHRec."Sell-to Customer Name";
                    CustRec2.Insert(false);
                    CustRec.Init();
                    CustRec.Copy(CustRec2);
                    CustRec.Insert(false);
                end;
            until SHRec.next = 0;
        if CustRec2.count <> 0 then begin
            if CustRec2.FindSet() then
                repeat
                    clear(Rec);
                    Rec."No." := CustRec2."No.";
                    rec."Bill-to Customer No." := CustRec2."Bill-to Customer No.";
                    Rec.Name := CustRec2."Name";
                    Rec.Insert(FALSE);
                //DX        create temporary data.                  
                until CustRec2.next = 0;

        end;
    end;

    var
        WellCU: Codeunit "Wellaway CU";


}
