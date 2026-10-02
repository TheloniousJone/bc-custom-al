//page 90007 "Posted Sales Invoice API" //I9 070423 - Update Version
page 90010 "PostedSalesInvoiceAPISamples"

{

    ApplicationArea = All;
    Caption = 'Posted Sales Invoice API Samples';
    PageType = List;
    SourceTable = "Sales Invoice Header";
    Permissions = TableData "Sales Invoice Header" = rm;
    AccessByPermission = tabledata "Sales Invoice Header" = rm;
    //SourceTableTemporary = true;
    //ModifyAllowed = true;
    //Editable = true;
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(General)
            {
                //DX        21 Sept 2021
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Buyer_Code; BuyerCode)
                {
                    ApplicationArea = all;
                }
                field(Buyer_Name; CustRec.Name)
                {
                    ApplicationArea = All;
                }
                field(Buyer_PostalCode; CustRec.City)
                {
                    ApplicationArea = All;
                }

                field(Buyer_Address_1; CustRec.Address)
                {
                    ApplicationArea = All;
                }
                field(Buyer_Address_2; CustRec."Address 2")
                {
                    ApplicationArea = All;
                }
                field(Buyer_Address_3; '')
                {
                    ApplicationArea = All;
                }
                field(Buyer_Address_4; '')
                {
                    ApplicationArea = All;
                }
                field("Supplier Code"; SupplierCode)
                {
                    ApplicationArea = All;
                }
                field("Tax Amount"; rec."Amount Including VAT" - rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(GST_Percent; GetGST(rec."Amount Including VAT", rec.Amount))
                {
                    ApplicationArea = all;
                }

                field(Seller_Name; CompInfo.Name)
                {
                    ApplicationArea = all;
                }
                field(Seller_PostalCode; CompInfo."Post Code")
                {
                    ApplicationArea = all;
                }
                field(Seller_Address_1; CompInfo.Address)
                {
                    ApplicationArea = all;
                }
                field(Seller_Address_2; CompInfo."Address 2")
                {
                    ApplicationArea = all;
                }
                field(Seller_Address_3; '')
                {
                    ApplicationArea = all;
                }
                field(Seller_Address_4; '')
                {
                    ApplicationArea = all;
                }
                field(External_Document_Create_Date; format(ExtDocCreateDate))
                {
                    ApplicationArea = All;
                }
                field("External Document No."; rec."External Document No.")

                {
                    ApplicationArea = All;
                }

                field("Shipment Date"; rec."Shipment Date")
                {
                    ApplicationArea = All;
                }
                //DO Number
                field(Shipment_Document_No; DONumber)
                {
                    ApplicationArea = All;
                }

                //store code

                field(Amount; rec.Amount)
                {
                    ApplicationArea = All;
                }

                field("Amount Including VAT"; rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                }

                field("Store Code"; StoreCode)
                {
                    ApplicationArea = All;
                }
                field("Store Name"; StoreName)
                {
                    ApplicationArea = all;
                }

                field(Exported; Rec.Exported)
                {
                    ApplicationArea = All;
                }

            }

        }

    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        VLERec: Record "Value Entry";
    begin

        VLERec.Reset();
        VLERec.SetCurrentKey("Document No.", "Posting Date");
        VLERec.SetLoadFields("Document No.", "Posting Date", "Item Ledger Entry No.");
        VLERec.SetRange("Document No.", rec."No.");
        VLERec.SetRange("Posting Date", rec."Posting Date");
        if VLERec.findfirst then begin
            ILERec.reset;
            ILERec.SetCurrentKey("Entry No.");
            ILERec.SetLoadFields("Entry No.", "Document No.", "Posting Date");
            ILERec.SetRange("Entry No.", VLERec."Item Ledger Entry No.");
            if ILERec.findfirst then begin
                DONumber := ILERec."Document No.";
                DODate := ILERec."Posting Date";
            end;
        end;

        CPH.Reset();
        CPH.SetCurrentKey("Sales Order No.");
        CPH.SetLoadFields("Sales Order No.", "Buyer Code", "Buyer Name", "Supplier Code", "Supplier Name", "Store Code", "Store Name", "PO Date");
        CPH.SetRange("Sales Order No.", rec."Order No.");
        if CPH.FindFirst() then begin
            BuyerCode := CPH."Buyer Code";
            BuyerName := CPH."Buyer Name";
            SupplierCode := CPH."Supplier Code";
            SupplierName := CPH."Supplier Name";
            StoreCode := CPH."Store Code";
            ExtDocCreateDate := CPH."PO Date";
            StoreName := CPH."Store Name";
        end else begin
            BuyerCode := '';
            BuyerName := '';
            SupplierCode := '';
            ExtDocCreateDate := 0D;
            SupplierName := '';
            StoreCode := '';
            StoreName := '';
        end;


        Address1 := '';
        Address2 := '';
        Name := '';
        Postcode := '';

        CustRec.reset;
        //if Rec."Bill-to Customer No." <> '' then
        CustRec.SetCurrentKey("No.");
        CustRec.SetLoadFields("No.", Address, "Address 2", Name, City);
        CustRec.SetRange(CustRec."No.", Rec."Bill-to Customer No.");
        //else
        //    CustRec.SetRange(CustRec."No.", Rec."Sell-to Customer No.");
        if CustRec.FindFirst() then begin
            Address1 := CustRec.Address;
            Address2 := CustRec."Address 2";
            Name := CustRec.Name;
            Postcode := CustRec.City;

            if CustRec."Language Code" = '' then
                LangCode := 'en'
            else
                LangCode := CustRec."Language Code";
        end;
        StateCode := 'Singapore';

    end;

    trigger OnModifyRecord(): Boolean
    begin
        //CODEUNIT.Run(CODEUNIT::PostedSalesInvoiceUpdateCU, Rec);
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CompInfo.reset;
        // CompInfo.get;
        // SetPageData();
    end;

    local procedure SetPageData()
    var
        myInt: Integer;
        SIRec: Record "Sales Invoice Header";

    begin
        SIRec.reset;
        SIRec.SetCurrentKey(Exported, "Chain Pharmacy");
        SIRec.SetLoadFields(Exported, "Chain Pharmacy", "Sell-to Customer No.", "Bill-to Customer No.", "No.", "Posting Date", "External Document No.", "Order No.", "Shipment Date",
        Amount, "Amount Including VAT", Exported, "Chain Pharmacy");
        SIRec.setfilter(Exported, '=%1', false);
        SIRec.setfilter("Chain Pharmacy", '=%1', true);
        if SIRec.FindSet() then
            repeat
                Rec."Sell-to Customer No." := SIRec."Sell-to Customer No.";
                Rec."Bill-to Customer No." := SIRec."Bill-to Customer No.";
                rec."No." := SIRec."No.";
                rec."Posting Date" := SIRec."Posting Date";
                rec."External Document No." := SIRec."External Document No.";
                rec."Order No." := SIRec."Order No.";
                rec."Shipment Date" := SIRec."Shipment Date";
                rec.Amount := SIRec.Amount;
                rec."Amount Including VAT" := SIRec."Amount Including VAT";
                rec.Exported := sirec.Exported;
                rec."Chain Pharmacy" := SIRec."Chain Pharmacy";
                Rec.insert(FALSE);
            until SIRec.next = 0;
    end;

    local procedure GetGST(AmtInclVAT: Decimal; AmtExclVat: Decimal): Decimal
    var
        myInt: Integer;
        GSTDec: Decimal;
    begin
        //214 - 200

        GSTDec := AmtInclVAT - AmtExclVat;
        if (AmtExclVat <> 0) AND (GSTDec <> 0) then
            GSTDec := Round((GSTDec / AmtExclVat) * 100, 1);

        exit(GSTDec);
    end;

    var
        Addr: Text[1000];
        ILERec: Record "Item Ledger Entry";
        DONumber: text[20];
        DODate: date;
        CPH: Record "Chain PO Header";
        BuyerCode: text[20];
        BuyerName: text[100];
        SupplierCode: text[20];
        SupplierName: text[100];
        StoreCode: text[20];
        StoreName: text[100];
        CustRec: Record customer;
        ExtDocCreateDate: Date;
        LangCode: code[20];
        StateCode: Code[50];
        Name: Text[100];
        City: Text[100];
        Address1: text[100];
        Address2: Text[200];
        Postcode: Text[100];
        CompInfo: Record "Company Information";
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
