pageextension 55014 PostedSalesInvListExt extends "Posted Sales Invoices"
{
    layout
    {
        addafter(Amount)
        {
            field("Order Status"; Rec."Order Status")
            {
                ApplicationArea = all;
            }

        }
        addafter("Sell-to Customer Name")
        {
            field(Branch; Branch)
            {
                ApplicationArea = all;
            }
            field("Chain Pharmacy"; Rec."Chain Pharmacy")
            {
                ApplicationArea = all;
            }
            field(Exported; Rec.Exported)
            {
                ApplicationArea = all;
            }
            field("Order Taken By"; Rec."Order Taken By")
            {
                ApplicationArea = all;
            }
            field("Samples SO"; Rec."Samples SO")
            {
                ApplicationArea = All;
            }
            field("Sell-to Address"; Rec."Sell-to Address")
            {
                ApplicationArea = All;
                Visible = false;
            }
            //RL 19 Oct 2022
            field("I9 Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                Caption = 'Your Reference';
                ToolTip = 'Specifies the customer''s reference. The contents will be printed on sales documents.';
            }

            //RL 19 Oct 2022

            //RL 01 Feb 2023
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how the customer must pay for products on the sales document.';
            }
            //RL 01 Feb 2023
            field("Customer Group"; Rec."Customer Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Group field.', Comment = '%';
            }
        }


    }

    actions
    {
        //DX        09 July 2021
        addafter(Customer)
        {
            action("Scan Invoices")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page ScanInvoice;
            }

        }
        //DX        09 July 2021
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Branch := '';
        if Rec."Sell-to Customer No." <> '' then begin
            CustRec.reset;
            CustRec.SetLoadFields("No.", "Branch/Subsidiary");       //DX        03 May 2023
            CustRec.SetRange("No.", Rec."Sell-to Customer No.");
            if CustRec.FindFirst() then begin
                Branch := CustRec."Branch/Subsidiary";
            end;
        end;
    end;

    var
        CustRec: Record customer;
        Branch: text[100];
}
