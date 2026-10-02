tableextension 55021 VendorExt extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(55000; "Vendor Status"; Option)
        {
            OptionMembers = Active,"On Hold",Inactive,Closed;
            DataClassification = ToBeClassified;
        }
        field(55001; "Status Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(55002; "Status Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55003; "Store Information"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55004; "Accpac Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(55005; "Biz Registration Type"; Option)
        {
            OptionMembers = Ltd,"Pte Ltd","Sole-Proprietorship",Partnership;
            DataClassification = ToBeClassified;
        }

        //DX        14 July 2021
        field(55006; "Exchangeable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        14 July 2021

        field(55007; "Freight Insurance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //RL        29 Dec 2021
        field(55008; "ShortcutDim3Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, ShortcutDim3Code);
            end;
        }
        field(55009; "ShortcutDim4Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, ShortcutDim4Code);
            end;
        }
        field(55010; "ShortcutDim5Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, ShortcutDim5Code);
            end;
        }
        field(55011; "ShortcutDim6Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, ShortcutDim6Code);
            end;
        }
        field(55012; "ShortcutDim7Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, ShortcutDim7Code);
            end;
        }
        field(55013; "ShortcutDim8Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, ShortcutDim8Code);
            end;
        }
        //RL        29 Dec 2021
        //RL        18 Feb 2022
        field(55014; "Payment Week"; Option)
        {
            OptionMembers = " ",Week1,Week2,Week3,Week4,COD,"Every 60 Days";
            DataClassification = ToBeClassified;
        }
        //RL        18 Feb 2022
        field(55015; "Ship From Country"; Code[20])
        {
            TableRelation = "Country/Region";
            DataClassification = ToBeClassified;
        }

        //DX        12 Apr 2023
        field(55016; I9G_CreditLimitLCY; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Vendor Credit Limit (LCY)';
        }
        //DX        12 Apr 2023
    }

}