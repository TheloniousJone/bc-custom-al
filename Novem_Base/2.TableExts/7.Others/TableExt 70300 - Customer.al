tableextension 70300 CustomerTableExt extends Customer
{
    fields
    {
        field(70000; "I9G_Adddress3"; Text[250])
        {
            Caption = 'Address 3';
        }
        field(70004; "I9G_CustomerCreatedAt"; Date)
        {
            Caption = 'Customer Created At';
            Editable = false;
        }
        field(70005; "I9G_CustomerRemarks"; Text[300])
        {
            Caption = 'Remarks';
        }
        field(70006; "I9G_ContactDetail"; Text[150])
        {
            Caption = 'Purchaser Contact';
        }
        field(70007; "I9G_MailingAddress"; Text[100])
        {
            Caption = 'Mailing Address';
        }
        field(70008; "I9G_MailingAddress2"; Text[100])
        {
            Caption = 'Mailing Address 2';
        }
        field(70009; "I9G_MailingAddress3"; Text[100])
        {
            Caption = 'Mailing Address 3';
        }
        field(70010; "I9G_UseForSOA"; Boolean)
        {
            Caption = 'Use For SOA';
        }
        field(70011; "I9G_FinanceDetail"; Text[150])
        {
            Caption = 'Finance Contact';
        }
        field(70012; "I9G_MailingClinicName"; Text[200])
        {
            Caption = 'Clinic Name';
        }
        field(70013; "I9G_MailingAttnTo"; Text[200])
        {
            Caption = 'Attn. To';
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            var
                CompanyInformationRec: Record "Company Information";
            begin
                CompanyInformationRec.Get();
                if CompanyInformationRec.I9G_Novem = true then begin
                    I9G_CustomerCreatedAt := WorkDate();
                end;
            end;
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Balance Due") { }
    }

    trigger OnAfterInsert()
    var
        CompanyInformationRec: Record "Company Information";
        DimensionManagement: Codeunit DimensionManagement;
    begin
        CompanyInformationRec.Get();
        if CompanyInformationRec.I9G_Novem = true then begin
            Validate(ShortcutDim6Code, 'SINGAPORE');
        end;
    end;

    var
        PostCode: Record "Post Code";
}