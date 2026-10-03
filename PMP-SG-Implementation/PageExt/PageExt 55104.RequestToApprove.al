pageextension 55104 RequestToApprove extends "Requests to Approve"


//RL         28 Oct 2021
{
    layout
    {
        // Add changes to page layout here
        addafter("Amount (LCY)")
        {
            field("Available Credit Limit (LCY)"; Rec."Available Credit Limit (LCY)")
            {
                ApplicationArea = All;
            }
            field(CreditLimit; CreditLimit)
            {
                Caption = 'Credit Limit';
                ApplicationArea = All;
            }
            field(StatusRemarks; StatusRemarks)
            {
                Caption = 'Status Remarks';
                ApplicationArea = All;
            }
            field(AcctInfo; AcctInfo)
            {
                Caption = 'Account Info';
                ApplicationArea = All;
            }
            field(StatusDate; StatusDate)
            {
                Caption = 'Status Date';
                ApplicationArea = All;
            }
            field(CustStatus; CustStatus)
            {
                Caption = 'Customer Status';
                ApplicationArea = All;
            }
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = All;
            }
            field(PaymentTermsCode; PaymentTermsCode)
            {
                ApplicationArea = All;
                Caption = 'Payment Terms Code';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    local procedure GetCustomerDetails()
    var
        CustRec: Record Customer;
        SHRec: Record "Sales Header";
    begin
        CreditLimit := 0;
        StatusDate := 0D;
        StatusRemarks := '';
        AcctInfo := '';
        CustStatus := '';
        CustRec.Reset();
        SHRec.Reset();
        SHRec.SetRange("No.", rec."Document No.");
        SHRec.SetRange("Document Type", Rec."Document Type");
        if SHRec.FindFirst() then begin
            CustRec.SetRange("No.", SHRec."Bill-to Customer No.");
            if CustRec.FindFirst() then begin
                CreditLimit := CustRec."Credit Limit (LCY)";
                StatusDate := CustRec."Status Date";
                StatusRemarks := CustRec."Status Remarks";
                AcctInfo := CustRec."Acct Information";
                CustStatus := format(CustRec."Customer Status");

            end;

            PaymentTermsCode := SHRec."Payment Terms Code";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        GetCustomerDetails();
    end;

    trigger OnAfterGetRecord()
    begin
        GetCustomerDetails();
    end;

    var
        myInt: Integer;
        CreditLimit: Decimal;
        StatusRemarks: Text[250];
        AcctInfo: Text[500];
        StatusDate: Date;
        CustStatus: Text[20];
        PaymentTermsCode: Code[10];
    //RL         28 Oct 2021
}