tableextension 55010 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(55001; "Exclusive Salesperson"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(55002; "Not Salesperson"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(55003; "LS Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55004; "FOC Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55005; "Order Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55006; "Selling Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //DX        17 Jun 2021 : Approval checkbox by line
        field(55007; "Max Qty Approval"; boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        17 Jun 2021 : Approval checkbox by line
        //DX        28 July 2021
        field(55008; "Qty To Deliver"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55009; "FOC (Qty) To Deliver"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55010; "Qty Delivered"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55011; "FOC Qty Delivered"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //DX        28 July 2021
        //DX        08 Aug 2021
        field(55012; Principal; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        //DX        08 Aug 2021
        //DX        15 Aug 2021
        field(55013; "To Del. Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //DX        15 Aug 2021

        // YF 25 Aug 2021
        field(55014; "PO Import Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        // YF 25 Aug 2021

        //DX        09 Sept 2021
        field(55015; "STO Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //DX        09 Sept 2021

        // YF        14 Oct 2021
        field(55016; "Out of Stock"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Out of Stock';
        }

        field(55017; "Insufficient Stocks in Pick"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Insufficient Stocks in Active Area';
        }
        // YF        14 Oct 2021

        // YF        22 Oct 2021
        field(55018; "ZP Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer Name';
        }

        field(55019; "ZP SP"; Text[100])        //DX        16 May 2023 : Increase field length
        {
            DataClassification = ToBeClassified;
            Caption = 'SP';
        }

        field(55020; "ZP Detailman"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Detailman';
        }
        // YF        22 Oct 2021

        //RL    25 May 2022 - Start
        field(55021; "I9G Item Status"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item Status';
        }
        //RL    25 May 2022 - End
        field(55022; "I9G Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Remarks';
        }
        field(55023; "I9G Driver Reason"; Text[250])
        {
            Caption = 'Driver Reason';
        }
        //LK281123
        field(55024; "I9G QC/QA Comments"; Text[100])
        {
            Caption = 'QC/QA Comments';
        }
        //LK281123

        field(55025; "Chain Remarks"; Option)//LK02042024 - unused field
        {
            Caption = 'Chain Remarks';
            OptionMembers = " ","PO less than $100","Short-expiry goods U+2013 Principal Approved","Short-expiry goods U+2013 Customer Approved","Short-expiry goods U+2013 Customer Rejected","Short-expiry goods U+2013 Principal Rejected","Insufficient stock to supply","ANS","Rejected delivery due to short shelf life","MOQ not met","Limited quantity items not fulfilled","Cancel/ Revise PO","STO","Qty reduced due to short expiry";
        }
        //LK02042024
        field(55026; I9G_ChainRemarks; Option)
        {
            Caption = 'Chain Remarks';
            OptionMembers = " ","PO less than $100","Short-expiry goods U+2013 Principal Approved","Short-expiry goods U+2013 Customer Approved","Short-expiry goods U+2013 Customer Rejected","Short-expiry goods U+2013 Principal Rejected","Insufficient stock to supply","ANS","Rejected delivery due to short shelf life","MOQ not met","Limited quantity items not fulfilled","Cancel/ Revise PO","STO","Qty reduced due to short expiry";
        }
        //LK02042024
        field(55027; "I9G_TotalReservedQty"; Decimal)
        {
            Caption = 'Total Reserved Qty';
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                            "Source Type" = const(37),
                                                                            "Source Subtype" = const("1"),
                                                                            "Reservation Status" = const(Reservation),
                                                                            "Location Code" = field("Location Code"),
                                                                            "Variant Code" = field("Variant Code")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        //DX        25 May 2026 CR
        field(55053; I9G_Restriction; Text[250])
        {
            FieldClass = Normal;
            Caption = 'Restriction';
            TableRelation = ItemRestrictions.RestrictionName;
        }
        field(55054; I9G_RequiredLOU; Boolean)
        {
            FieldClass = Normal;
            Caption = 'Require LOU';
        }
        //DX        25 May 2026 CR        

        field(55084; MinShelf; Date)
        {
            Caption = 'Min Shelf Life';
        }
        //DX        26 May 2026
        field(55088; "I9G_LineNFRemarks"; Code[100])
        {
            caption = 'NF Line Remarks';
            //TableRelation = NFLineRemarks.Code;
        }
        //DX        26 May 2026

    }
    trigger OnAfterInsert()
    var
        myInt: Integer;
        ItemRec: record iTem;
    begin
        if (Rec.Type = rec.Type::item) and (Rec."No." <> '') then begin

            ItemRec.reset;
            itemrec.SetLoadFields(I9G_RequiredLOU, I9G_Restriction);
            ItemRec.SetRange("No.", Rec."No.");
            if ItemRec.FindFirst() then begin
                Rec.I9G_RequiredLOU := itemrec.I9G_RequiredLOU;
                Rec.I9G_Restriction := itemrec.I9G_Restriction;
            end;
        end
    end;
}
