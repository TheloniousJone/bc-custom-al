pageextension 55013 SalesOrderListExt extends "Sales Order List"
{

    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
            {
                ApplicationArea = all;
            }
            field("I9G_Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
                Caption = 'Your Reference';
            }
        }
        modify("No.")
        {
            StyleExpr = FavStyle;
            Style = Favorable;
        }
        modify("Sell-to Customer No.")
        {
            StyleExpr = FavStyle;
            Style = Favorable;
        }
        modify("Sell-to Customer Name")
        {
            StyleExpr = FavStyle;
            Style = Favorable;
        }
        modify("External Document No.")
        {
            StyleExpr = FavStyle;
            Style = Favorable;
        }

        modify("Location Code")
        {

            StyleExpr = FavStyle;
            Style = Favorable;

        }
        addafter("Location Code")
        {
            //DX        08 June 2023
            FIELD("Sales Area"; Rec."Sales Area")
            {
                ApplicationArea = all;
                Caption = 'Area Code';
            }
            field(Salesrep; Salesrep)
            {
                ApplicationArea = all;
                Caption = 'Sales Rep (WS)';
            }
            //DX        08 June 2023
            field("Order Status"; Rec."Order Status")
            {
                ApplicationArea = all;
                StyleExpr = FavStyle;
                Style = Favorable;

            }
            //LK24 Jun 2024
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
                Caption = 'Sales Order Date';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
            }
            //LK24 Jun 2024
            field(SystemCreatedBy; enhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            //LK24 Jun 2024
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = all;
            }
            field(SystemModifiedBy; enhanceCU.GetUserName(Rec.SystemModifiedBy))
            {
                ApplicationArea = all;
            }
            //LK24 Jun 2024

            //DX        21 Sept 2021
            field(EnoughStock; EnoughStock)
            {
                ApplicationArea = all;
                Caption = 'Order Lines Stock Status';
                Style = Favorable;
                StyleExpr = StockBool;
            }
            //DX        21 Sept 2021

            // YF        14 Oct 2021
            field("Out of Stock"; Rec."Out of Stock")
            {
                ApplicationArea = All;
                Caption = 'Out of Stock';
                Style = Favorable;
                StyleExpr = OOSBool;
                Editable = false;
            }

            field("Insufficient Stocks in Pick"; Rec."Insufficient Stocks in Pick")
            {
                ApplicationArea = All;
                Caption = 'Insufficient Stocks in Active Area';
                Style = Favorable;
                StyleExpr = IStkBool;
                Editable = false;
            }
            // YF        14 Oct 2021
        }
        addafter(Amount)
        {
            field(RecCreated; RecCreated)
            {
                Caption = 'WH Shipment Created.';
                ApplicationArea = all;
                Editable = false;
            }
        }
        addlast(Control1)
        {

            field("Priority Picking"; Rec."Priority Picking")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Priority Picking field.';
                Visible = false;
            }
            field(I9G_Ready_to_Process_SO; Rec.I9G_Ready_to_Process_SO)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ready to Process_SO field.';
                Visible = false;
            }
            field(I9G_Push_to_Open_SO; Rec.I9G_Push_to_Open_SO)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Push to Open SO field.';
                Visible = false;
            }
            field("Customer Instructions"; Rec."Customer Instructions")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Instructions field.';
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
            }

            field("WS Membership"; Rec."WS Membership")
            {
                ApplicationArea = all;
                Visible = false;
            }
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
        addafter("P&osting")
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
            action("Release Chain SOs")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    enhanceCU.ReleaseChainOrders();
                end;
            }
        }
        /*
        modify("Create &Warehouse Shipment")
        {
            //Visible = false;
        }
        */
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(Release)
        {
            Visible = false;
        }
        //DX        09 July 2021
    }
    trigger OnOpenPage()
    var
        Comp: Record Company;
    begin
        // Comp.Reset();
        // Comp.Get();
        // CurrentCompany
        if rec.CurrentCompany = 'PMP' then begin  //RL       04 Mar 2022


            //DX        02 Aug 2021
            Rec.SetRange(Archived, false);
            //DX        02 Aug 2021
            rec.SetFilter(SystemCreatedBy, '%1|%2|%3', UserSecurityId(), enhanceCU.GetBCAdminGUID(), enhanceCU.GetBCIntegrationVendorGUID()); //RL    30 Mar 2022 - add new user
        end;
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        UserRec: Record User;
        WHRec: Record "Warehouse Activity Line";
        regWhRec: Record "Registered Whse. Activity Line";
    begin
        FavStyle := false;

        UserRec.reset;
        UserRec.SetLoadFields("User Name"); //DX        02 May 2023
        UserRec.SetCurrentKey("User Name");
        UserRec.SetFilter("User Name", '%1|%2', 'BCADMIN', 'BC INTEGRATION FOR VENDOR'); //RL    30 Mar 2022 - add new user
        if UserRec.FindSet() then
            repeat
                if Rec.SystemCreatedBy = UserRec."User Security ID" then
                    FavStyle := true;
            until UserRec.Next = 0;

        //DX        21 Sept 2021
        if (CompanyName = 'HPPL') OR (CompanyName = 'PMP') then begin   //DX        10 July 2025    Only for these 2 entities, performance
            if enhanceCU.SHHasEnoughStock(Rec) = true then begin
                EnoughStock := 'Yes';
                StockBool := true;
            end else begin
                StockBool := false;
                EnoughStock := 'No';
            end;


            //DX        21 Sept 2021
            RecCreated := false;
            WHRec.Reset();
            Whrec.SetLoadFields("Source Document", "Source No.");//DX        02 May 2023
            WHRec.SetCurrentKey("Source Document", "Source No.");
            WHRec.SetRange("Source Document", WHRec."Source Document"::"Sales Order");
            WHRec.SetRange("Source No.", Rec."No.");
            if NOT (WHRec.IsEmpty()) then begin
                RecCreated := true;
            end else begin
                regWhRec.reset;
                regWhRec.SetLoadFields("Source Document", "Source No."); //DX        02 May 2023
                regWhRec.SetCurrentKey("Source Document", "Source No.");
                regWhRec.SetRange("Source Document", regWhRec."Source Document"::"Sales Order");
                regWhRec.SetRange("Source No.", Rec."No.");
                if NOT (regWhRec.IsEmpty()) then
                    RecCreated := true
                else
                    RecCreated := false;
            end;
        end;
        // YF        14 Oct 2021
        OOSBool := Not Rec."Out of Stock";
        IStkBool := Not Rec."Insufficient Stocks in Pick";
        // YF        14 Oct 2021

        //DX        08 June 2023
        clear(Salesrep);
        CustRec.reset;
        CustRec.SetLoadFields("No.", "Corporate  Sales Rep (WS)");
        CustRec.SetRange("No.", Rec."Sell-to Customer No.");
        if CustRec.FindFirst() then
            Salesrep := CustRec."Corporate  Sales Rep (WS)";
        //DX        08 June 2023
    end;

    var
        enhanceCU: Codeunit "PMP-Enhancements";
        FavStyle: Boolean;
        EnoughStock: Text[100];
        RecCreated: Boolean;
        StockBool: Boolean;
        OOSBool: Boolean;
        IStkBool: Boolean;
        //DX        08 June 2023
        CustRec: Record Customer;
        Salesrep: Code[20];
    //DX        08 June 2023
}
