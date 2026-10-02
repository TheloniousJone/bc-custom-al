tableextension 55008 ItemExt extends Item
{
    fields
    {
        // Add changes to table fields here
        field(55000; Classification; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",A,B,C;
        }
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

        //jr added more fields here. 5:55/19/5/2021
        field(55003; "Item Status"; Code[35])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Status";
        }
        field(55004; "Status Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(55005; "Status Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55006; "Status Reminder Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(55007; "Generic Name"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(55008; "Forensic Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Forensic Group";
        }
        field(55009; "Storage Condition"; Option)
        {
            OptionMembers = " ",Fridge,"Non-Fridge";
            DataClassification = ToBeClassified;
        }
        field(55010; "Administration Route"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Administration."Administration";
        }
        field(55011; "Other Information"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55012; "Manufacturer"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55013; "Packaging Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55014; "Principal"; code[50])
        {
            DataClassification = ToBeClassified;
            //DX        08 Aug 2021
            TableRelation = Principal.Code;
            //DX        08 Aug 2021
        }
        field(55015; "Exchangeable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55016; "Principal Exchange Policy"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55017; "Purchase Information"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55018; "Customer Information"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55019; "Competitor Information"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55020; "Max Mthly Order Qty"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //DX        17 Jun 2021 : For refreshing of item's date availability and to blank if item has been order and GRN
        field(55021; "Availability Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //DX        17 Jun 2021
        //DX        01 July 2021
        field(55022; "Packing Instructions"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(55023; "Max Holding Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(55024; "Min Holding Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(55025; "CD Type"; Option)
        {
            Caption = 'Controlled Drug Type';
            OptionMembers = " ","CD","Codeine","CNS","Codeine 3.8L";
        }
        field(55026; "POM Item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55027; "Wellaway Item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55028; "Therapeutic Code"; Code[20])
        {
            // Obselete
            DataClassification = ToBeClassified;
            TableRelation = "Therapeutic Group"."No.";
        }
        field(55029; "Therapeutic Pharmacology"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Therapeutic Pharmacology"."No." where("Therapeutic Group No." = field("Therapeutic Code"));
        }
        //DX        01 July 2021
        //DX        08 July 2021
        field(55030; "1st Tier Price Nego."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55031; "2nd Tier Price Nego."; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if Rec."2nd Tier Price Nego." <> 0 then begin
                    if Rec."2nd Tier Price Nego." < Rec."1st Tier Price Nego." then
                        Error('2nd Tier Price Nego percentage has to be higher than 1st Tier. Please check again.');

                end;


            end;
        }
        //DX        08 July 2021
        //DX        21 July 2021
        field(55032; "Logistics Service"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //DX        21 July 2021
        field(55033; "Product Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Branded,Generic;
        }

        // YF 07 Sept 2021 // Merge Son Item Job Queue Categorization Codes
        field(55034; "Warehouse Classification"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(55035; "Item Sales Classification"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        // YF 07 Sept 2021 // Merge Son Item Job Queue Categorization Codes

        field(55036; "Apex Competitor Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(55037; "Pharmazen Competitor Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(55038; "Nex Competitor Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(55039; "Item Commission Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Commission Group".Code;
        }

        field(55040; "Wholesale Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(55041; "Retail Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        // YF 26 Oct 2021
        field(55042; "I9_Qty. on Blanket Sales Order"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Blanket Order"),
                                                                            Type = CONST(Item),
                                                                            "No." = FIELD("No."),
                                                                            "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                            "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                            "Location Code" = FIELD("Location Filter"),
                                                                            "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                            "Variant Code" = FIELD("Variant Filter"),
                                                                            "Shipment Date" = FIELD("Date Filter"),
                                                                            "Unit of Measure Code" = FIELD("Unit of Measure Filter")));
            Caption = 'Qty. on Blanket Sales Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        // YF 26 Ocy 2021

        //RL        29 Dec 2021
        field(55043; "ShortcutDim3Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, ShortcutDim3Code);
            end;
        }
        field(55044; "ShortcutDim4Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, ShortcutDim4Code);
            end;
        }
        field(55045; "ShortcutDim5Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, ShortcutDim5Code);
            end;
        }
        field(55046; "ShortcutDim6Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, ShortcutDim6Code);
            end;
        }
        field(55047; "ShortcutDim7Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, ShortcutDim7Code);
            end;
        }
        field(55048; "ShortcutDim8Code"; Code[20])
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
        field(55049; "Qty. on Transfer Outbound"; Decimal)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            CalcFormula = Sum("Transfer Line"."Outstanding Qty. (Base)" WHERE("Item No." = FIELD("No."),
                                                                            "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                            "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                            "Transfer-from Code" = FIELD("Location Filter"),
                                                                            "Variant Code" = FIELD("Variant Filter"),
                                                                            "Shipment Date" = FIELD("Date Filter"),
                                                                            "Unit of Measure Code" = FIELD("Unit of Measure Filter")));
            Caption = 'Qty. on Transfer Outbound';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(55050; "Qty. on Transfer Inbound"; Decimal)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            CalcFormula = Sum("Transfer Line"."Qty. in Transit (Base)" WHERE("Item No." = FIELD("No."),
                                                                            "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                            "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                            "Transfer-to Code" = FIELD("Location Filter"),
                                                                            "Variant Code" = FIELD("Variant Filter"),
                                                                            "Shipment Date" = FIELD("Date Filter"),
                                                                            "Unit of Measure Code" = FIELD("Unit of Measure Filter")));
            Caption = 'Qty. on Transfer Inbound';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        //DX        19 July 2023
        field(55051; ImageURL; Text[500])
        {
            FieldClass = Normal;
            Caption = 'Image URL';
        }
        //DX        19 July 2023

        //DX        04 Sept 2023
        field(55052; SkipFEFOPicking; Boolean)
        {
            FieldClass = Normal;
            Caption = 'Skip Warehouse FEFO Picking';
        }
        //DX        04 Sept 2023

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
        //DX        04 Sept 2023

    }
    fieldgroups
    {
        //DX        15 Aug 2021 #Issue 101
        addlast(DropDown; "Generic Name", "Item Status")
        {

        }
        //DX        15 Aug 2021

    }

}