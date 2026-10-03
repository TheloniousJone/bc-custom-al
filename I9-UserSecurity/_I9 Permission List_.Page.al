page 59100 "I9 Permission List"
{
    ApplicationArea = All;
    Caption = 'User Effective Permission List';
    PageType = List;
    SourceTable = EffectivePermissionList;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User Security ID"; Rec."User Security ID")
                {
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                }
                field("App Name"; Rec."App Name")
                {
                    ApplicationArea = All;
                }
                field("Role ID"; Rec."Role ID")
                {
                    ApplicationArea = All;
                }
                field("Role Name"; Rec."Role Name")
                {
                    ApplicationArea = All;
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                }
                field("Read Permission"; Rec."Read Permission")
                {
                    ApplicationArea = All;
                }
                field("Modify Permission"; Rec."Modify Permission")
                {
                    ApplicationArea = All;
                }
                field("Insert Permission"; Rec."Insert Permission")
                {
                    ApplicationArea = All;
                }
                field("Execute Permission"; Rec."Execute Permission")
                {
                    ApplicationArea = All;
                }
                field("Delete Permission"; Rec."Delete Permission")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        AccessControl: Record "Access Control";
        RecPermission: Record Permission;
        TenantPermission: Record "Tenant Permission";
        MetaDataPermission: Record "Metadata Permission";
        ExpandedPermission: Record "Expanded Permission";
    begin
        AccessControl.Reset();
        //AccessControl.SetRange("User Name", 'OPS.BERNARD');
        AccessControl.SetAutoCalcFields("Role Name", "User Name");
        Rec.LineNo:=0;
        if AccessControl.FindSet()then repeat RecPermission.Reset();
                RecPermission.SetRange("Role ID", AccessControl."Role ID");
                RecPermission.SetAutoCalcFields("Object Name");
                if RecPermission.FindSet()then repeat Rec.LineNo:=Rec.LineNo + 1;
                        Rec.Init();
                        Rec."User Security ID":=AccessControl."User Security ID";
                        Rec."Role ID":=AccessControl."Role ID";
                        Rec."Role Name":=AccessControl."Role Name";
                        Rec."Company Name":=AccessControl."Company Name";
                        Rec."User Name":=AccessControl."User Name";
                        Rec."App Name":=AccessControl."App Name";
                        Rec."Object Type":=RecPermission."Object Type";
                        Rec."Object ID":=RecPermission."Object ID";
                        Rec."Object Name":=RecPermission."Object Name";
                        Rec."Insert Permission":=RecPermission."Insert Permission";
                        Rec."Modify Permission":=RecPermission."Modify Permission";
                        Rec."Execute Permission":=RecPermission."Execute Permission";
                        Rec."Delete Permission":=RecPermission."Delete Permission";
                        Rec."Read Permission":=RecPermission."Read Permission";
                        Rec.Insert();
                    until RecPermission.Next() = 0;
                TenantPermission.Reset();
                TenantPermission.SetRange("Role ID", AccessControl."Role ID");
                TenantPermission.SetAutoCalcFields("Object Name");
                if TenantPermission.FindSet()then repeat Rec.LineNo:=Rec.LineNo + 1;
                        Rec.Init();
                        Rec."User Security ID":=AccessControl."User Security ID";
                        Rec."Role ID":=AccessControl."Role ID";
                        Rec."Role Name":=AccessControl."Role Name";
                        Rec."Company Name":=AccessControl."Company Name";
                        Rec."User Name":=AccessControl."User Name";
                        Rec."App Name":=AccessControl."App Name";
                        Rec."Object Type":=TenantPermission."Object Type";
                        Rec."Object ID":=TenantPermission."Object ID";
                        Rec."Object Name":=TenantPermission."Object Name";
                        Rec."Insert Permission":=TenantPermission."Insert Permission";
                        Rec."Modify Permission":=TenantPermission."Modify Permission";
                        Rec."Execute Permission":=TenantPermission."Execute Permission";
                        Rec."Delete Permission":=TenantPermission."Delete Permission";
                        Rec."Read Permission":=TenantPermission."Read Permission";
                        Rec.Insert();
                    until TenantPermission.Next() = 0;
                MetaDataPermission.Reset();
                MetaDataPermission.SetRange("Role ID", AccessControl."Role ID");
                MetaDataPermission.SetAutoCalcFields("Object Name");
                if MetaDataPermission.FindSet()then repeat Rec.LineNo:=Rec.LineNo + 1;
                        Rec.Init();
                        Rec."User Security ID":=AccessControl."User Security ID";
                        Rec."Role ID":=AccessControl."Role ID";
                        Rec."Role Name":=AccessControl."Role Name";
                        Rec."Company Name":=AccessControl."Company Name";
                        Rec."User Name":=AccessControl."User Name";
                        Rec."App Name":=AccessControl."App Name";
                        Rec."Object Type":=MetaDataPermission."Object Type";
                        Rec."Object ID":=MetaDataPermission."Object ID";
                        Rec."Object Name":=MetaDataPermission."Object Name";
                        Rec."Insert Permission":=MetaDataPermission."Insert Permission";
                        Rec."Modify Permission":=MetaDataPermission."Modify Permission";
                        Rec."Execute Permission":=MetaDataPermission."Execute Permission";
                        Rec."Delete Permission":=MetaDataPermission."Delete Permission";
                        Rec."Read Permission":=MetaDataPermission."Read Permission";
                        Rec.Insert();
                    until MetaDataPermission.Next() = 0;
                ExpandedPermission.Reset();
                ExpandedPermission.SetRange("Role ID", AccessControl."Role ID");
                ExpandedPermission.SetAutoCalcFields("Object Name");
                if ExpandedPermission.FindSet()then repeat Rec.LineNo:=Rec.LineNo + 1;
                        Rec.Init();
                        Rec."User Security ID":=AccessControl."User Security ID";
                        Rec."Role ID":=AccessControl."Role ID";
                        Rec."Role Name":=AccessControl."Role Name";
                        Rec."Company Name":=AccessControl."Company Name";
                        Rec."User Name":=AccessControl."User Name";
                        Rec."App Name":=AccessControl."App Name";
                        Rec."Object Type":=ExpandedPermission."Object Type";
                        Rec."Object ID":=ExpandedPermission."Object ID";
                        Rec."Object Name":=ExpandedPermission."Object Name";
                        Rec."Insert Permission":=ExpandedPermission."Insert Permission";
                        Rec."Modify Permission":=ExpandedPermission."Modify Permission";
                        Rec."Execute Permission":=ExpandedPermission."Execute Permission";
                        Rec."Delete Permission":=ExpandedPermission."Delete Permission";
                        Rec."Read Permission":=ExpandedPermission."Read Permission";
                        Rec.Insert();
                    until ExpandedPermission.Next() = 0;
            until AccessControl.Next() = 0;
    end;
}
