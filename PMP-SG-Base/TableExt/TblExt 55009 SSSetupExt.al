tableextension 55009 SSSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(55000; "TBA Adjustment No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(55001; "Auto Assign Picker"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Auto assign picker after creating WH. Shipment';

        }
        field(55002; "Def. Checking Hdr. No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(55003; "Def. Driver Ship. No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(55004; "Def. WH. Trip No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        //DX    060521      Maximum picks per trip when assigning picker
        field(55005; "Max Picks Per Trip"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(55006; "Auto Create Pick List"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        01 Jun 2021
        field(55007; "Auto Create WH. Docs When Rel"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Auto create Warehouse documents when order is released';
        }
        //DX        01 Jun 2021
        //DX        07 Jun 2021
        field(55008; "Def. ZP Invoice Loc. Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
            Caption = 'Default location code for stock deduction when creating ZP Sales invoices.';
        }
        //DX        07 Jun 2021

        //DX        11 Jun 2021 : For Wellaway
        field(55009; "Def. Wellaway Company"; text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company.Name;
        }
        field(55010; "Def. PMP Company"; text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company.Name;
        }
        //DX        11 Jun 2021 : For Wellaway
        //DX        12 July 2021 
        field(55011; "Def. Stock Take No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        //DX        12 July 2021 
        //DX        14 July 2021 
        field(55012; "Def. Biz Segment Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            tablerelation = "Dimension Value".Code;
        }
        //DX        14 July 2021 

        //DX        18 July 2021 
        field(55013; "Def. LS Order No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;

            TableRelation = "No. Series".Code;
        }
        field(55014; "Def. LS Inv. No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(55015; "Def. LS DO. No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }

        field(55016; "Def. LS Revenue Acct."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }

        // YF 2024-10-11 // BC25 Upgrade
        field(55017; "Def. LS User Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "User Group".Code;
            TableRelation = "Aggregate Permission Set"."Role ID";
            ValidateTableRelation = false;
        }
        // YF 2024-10-11 // BC25 Upgrade

        //DX        18 July 2021 
        //DX        21 July 2021
        field(55018; "Def. Self Pick Method"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method".Code;
        }
        field(55019; "Def. LS Line Charge Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55020; "Def. LS Location COde"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        //DX        21 July 2021
        //DX        01 Aug 2021
        field(55021; "Auto Del. PL After Reg."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        01 Aug 2021
        //DX        08 Aug 2021
        field(55031; "Def. Gen Prod PG for Sample"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group".Code;
        }
        //DX        08 Aug 2021
        //DX        18 Aug 2021
        field(55032; "Def. Clearance Bin"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bin.code;
            Caption = 'Wholesale/Housebrand 6Mth';

        }

        field(55033; "Def. Disposal Bin"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code;
            Caption = 'Wholesale/Housebrand 3Mth';
        }
        //DX        18 Aug 2021  

        //DX        30 Aug 2021
        field(55034; "Def. LS Gen Prod Posting"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group".Code;
        }
        //DX        30 Aug 2021

        // YF 06 Sep 2021 // Toggle to activate hacky fix for Qty to ship/invoice and Qty shipped/invoiced sign reversal
        field(55035; "SO Line Qty Quick Fix"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'SO Line Qty to Ship/Invoice Sign Reversal Quick Fix';
        }
        // YF 06 Sep 2021 // Toggle to activate hacky fix for Qty to ship/invoice and Qty shipped/invoiced sign reversal
        //DX        21 Sept 2021

        // YF 2024-10-11 // BC25 Upgrade
        field(55036; "Def. CS Lead Role"; Code[20])
        {
            Caption = 'Role for determining CS Lead.';
            DataClassification = ToBeClassified;
            // TableRelation = "User Group".Code;
            TableRelation = "Aggregate Permission Set"."Role ID";
            ValidateTableRelation = false;
        }
        // YF 2024-10-11 // BC25 Upgrade

        //DX        21 Sept 2021
        //DX        26 Sept 2021
        field(55037; "Def. ZP Invoice Bin Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code where("Location Code" = field("Def. ZP Invoice Loc. Code"));
            Caption = 'Default location Bin code for stock deduction when creating ZP Sales invoices.';
        }
        field(55038; "Order Taken by To Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        // YF 28 Sep 2021
        field(55039; "Staff Claims Payable Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
        }

        field(55040; "Deposit Slip Clearing Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
        }
        // YF 28 Sep 2021
        //DX        06 Oct 2021
        field(55041; "Check Stock at Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        06 Oct 2021

        // YF        22 Oct 2021
        field(55042; "Zuellig Def. Inv/CR Cust. Code"; Code[20])
        {
            Caption = 'Zuellig Def. Inv/CR Cust. Code';
            TableRelation = Customer."No.";
            DataClassification = ToBeClassified;
        }
        // YF        22 Oct 2021
        field(55043; "SOA Email Body"; Text[2048])
        {
            Caption = 'SOA Email Body';
            DataClassification = ToBeClassified;
        }

        field(55044; "I9G_InvoiceFooterMsg"; Text[2048]) //RL 01 Sept 2022
        {
            Caption = 'Invoice Footer Msg';
            DataClassification = ToBeClassified;
        }

        field(55045; I9G_SalesTradeAgreementStaging; Text[2048])
        {
            Caption = 'Sales Trade Agreement Staging Email Body';
            DataClassification = ToBeClassified;
        }
        field(55046; "Spec Clearance Bin"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bin.code;
            Caption = 'Proprietary/Specialty 6Mth';

        }

        field(55047; "Spec Disposal Bin"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code;
            Caption = 'Proprietary/Specialty 3Mth';
        }
        field(55048; "Exchange Disposal Bin"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code;
            Caption = 'Disposal with Exchange';
        }

        field(55049; "Distribution Email"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Distribution Email';
        }

        // YF 2024-10-11 // BC25 Upgrade
        /*
        field(55049; "Def. LS Role ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Aggregate Permission Set"."Role ID";
        }

        field(55050; "Def. CS Lead Role ID"; Code[20])
        {
            Caption = 'Role for determining CS Lead.';
            DataClassification = ToBeClassified;
            TableRelation = "Aggregate Permission Set"."Role ID";
        }
        */
        // YF 2024-10-11 // BC25 Upgrade
        //KP 25 Feb 2025 - Auto Invoice Email
        field(55051; I9G_AutoEmailInvBody; Text[2000])
        {
            Caption = 'Auto Email Inv. Body';
        }
        //KP 25 Feb 2025 - Auto Invoice Email
    }

}