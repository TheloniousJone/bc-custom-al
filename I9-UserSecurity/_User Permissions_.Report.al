report 59100 "User Permissions"
{
    ApplicationArea = All;
    Caption = 'User Permissions';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayouts/User Permissions List.rdl';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(EffectivePermissionList; EffectivePermissionList)
        {
            column(UserName; "User Name")
            {
            }
            column(UserSecurityID; "User Security ID")
            {
            }
            column(AppName; "App Name")
            {
            }
            column(CompanyName; "Company Name")
            {
            }
            column(DeletePermission; "Delete Permission")
            {
            }
            column(ExecutePermission; "Execute Permission")
            {
            }
            column(InsertPermission; "Insert Permission")
            {
            }
            column(LineNo; LineNo)
            {
            }
            column(ModifyPermission; "Modify Permission")
            {
            }
            column(ObjectID; "Object ID")
            {
            }
            column(ObjectName; "Object Name")
            {
            }
            column(ObjectType; "Object Type")
            {
            }
            column(ReadPermission; "Read Permission")
            {
            }
            column(RoleID; "Role ID")
            {
            }
            column(RoleName; "Role Name")
            {
            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
                AccessControl: Record "Access Control";
                RecPermission: Record Permission;
                TenantPermission: Record "Tenant Permission";
                MetaDataPermission: Record "Metadata Permission";
                ExpandedPermission: Record "Expanded Permission";
            begin
                AccessControl.Reset();
                //AccessControl.SetRange("User Name", 'OPS.BERNARD');
                AccessControl.SetAutoCalcFields("Role Name", "User Name");
                if NOT(IsNullGuid(UserList))then begin
                    AccessControl.SetRange("User Security ID", UserList);
                end;
                EffectivePermissionList.LineNo:=0;
                if AccessControl.FindSet()then repeat RecPermission.Reset();
                        RecPermission.SetRange("Role ID", AccessControl."Role ID");
                        if tableId <> 0 then begin
                            RecPermission.SetRange("Object Type", RecPermission."Object Type"::"Table Data");
                            RecPermission.SetFilter("Object ID", '%1|%2', 0, tableId);
                        end;
                        RecPermission.SetAutoCalcFields("Object Name");
                        if RecPermission.FindSet()then repeat EffectivePermissionList.LineNo:=EffectivePermissionList.LineNo + 1;
                                EffectivePermissionList.Init();
                                EffectivePermissionList."User Security ID":=AccessControl."User Security ID";
                                EffectivePermissionList."Role ID":=AccessControl."Role ID";
                                EffectivePermissionList."Role Name":=AccessControl."Role Name";
                                EffectivePermissionList."Company Name":=AccessControl."Company Name";
                                EffectivePermissionList."User Name":=AccessControl."User Name";
                                EffectivePermissionList."App Name":=AccessControl."App Name";
                                EffectivePermissionList."Object Type":=RecPermission."Object Type";
                                EffectivePermissionList."Object ID":=RecPermission."Object ID";
                                EffectivePermissionList."Object Name":=RecPermission."Object Name";
                                EffectivePermissionList."Insert Permission":=RecPermission."Insert Permission";
                                EffectivePermissionList."Modify Permission":=RecPermission."Modify Permission";
                                EffectivePermissionList."Execute Permission":=RecPermission."Execute Permission";
                                EffectivePermissionList."Delete Permission":=RecPermission."Delete Permission";
                                EffectivePermissionList."Read Permission":=RecPermission."Read Permission";
                                EffectivePermissionList.Insert();
                            until RecPermission.Next() = 0;
                        TenantPermission.Reset();
                        TenantPermission.SetRange("Role ID", AccessControl."Role ID");
                        TenantPermission.SetAutoCalcFields("Object Name");
                        if tableId <> 0 then begin
                            TenantPermission.SetRange("Object Type", TenantPermission."Object Type"::"Table Data");
                            TenantPermission.SetRange("Object ID", tableId);
                            TenantPermission.SetFilter("Object ID", '%1|%2', 0, tableId);
                        end;
                        if TenantPermission.FindSet()then repeat EffectivePermissionList.LineNo:=EffectivePermissionList.LineNo + 1;
                                EffectivePermissionList.Init();
                                EffectivePermissionList."User Security ID":=AccessControl."User Security ID";
                                EffectivePermissionList."Role ID":=AccessControl."Role ID";
                                EffectivePermissionList."Role Name":=AccessControl."Role Name";
                                EffectivePermissionList."Company Name":=AccessControl."Company Name";
                                EffectivePermissionList."User Name":=AccessControl."User Name";
                                EffectivePermissionList."App Name":=AccessControl."App Name";
                                EffectivePermissionList."Object Type":=TenantPermission."Object Type";
                                EffectivePermissionList."Object ID":=TenantPermission."Object ID";
                                EffectivePermissionList."Object Name":=TenantPermission."Object Name";
                                EffectivePermissionList."Insert Permission":=TenantPermission."Insert Permission";
                                EffectivePermissionList."Modify Permission":=TenantPermission."Modify Permission";
                                EffectivePermissionList."Execute Permission":=TenantPermission."Execute Permission";
                                EffectivePermissionList."Delete Permission":=TenantPermission."Delete Permission";
                                EffectivePermissionList."Read Permission":=TenantPermission."Read Permission";
                                EffectivePermissionList.Insert();
                            until TenantPermission.Next() = 0;
                        MetaDataPermission.Reset();
                        MetaDataPermission.SetRange("Role ID", AccessControl."Role ID");
                        MetaDataPermission.SetAutoCalcFields("Object Name");
                        if tableId <> 0 then begin
                            MetaDataPermission.SetRange("Object Type", MetaDataPermission."Object Type"::"Table Data");
                            MetaDataPermission.SetRange("Object ID", tableId);
                            MetaDataPermission.SetFilter("Object ID", '%1|%2', 0, tableId);
                        end;
                        if MetaDataPermission.FindSet()then repeat EffectivePermissionList.LineNo:=EffectivePermissionList.LineNo + 1;
                                EffectivePermissionList.Init();
                                EffectivePermissionList."User Security ID":=AccessControl."User Security ID";
                                EffectivePermissionList."Role ID":=AccessControl."Role ID";
                                EffectivePermissionList."Role Name":=AccessControl."Role Name";
                                EffectivePermissionList."Company Name":=AccessControl."Company Name";
                                EffectivePermissionList."User Name":=AccessControl."User Name";
                                EffectivePermissionList."App Name":=AccessControl."App Name";
                                EffectivePermissionList."Object Type":=MetaDataPermission."Object Type";
                                EffectivePermissionList."Object ID":=MetaDataPermission."Object ID";
                                EffectivePermissionList."Object Name":=MetaDataPermission."Object Name";
                                EffectivePermissionList."Insert Permission":=MetaDataPermission."Insert Permission";
                                EffectivePermissionList."Modify Permission":=MetaDataPermission."Modify Permission";
                                EffectivePermissionList."Execute Permission":=MetaDataPermission."Execute Permission";
                                EffectivePermissionList."Delete Permission":=MetaDataPermission."Delete Permission";
                                EffectivePermissionList."Read Permission":=MetaDataPermission."Read Permission";
                                EffectivePermissionList.Insert();
                            until MetaDataPermission.Next() = 0;
                        ExpandedPermission.Reset();
                        ExpandedPermission.SetRange("Role ID", AccessControl."Role ID");
                        ExpandedPermission.SetAutoCalcFields("Object Name");
                        if tableId <> 0 then begin
                            ExpandedPermission.SetRange("Object Type", ExpandedPermission."Object Type"::"Table Data");
                            ExpandedPermission.SetRange("Object ID", tableId);
                            ExpandedPermission.SetFilter("Object ID", '%1|%2', 0, tableId);
                        end;
                        if ExpandedPermission.FindSet()then repeat EffectivePermissionList.LineNo:=EffectivePermissionList.LineNo + 1;
                                EffectivePermissionList.Init();
                                EffectivePermissionList."User Security ID":=AccessControl."User Security ID";
                                EffectivePermissionList."Role ID":=AccessControl."Role ID";
                                EffectivePermissionList."Role Name":=AccessControl."Role Name";
                                EffectivePermissionList."Company Name":=AccessControl."Company Name";
                                EffectivePermissionList."User Name":=AccessControl."User Name";
                                EffectivePermissionList."App Name":=AccessControl."App Name";
                                EffectivePermissionList."Object Type":=ExpandedPermission."Object Type";
                                EffectivePermissionList."Object ID":=ExpandedPermission."Object ID";
                                EffectivePermissionList."Object Name":=ExpandedPermission."Object Name";
                                EffectivePermissionList."Insert Permission":=ExpandedPermission."Insert Permission";
                                EffectivePermissionList."Modify Permission":=ExpandedPermission."Modify Permission";
                                EffectivePermissionList."Execute Permission":=ExpandedPermission."Execute Permission";
                                EffectivePermissionList."Delete Permission":=ExpandedPermission."Delete Permission";
                                EffectivePermissionList."Read Permission":=ExpandedPermission."Read Permission";
                                EffectivePermissionList.Insert();
                            until ExpandedPermission.Next() = 0;
                    until AccessControl.Next() = 0;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(UserList; UserList)
                    {
                        ApplicationArea = all;
                        TableRelation = User."User Security ID";
                        Caption = 'Select to filter specific user';
                    }
                    field(tableId; tableId)
                    {
                        ApplicationArea = all;
                        Caption = 'Enter specific table ID if required';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var UserList: Guid;
    UserRec: Record user;
    tableId: Integer;
}
