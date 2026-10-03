tableextension 55019 SalesLineArchiveExt extends "Sales Line Archive"
{
    fields
    {
        // Add changes to table fields here
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
        field(55009; "FOC Qty To Deliver"; Decimal)
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

        field(55019; "ZP SP"; Text[100])      //DX        16 May 2023 : Increase field length
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
        field(55024; "I9G QC/QA Comments"; Text[100])
        {
            Caption = 'QC/QA Comments';
        }
        //LK281123
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

}