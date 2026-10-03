pageextension 70308 ShipToAddressCardExt extends "Ship-to Address"
{
    layout
    {
        addafter(Name)
        {
            field("I9G_Name2"; Rec."Name 2")
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the additional name associated with the ship-to address.';
            }
            field("I9G_Case DR"; Rec.I9G_CaseDR)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the Case DR field.';
            }
            field(I9G_LicenseStartDate; Rec.I9G_LicenseStartDate)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the License Start Date field.';
            }
            field(I9G_LicenseEndDate; Rec.I9G_LicenseEndDate)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the License End Date field.';
                trigger OnValidate()
                var
                begin
                    CurrPage.Update();
                end;
            }
            field(I9G_LicenseStatus; Rec.I9G_LicenseStatus)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                StyleExpr = StatusStyleExpression;
                ToolTip = 'Specifies the value of the License Status field.';
            }
        }
        addafter("Address 2")
        {
            field(I9G_Address3; Rec.I9G_Address3)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies additional address information.';
            }
            field("I9G_District Code"; Rec.I9G_DistrictCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                ToolTip = 'Specifies the value of the District Code field.';
                Lookup = true;
                LookupPageId = I9G_DistrictList;
            }
        }
        addlast(General)
        {
            field(SystemModifiedByUserName; SystemModifiedByUserName)
            {
                ApplicationArea = All;
                Caption = 'Customer Modified By';
                Visible = CustomizedVisible;
                Editable = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
        StatusStyleExpression := GetStyleExprForLicenseStatus();

        Clear(SystemModifiedByUserName);
        if User.Get(Rec.SystemModifiedBy) then
            SystemModifiedByUserName := User."User Name";
    end;

    trigger OnOpenPage()
    var
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
        StatusStyleExpression := GetStyleExprForLicenseStatus();
    end;

    procedure GetStyleExprForLicenseStatus(): Text[50];
    var
        SalesReceivableSetupRec: Record "Sales & Receivables Setup";
    begin
        if I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck() = true then begin
            SalesReceivableSetupRec.Get();
            SalesReceivableSetupRec.TestField(I9G_CustomerLicenseExpiration);
            if Rec.I9G_LicenseEndDate <> 0D then begin
                if Rec.I9G_LicenseEndDate < WorkDate() then begin
                    exit('Unfavorable');
                end else begin
                    if (Rec.I9G_LicenseEndDate - WorkDate() > SalesReceivableSetupRec.I9G_CustomerLicenseExpiration) then begin
                        exit('Favorable');
                    end else begin
                        exit('Ambiguous');
                    end;
                end;
            end else begin
                exit('Favorable');
            end;
        end;
    end;

    var
        I9G_NovemEventSubscribersCodeUnit: Codeunit I9G_NovemEventSubscribers;
        CustomizedVisible: Boolean;
        StatusStyleExpression: Text[50];
        SystemModifiedByUserName: Code[50];
}