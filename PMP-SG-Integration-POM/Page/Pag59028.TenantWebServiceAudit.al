
page 59028 "Tenant Web Service Audit"
{
    ApplicationArea = All;
    Caption = 'Tenant Web Service Audit';
    PageType = List;
    SourceTable = "Tenant Web Service";
    UsageCategory = Administration;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Permissions = tabledata "Tenant Web Service" = r,
                  tabledata User = r;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies whether the published object is a Codeunit, Page or Query.';
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the ID of the published object. IDs below 50000 belong to Microsoft.';
                }
                field("Service Name"; Rec."Service Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the endpoint name used in the OData and SOAP URLs.';
                }
                field(Published; Rec.Published)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies whether the endpoint is currently live.';
                }
                field(MicrosoftObject; MicrosoftObject)
                {
                    ApplicationArea = all;
                    Caption = 'Microsoft Object (v29/v30 risk)';
                    ToolTip = 'Specifies that the published object belongs to Microsoft, so exposing it is removed in BC v29 for SOAP and v30 for OData.';
                }
                field(RegisteredAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                    Caption = 'Registered At';
                    ToolTip = 'Specifies when this registration was created. Blank on rows that predate the platform system fields.';
                }
                field(RegisteredBy; RegisteredByName)
                {
                    ApplicationArea = all;
                    Caption = 'Registered By';
                    ToolTip = 'Specifies the user who created this registration. Blank when the creator cannot be resolved to a current user.';
                }
                field(ModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = all;
                    Caption = 'Last Modified At';
                    ToolTip = 'Specifies when this registration was last changed.';
                }
                field(ModifiedBy; ModifiedByName)
                {
                    ApplicationArea = all;
                    Caption = 'Last Modified By';
                    ToolTip = 'Specifies the user who last changed this registration.';
                }
                field(CreatedBy; CreateGuid())
                {
                    ApplicationArea = all;
                    Caption = 'Created Modified';
                    ToolTip = 'Specifies the user who created this registration.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        MicrosoftObject := Rec."Object ID" < 50000;
        RegisteredByName := GetUserName(Rec.SystemCreatedBy);
        ModifiedByName := GetUserName(Rec.SystemModifiedBy);
    end;

    local procedure GetUserName(UserSecurityId: Guid): Text[50]
    var
        UserRec: Record User;
    begin
        if IsNullGuid(UserSecurityId) then
            exit('');
        if UserRec.Get(UserSecurityId) then
            exit(UserRec."User Name");
        exit('');
    end;

    var
        RegisteredByName: Text[50];
        ModifiedByName: Text[50];
        MicrosoftObject: Boolean;
}
