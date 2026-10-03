tableextension 55016 PurchaseInvLineExt extends "Purch. Inv. Line"
{
    fields
    {
        // Add changes to table fields here
        field(55004; "FOC Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        Field(55005; "Order Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55006; "Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //DX        08 Aug 2021
        field(55012; Principal; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        //DX        08 Aug 2021

        //DX        15 Aug 2021 For #issue 110
        field(55013; ">5K"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55014; ">300K"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55015; ">6 Mth Inventory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        15 Aug 2021

        //DX        17 Aug 2021
        field(55016; "Exchangeable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        17 Aug 2021

        // YF 29 Dec 2021
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
        // YF 29 Dec 2021     
        field(55021; "For Tender"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(55022; "Tender Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        // YF 02 Mar 2025
        field(55023; ">3 Mth Inventory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        // YF 02 Mar 2025
    }

    trigger OnAfterInsert()
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            "FOC (Qty) To Deliver" := "FOC Qty" - "FOC Qty Delivered";
            "Qty To Deliver" := "Qty Delivered" - "Order Qty";
        end;
    end;

}