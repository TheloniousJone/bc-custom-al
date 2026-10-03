tableextension 55000 CustExt extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(55000; "Customer Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        field(55001; "Picking Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(55002; "Delivery Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(55003; "WS Rep."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
            Enabled = false;
        }
        field(55004; "HB Rep."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
            Enabled = false;
        }
        field(55005; "Agency Rep."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
            Enabled = false;
        }
        field(55006; "PMP Rep."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
            Enabled = false;
        }
        field(55007; "POM Customer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55008; "Wellaway Customer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55009; "Logistics Service"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55010; "Priority Picking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        //jr added more fields here. 10:06/20/5/2021
        field(55011; "Customer Status"; Option)
        {
            OptionMembers = Active,"On Hold",Inactive,Closed;
            DataClassification = ToBeClassified;
        }
        field(55012; "Status Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(55013; "Status Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55014; "Branch/Subsidiary"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55015; "Customer Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Group";
        }
        field(55016; "One-time Customer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55017; "Store Information"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55018; "Working Hours"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55019; "Delivery Zone"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Zone";
        }
        field(55020; "Sales Area"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Area";
        }
        field(55021; "Delivery Charge"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Charge";
        }
        field(55022; "Activate Commercial"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55023; "Commercial Permission Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(55024; "Activate Forensic"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55025; "Forensic Permmission Group"; Option)
        {
            OptionMembers = "Non-Poison",Poison;
            DataClassification = ToBeClassified;
        }
        field(55026; "Accpac"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Accpac;
        }
        field(55027; "Biz Registration Type"; Option)
        {
            OptionMembers = Ltd,"Pte Ltd","Sole-Proprietorship",Partnership;
            DataClassification = ToBeClassified;
        }
        field(55028; "Corporate  Sales Rep (HYP)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(55029; "Corporate  Sales Rep (WS)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(55030; "Corporate  Sales Rep (HB)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(55031; "Corporate  Sales Rep (4)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(55032; "Corporate  Sales Rep (5)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(55033; "E-Invoicing"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Default Shipping Cage"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Cages"."Shipping Cage Code";
        }
        //DX        27 Jun 2021  : Post testing feedback
        field(50041; "No. Of TBA Invoices"; Integer)
        {

            FieldClass = FlowField;
            CalcFormula = count("Sales Invoice Header" where("TBA Order" = const(true), "Sell-to Customer No." = field("No.")));
        }
        field(50042; "No. Of TBA DOs"; Integer)
        {

            FieldClass = FlowField;
            CalcFormula = count("TBA Ledger Entry" where("Entry Type" = const(Delivery), "Customer No." = field("No.")));
        }
        field(50043; "Bill Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Bill Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Bill Address"; Text[100]) // YF 08 Sep 2023 // Remove trailing space
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "Bill Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;

            // YF 18 Nov 2021 // Bug Fix
            trigger OnValidate()
            begin
                Rec."Bill Address 2" := CopyStr(Rec."Bill Address 2", 1, 50);
            end;
            // YF 18 Nov 2021 // Bug Fix
        }
        field(50047; "Bill City"; Text[100])
        {
            DataClassification = ToBeClassified;

            // YF 18 Nov 2021 // Bug Fix
            trigger OnValidate()
            begin
                Rec."Bill City" := CopyStr(Rec."Bill City", 1, 30);
            end;
            // YF 18 Nov 2021 // Bug Fix
        }
        field(50048; "Bill Contact"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50049; "Bill Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".Code;
            ValidateTableRelation = false;
        }
        field(50050; "Bill County"; Text[100])
        {
            DataClassification = ToBeClassified;

            // YF 18 Nov 2021 // Bug Fix
            trigger OnValidate()
            begin
                Rec."Bill County" := CopyStr(Rec."Bill County", 1, 30);
            end;
            // YF 18 Nov 2021 // Bug Fix
        }
        field(50051; "Bill Country Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region".Code;
        }
        field(50052; "Mandatory Ext Doc. No."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        27 Jun 2021  : Post testing feedback

        field(55034; "I9G_DONeeded"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'DO Needed';
        }

        //DX        18 July 2021
        field(50053; "LS Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Logistics Service % calculation.';
        }
        //DX        18 July 2021
        //DX        26 Aug 2021
        field(50054; "Acct Information"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        //DX        26 Aug 2021
        field(50055; "Chain Pharmacy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        // 50056-50057  Reserved for Contact Field - Do not use

        // YF 07 Sept 2021 // Merge Son Item Job Queue Categorization Codes
        field(55058; "Customer Sales Classification"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        // YF 07 Sept 2021 // Merge Son Item Job Queue Categorization Codes

        field(55059; "Web User Email"; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        //DX        18 Sept 2021    # 306
        field(55060; "MOH License No."; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        //DX        18 Sept 2021

        field(55061; "Credit Insurance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(55062; "Insurance Coverage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(55063; "Coverage Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(55064; "Customer Commission Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Commission Group".Code;
        }

        field(55065; "Wellaway Web User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(55066; "Wellaway Web User Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(55067; "Wellaway Web User Email"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        //DX        06 Oct 2021
        field(55068; "MyField"; Blob)   //nOT NEEDED
        {
            DataClassification = ToBeClassified;
        }
        field(55069; "Single PO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        06 Oct 2021

        //RL        29 Dec 2021
        field(55070; "ShortcutDim3Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, ShortcutDim3Code);
            end;
        }
        field(55071; "ShortcutDim4Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, ShortcutDim4Code);
            end;
        }
        field(55072; "ShortcutDim5Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, ShortcutDim5Code);
            end;
        }
        field(55073; "ShortcutDim6Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, ShortcutDim6Code);
            end;
        }
        field(55074; "ShortcutDim7Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, ShortcutDim7Code);
            end;
        }
        field(55075; "ShortcutDim8Code"; Code[20])
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
        field(55076; "WS Membership"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WS Membership";
        }
        field(55077; I9G_EmailonPriceChg; Text[500])
        {
            Caption = 'Email on Price Change';
        }

        //PK
        field(55078; I9G_Sector; Text[100])
        {
            Caption = 'Sector';
        }

        field(55079; I9G_Channel; Text[100])
        {
            Caption = 'Channel';
        }
        //PK
        //LK10May2024
        field(55080; "Corporate  Sales Rep (AP)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;

        }
        //LK10May2024
        //LK30Sept2024
        field(55081; I9G_ShowRefNo; Boolean)
        {
            Caption = 'Trigger Ref. Code';
        }
        //LK30Sept2024
        //KP11Nov2024
        field(55082; I9G_RequirementApproval; Boolean)
        {
            Caption = 'Requirement Approval';
        }
        //KP11Nov2024
        //DX        28 Jan 2025
        field(55083; I9G_PriceExtLeadTime; DateFormula)
        {
            Caption = 'Price Extension Lead Time';
        }
        //DX        28 Jan 2025
        //KP 25 Feb 2025 - Auto Invoice Email
        field(55084; I9G_AutoEmailInvEmailAddress; Text[500])
        {
            Caption = 'Auto Email Inv. Email Address';
        }
        field(55085; I9G_AutoEmailInvoice; Boolean)
        {
            Caption = 'Auto Email Invoice';
        }
        //KP 25 Feb 2025 - Auto Invoice Email
    }

    fieldgroups
    {
        //DX        15 Aug 2021 #Issue 101
        addlast(DropDown; "Branch/Subsidiary")
        {

        }
        //DX        15 Aug 2021

    }

}