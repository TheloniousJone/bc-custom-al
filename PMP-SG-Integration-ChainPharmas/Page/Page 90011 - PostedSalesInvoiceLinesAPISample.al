page 90011 "PostedSalesInvLinesAPISamples"
{

    ApplicationArea = All;
    Caption = 'PostedSalesInvLinesAPISamples';
    PageType = List;
    SourceTable = "Sales Invoice Line";
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(General)
            {

                field(Line_No; rec."Line No.")
                {
                    ApplicationArea = All;
                }

                field(Buyer_Item_Code; BuyerItemCode)
                {
                    ApplicationArea = All;
                }
                field(Buyer_Item_Code_2; '')
                {
                    ApplicationArea = All;
                }

                field(Supplier_Item_Code; SupplierItemCode)
                {
                    ApplicationArea = All;
                }
                field(BarCodeItem; BarCodeItem)
                {
                    ApplicationArea = all;
                }
                /*                field(Barcode; rec."Item Reference No.")
                                {
                                    ApplicationArea = All;
                                }
                */
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }

                field(UOM; rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }

                field(Pack_Size; PackSize)
                {
                    ApplicationArea = All;
                }


                field(Order_Quantity; rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(price; rec."Unit Price")
                {
                    ApplicationArea = All;
                }

                field(Line_Amount; rec."Line Amount")
                {
                    ApplicationArea = All;
                }

                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = All;
                }

            }

        }

    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //DX        21 Sept 2021
        BuyerItemCode := '';
        SupplierItemCode := '';
        PackSize := 0;
        BarCodeItem := '';
        CPL.reset;
        CPL.SetCurrentKey("Sales Order No.", "Sales Line No.");
        CPL.SetLoadFields("Sales Order No.", "Sales Line No.", "Buyer Item Code", "Pack Size", Barcode);
        CPL.SetRange("Sales Order No.", rec."Order No.");
        CPL.SetRange("Sales Line No.", rec."Line No.");
        if CPL.findfirst then begin
            BuyerItemCode := CPL."Buyer Item Code";
            //DX        28 Sept 2021

            //SupplierItemCode := CPL."Supplier Item Code ";
            //DX        28 Sept 2021
            PackSize := CPL."Pack Size";
            BarCodeItem := CPL.Barcode;
        end;
        //DX        28 Sept 2021
        SupplierItemCode := Rec."No.";
        //DX        28 Sept 2021
        //DX        21 Sept 2021

        StagingPOHeader.Reset();
        StagingPOHeader.SetCurrentKey("Sales Order No.");
        StagingPOHeader.SetLoadFields("Sales Order No.", Chain, "Store Code");
        StagingPOHeader.SetRange("Sales Order No.", rec."Order No.");

        if StagingPOHeader.FindFirst() then begin

            ChainLocMapping.Reset();
            ChainLocMapping.SetRange("Chain Code", StagingPOHeader.Chain);
            ChainLocMapping.SetRange("Chain Location Code", StagingPOHeader."Store Code");
            if ChainLocMapping.FindFirst() then begin
                // SHRec.Validate("Sell-to Customer No.", ChainLocMapping."Customer No.");
                ItemRefCustCode := ChainLocMapping."Item Ref Customer No.";
            end;

            StagingPOLine.Reset();
            StagingPOLine.SetCurrentKey("Sales Order No.", "Sales Line No.");
            StagingPOLine.SetLoadFields("Sales Order No.", "Sales Line No.", "Buyer Item Code");
            StagingPOLine.SetRange("Sales Order No.", rec."Order No.");
            StagingPOLine.SetRange("Sales Line No.", rec."Line No.");

            if StagingPOLine.findfirst then begin
                ItemReferenceRec.Reset;
                ItemReferenceRec.SetCurrentKey("Reference Type", "Reference Type No.", "Reference No.");
                ItemReferenceRec.SetLoadFields("Reference Type", "Reference Type No.", "Reference No.");
                ItemReferenceRec.SetRange("Reference Type", ItemReferenceRec."Reference Type"::Customer);
                ItemReferenceRec.SetRange("Reference Type No.", ItemRefCustCode);
                ItemReferenceRec.SetRange("Reference No.", StagingPOLine."Buyer Item Code");
                if ItemReferenceRec.FindFirst() then begin
                    rec."Item Reference No." := ItemReferenceRec."Reference No.";
                end;
            end;

        end;
        if (rec."Apply Chain Conversion" = true) and (PackSize > 0) then begin
            Rec.Quantity := Rec.Quantity / PackSize;
            Rec."Unit Price" := Rec."Unit Price" * PackSize;
        end;

    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //SetPageData();
    end;

    local procedure SetPageData()
    var
        myInt: Integer;
        SIRec: Record "Sales Invoice Line";
        SHRec: Record "Sales Invoice Header";
    begin

        SIRec.reset;
        SHRec.reset;
        SHRec.SetCurrentKey(Exported, "Chain Pharmacy");
        SHRec.SetLoadFields(Exported, "Chain Pharmacy", "No.", "Apply Chain Conversion");
        SHRec.setfilter(Exported, '=%1', false);
        SHRec.setfilter("Chain Pharmacy", '=%1', true);
        if SHRec.findset then
            repeat
                sirec.reset;
                SIRec.SetCurrentKey("Document No.", Type, "No.", Quantity);
                SIRec.SetLoadFields("Document No.", Type, "No.", Quantity, "Posting Date", "Line No.", "Order No.", Description, "Unit of Measure Code", "Unit Price", Quantity
                , "Line Amount");
                SIRec.SetRange("Document No.", SHRec."No.");
                //DX        28 Sept 2021    Must export with item, cannot be comment / blank
                SIRec.SetRange(Type, SIRec.Type::Item);
                SIRec.SetFilter("No.", '<>%1', '');
                SIRec.SetFilter(Quantity, '<>0');
                //DX        28 Sept 2021
                if SIRec.FindSet() then
                    repeat
                        rec."No." := SIRec."No.";
                        rec."Document No." := SIRec."Document No.";
                        rec."Posting Date" := SIRec."Posting Date";
                        rec."Line No." := SIRec."Line No.";
                        rec."Order No." := sirec."Order No.";
                        //rec."Item Reference No." := SIRec."Item Reference No.";
                        rec.Description := SIRec.Description;
                        rec."Unit of Measure Code" := SIRec."Unit of Measure Code";
                        rec."Unit Price" := SIRec."Unit Price";
                        rec.Quantity := SIRec.Quantity;
                        rec."Line Amount" := sirec."Line Amount";
                        if ((SHRec."Apply Chain Conversion" = true) and (SIRec."Apply Chain Conversion" = true)) then
                            rec."Apply Chain Conversion" := true;
                        Rec.insert(FALSE);
                    until SIRec.next = 0;

            until SHRec.next = 0;


    end;

    var
        Addr: Text[1000];
        ILERec: Record "Item Ledger Entry";
        DONumber: text[20];
        DODate: date;
        CPL: Record "Chain PO Line";
        BuyerItemCode: text[20];
        SupplierItemCode: text[20];
        PackSize: Decimal;
        ChainLocMapping: Record "Cust. Chain Location Mapping";
        ItemReferenceRec: Record "Item Reference";
        StagingPOHeader: Record "Chain PO Header";
        StagingPOLine: Record "Chain PO Line";
        ItemRefCustCode: code[50];
        BarCodeItem: Text[100];
        OrderQuantity: Decimal;
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
