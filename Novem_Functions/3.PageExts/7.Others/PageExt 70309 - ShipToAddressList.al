pageextension 70309 ShipToAddressListExt extends "Ship-to Address List"
{
    layout
    {
        addafter(Name)
        {
            field("I9G_Name2"; Rec."Name 2")
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_LicenseStatus; Rec.I9G_LicenseStatus)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
                StyleExpr = StatusStyleExpression;
                ToolTip = 'Specifies the value of the License Status field.';
            }
            field(I9G_CaseDR; Rec.I9G_CaseDR)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_LicenseStartDate; Rec.I9G_LicenseStartDate)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_LicenseEndDate; Rec.I9G_LicenseEndDate)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_DistrictCode; Rec.I9G_DistrictCode)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
            field(I9G_Address3; Rec.I9G_Address3)
            {
                ApplicationArea = All;
                Visible = CustomizedVisible;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        CustomizedVisible := I9G_NovemEventSubscribersCodeUnit.GetCompanyCheck();
        StatusStyleExpression := GetStyleExprForLicenseStatus();
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
}