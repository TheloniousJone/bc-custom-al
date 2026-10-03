tableextension 55063 FAExt extends "Fixed Asset"
{
    fields
    {
        //RL        29 Dec 2021
        field(55001; "ShortcutDim3Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, ShortcutDim3Code);
            end;
        }
        field(55002; "ShortcutDim4Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, ShortcutDim4Code);
            end;
        }
        field(55003; "ShortcutDim5Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, ShortcutDim5Code);
            end;
        }
        field(55004; "ShortcutDim6Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, ShortcutDim6Code);
            end;
        }
        field(55005; "ShortcutDim7Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, ShortcutDim7Code);
            end;
        }
        field(55006; "ShortcutDim8Code"; Code[20])
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
    }

    fieldgroups
    {

    }

}