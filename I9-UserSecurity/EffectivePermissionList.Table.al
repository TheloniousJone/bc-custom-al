table 59100 EffectivePermissionList
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; LineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(2; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            TableRelation = User."User Security ID";
        }
        field(3; "Role ID"; Code[20])
        {
            Caption = 'Role ID';
            TableRelation = "Aggregate Permission Set"."Role ID";
        }
        field(4; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company.Name;
        }
        field(5; "User Name"; Code[50])
        {
            Caption = 'User Name';
        }
        field(6; "Role Name"; Text[30])
        {
            Caption = 'Role Name';
        }
        field(7; "App Name"; Text[250])
        {
            Caption = 'App Name';
        }
        field(8; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = "Table Data", "Table", , "Report", , "Codeunit", "XMLport", "MenuSuite", "Page", "Query", "System", , , , , , , , , ;
            OptionCaption = 'Table Data,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,,,,,,,,,';
        }
        field(9; "Object ID"; Integer)
        {
            Caption = 'Object ID';
        }
        field(10; "Object Name"; Text[249])
        {
            Caption = 'Object Name';
        }
        field(11; "Read Permission"; Option)
        {
            Caption = 'Read Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ", Yes, Indirect;
        }
        field(12; "Insert Permission"; Option)
        {
            Caption = 'Insert Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ", Yes, Indirect;
        }
        field(13; "Modify Permission"; Option)
        {
            Caption = 'Modify Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ", Yes, Indirect;
        }
        field(14; "Delete Permission"; Option)
        {
            Caption = 'Delete Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ", Yes, Indirect;
        }
        field(15; "Execute Permission"; Option)
        {
            Caption = 'Execute Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ", Yes, Indirect;
        }
    }
    keys
    {
        key(PK; LineNo)
        {
            Clustered = true;
        }
    }
}
