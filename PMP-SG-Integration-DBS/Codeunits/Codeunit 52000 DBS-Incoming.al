codeunit 52000 "DBS-Incoming Codeunit"
{

    // YF 19 Nov 2021 
    procedure CreateCRJournal(StagingEntryNo: Integer) // Refactored Version
    var
        SSSetup: Record "Sales & Receivables Setup";
        LineNo: Integer;
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        DBSStagingRec: Record "DBS Incoming";
        LineCRJRec: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        LastLineDocNo: Code[20];
    begin

        SSSetup.Reset;
        SSSetup.Get;

        if Not DBSStagingRec.Get(StagingEntryNo) then
            exit;

        // Pre flight checks 
        if Not ValidateStagingData(StagingEntryNo) then begin
            DBSStagingRec."Process Remark" := GetLastErrorText();
            DBSStagingRec."Has Error" := true;
            DBSStagingRec."Entry Processed" := CurrentDateTime;
            DBSStagingRec.Modify(false);
            exit;
        end;

        // Normal Processing
        GenJnlBatch.Reset;
        GenJnlBatch.SetRange("Journal Template Name", 'CASHRCPT');
        GenJnlBatch.SetRange(Name, SSSetup."Def. DBS CRJ Journal Batch");
        if GenJnlBatch.FindFirst() then begin end;

        LineCRJRec.Reset;
        LineCRJRec.SetRange("Journal Template Name", 'CASHRCPT');
        LineCRJRec.SetRange("Journal Batch Name", SSSetup."Def. DBS CRJ Journal Batch");
        if LineCRJRec.FindLast() then begin
            LineNo := LineCRJRec."Line No." + 10000;
            LastLineDocNo := LineCRJRec."Document No.";
        end
        else
            LineNo := 10000;

        LineCRJRec.Reset;
        LineCRJRec.Init;

        LineCRJRec.Validate("Journal Template Name", 'CASHRCPT');
        LineCRJRec.Validate("Journal Batch Name", SSSetup."Def. DBS CRJ Journal Batch");
        LineCRJRec.Validate("Line No.", lineNo);
        LineCRJRec.Validate("Document Type", LineCRJRec."Document Type"::Payment);

        if DBSStagingRec.txnDate = 0D then
            LineCRJRec.Validate("Posting Date", WorkDate())
        else
            LineCRJRec.Validate("Posting Date", DBSStagingRec.txnDate);

        // Clear(NoSeriesMgt);
        Clear(NoSeries);

        if LineNo = 10000 then begin // initial line
            // LineCRJRec.Validate("Document No.", NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", LineCRJRec."Posting Date"));
            LineCRJRec.Validate("Document No.", NoSeries.PeekNextNo(GenJnlBatch."No. Series", LineCRJRec."Posting Date"));
        end;

        if LineNo > 10000 then begin
            IncrementDocumentNo(GenJnlBatch, LastLineDocNo, LineCRJRec."Posting Date");
            LineCRJRec.Validate("Document No.", LastLineDocNo);
        end;

        LineCRJRec.Validate("External Document No.", DBSStagingRec.txnRefID);
        LineCRJRec.Validate("Account Type", LineCRJRec."Account Type"::Customer);

        // LineCRJRec.Validate("Account No.", GetCustNoByExtDocNo(DBSStagingRec."Customer Ref.")); // YF 21 Jan 2022
        LineCRJRec.Validate("Account No.", GetCustNoByExtDocNo(DBSStagingRec."Customer Ref.", DBSStagingRec."Sender Account No.")); // YF 21 Jan 2022

        LineCRJRec.Validate("Bal. Account Type", LineCRJRec."Bal. Account Type"::"Bank Account");
        LineCRJRec.Validate("Bal. Account No.", SSSetup."Def. DBS Incoming Bank");

        LineCRJRec.Validate("Applies-to Doc. Type", LineCRJRec."Applies-to Doc. Type"::Invoice);

        if GetBCInvNo(DBSStagingRec."Customer Ref.") <> '' then
            LineCRJRec.Validate("Applies-to Doc. No.", GetBCInvNo(DBSStagingRec."Customer Ref."));

        LineCRJRec.Validate("Credit Amount", Abs(DBSStagingRec.txnAmt));

        if LineCRJRec.Insert(true) then begin
            // Re update amounts
            LineCRJRec.Validate(Amount, Abs(DBSStagingRec.txnAmt) * -1);

            if LineCRJRec.Modify() then begin
                DBSStagingRec."Process Remark" := '';
                DBSStagingRec."Has Error" := false;
                DBSStagingRec."Journals Created" := true;
                DBSStagingRec."Journal Doc. No." := LineCRJRec."Document No.";
            end
            else begin
                DBSStagingRec."Process Remark" := 'Modifed journal line (for amount) failed';
                DBSStagingRec."Has Error" := true;
            end;
        end
        else begin
            DBSStagingRec."Process Remark" := 'Insert journal line failed';
            DBSStagingRec."Has Error" := true;
        end;

        DBSStagingRec."Entry Processed" := CurrentDateTime;
        DBSStagingRec.Modify(false);

    end;


    [TryFunction]
    local procedure ValidateStagingData(StagingEntryNo: Integer)
    var
        SSSetup: Record "Sales & Receivables Setup";
        GenJnlBatch: Record "Gen. Journal Batch";
        DBSStagingRec: Record "DBS Incoming";
    begin
        SSSetup.Reset;
        SSSetup.Get;
        SSSetup.TestField("Def. DBS CRJ Journal Batch");
        SSSetup.TestField("Def. DBS Incoming Bank");

        GenJnlBatch.reset;
        GenJnlBatch.SetRange("Journal Template Name", 'CASHRCPT');
        GenJnlBatch.SetRange(Name, SSSetup."Def. DBS CRJ Journal Batch");
        if Not GenJnlBatch.FindFirst() then
            Error('General Journal Batch does not exist');

        if DBSStagingRec.Get(StagingEntryNo) then begin

            // YF 04 Apr 2022
            // Check string length of Customer Ref field (Max limit 20)
            if StrLen(DBSStagingRec."Customer Ref.") > 20 then
                Error('Customer Reference cannot be longer than 20 characters');
            // YF 04 Apr 2022

            // Check Valid Customer
            // if StrLen(GetCustNoByExtDocNo(DBSStagingRec."Customer Ref.")) <= 0 then // YF 21 Jan 2022
            if StrLen(GetCustNoByExtDocNo(DBSStagingRec."Customer Ref.", DBSStagingRec."Sender Account No.")) <= 0 then // YF 21 Jan 2022
                Error('Cannot find Matching Customer Code from Staging');

            // Check Matching Applies to Doc No
            // YF 21 Jan 2022
            if StrLen(GetCustNoByExtDocNo(DBSStagingRec."Customer Ref.")) > 0 then begin
                if StrLen(GetBCInvNo(DBSStagingRec."Customer Ref.")) <= 0 then
                    Error('Cannot find Matching Doc No. from Staging');
            end;
            /*
            if StrLen(GetBCInvNo(DBSStagingRec."Customer Ref.")) <= 0 then
                Error('Cannot find Matching Doc No. from Staging');
            */
            // YF 21 Jan 2022
        end
        else
            Error('DBS Incoming Entry No. Record not found');

    end;

    local procedure IncrementDocumentNo(GenJnlBatch: Record "Gen. Journal Batch"; var LastDocNumber: Code[20]; DateParameter: Date)
    var
        NoSeriesLine: Record "No. Series Line";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesBatch: Codeunit "No. Series - Batch";
    begin
        // if GenJnlBatch."No. Series" <> '' then begin
        //     NoSeriesMgt.SetNoSeriesLineFilter(NoSeriesLine, GenJnlBatch."No. Series", DateParameter);
        //     if NoSeriesLine."Increment-by No." > 1 then
        //         NoSeriesMgt.IncrementNoText(LastDocNumber, NoSeriesLine."Increment-by No.")
        //     else
        //         LastDocNumber := IncStr(LastDocNumber);
        // end else
        //     LastDocNumber := IncStr(LastDocNumber);

        LastDocNumber := NoSeriesBatch.SimulateGetNextNo(GenJnlBatch."No. Series", DateParameter, LastDocNumber);
    end;
    // YF 19 Nov 2021 

    procedure CreateCRJournal(DBSRec: Record "DBS Incoming") // To be retired by refactored version
    var
        CRJRec: Record "Gen. Journal Line";
        LineCRJRec: Record "Gen. Journal Line";
        LastCRJRec: Record "Gen. Journal Line";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        GenJnlBatch: Record "Gen. Journal Batch";
        lineNo: Integer;
        SSSetup: Record "Sales & Receivables Setup";
        lDBSRec: Record "DBS Incoming";
    begin

        SSSetup.reset;
        SSSetup.get;
        SSSetup.TestField("Def. DBS CRJ Journal Batch");
        SSSetup.TestField("Def. DBS Incoming Bank");
        GenJnlBatch.reset;
        GenJnlBatch.SetRange("Journal Template Name", 'CASHRCPT');
        GenJnlBatch.SetRange(Name, SSSetup."Def. DBS CRJ Journal Batch");
        if GenJnlBatch.FindFirst() then begin end;

        LineCRJRec.reset;
        LineCRJRec.SetRange("Journal Template Name", 'CASHRCPT');
        LineCRJRec.SetRange("Journal Batch Name", SSSetup."Def. DBS CRJ Journal Batch");
        if LineCRJRec.FindLast() then
            lineNo := LineCRJRec."Line No." + 10000
        else
            lineNo := 10000;
        CRJRec.Init();
        // CLEAR(NoSeriesMgt);
        Clear(NoSeries);

        CRJRec.Validate("Journal Template Name", 'CASHRCPT');
        CRJRec.Validate("Journal Batch Name", SSSetup."Def. DBS CRJ Journal Batch");
        CRJRec.Validate("Line No.", lineNo);
        CRJRec.Validate("Document Type", CRJRec."Document Type"::Payment);
        if DBSRec.txnDate = 0D then begin
            CRJRec.Validate("Posting Date", WorkDate());
            // CRJRec.Validate("Document No.", NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", WorkDate));
            CRJRec.Validate("Document No.", NoSeries.PeekNextNo(GenJnlBatch."No. Series", WorkDate));
        end else begin
            CRJRec.Validate("Posting Date", DBSRec.txnDate);
            // CRJRec.Validate("Document No.", NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", DBSRec.txnDate));
            CRJRec.Validate("Document No.", NoSeries.PeekNextNo(GenJnlBatch."No. Series", DBSRec.txnDate));
        end;

        CRJRec.validate("External Document No.", DBSRec.txnRefID);
        CRJRec.validate("Account Type", CRJRec."Account Type"::Customer);
        // CRJRec.validate("Account No.", GetCustNoByExtDocNo(DBSRec."Customer Ref.")); // YF 21 Jan 2022
        CRJRec.validate("Account No.", GetCustNoByExtDocNo(DBSRec."Customer Ref.", DBSRec."Sender Account No.")); // YF 21 Jan 2022
        CRJRec.Validate("Bal. Account Type", CRJRec."Bal. Account Type"::"Bank Account");
        CRJRec.validate("Bal. Account No.", SSSetup."Def. DBS Incoming Bank");
        CRJRec.Validate("Applies-to Doc. Type", CRJRec."Applies-to Doc. Type"::Invoice);
        if GetBCInvNo(DBSRec."Customer Ref.") <> '' then
            CRJRec.Validate("Applies-to Doc. No.", GetBCInvNo(DBSRec."Customer Ref."));
        CRJRec.Validate("Credit Amount", Abs(DBSRec.txnAmt));
        CRJRec.Insert(TRUE);

        // YF 02 Nov 2021 // Bug fix
        CRJRec.Validate(Amount, Abs(DBSRec.txnAmt) * -1);
        CRJRec.Modify();
        // YF 02 Nov 2021 // Bug fix

        lDBSRec.reset;
        lDBSRec.SetRange("Entry No.", DBSRec."Entry No.");
        if lDBSRec.FindFirst() then begin
            lDBSRec."Journals Created" := true;
            lDBSRec."Journal Doc. No." := CRJRec."Document No.";
            lDBSRec.Modify(TRUE);

        end;

    end;

    local procedure GetCustomerCodeByBank(BankAcct: Code[50]): Code[20] // YF 02 Nov 2021 // Bug fix
    var
        CustBankRec: Record "Customer Bank Account";
    begin
        CustBankRec.reset;
        CustBankRec.SetRange("Bank Account No.", BankAcct);
        if CustBankRec.FindFirst() then
            exit(CustBankRec."Customer No.")
        else
            exit('');
    end;

    local procedure GetBCInvNo(ExtDoc: Code[35]): Code[20] // YF 02 Nov 2021 // Bug fix
    var
        CLERec: Record "Cust. Ledger Entry";
    begin
        CLERec.reset;
        // CLERec.SetFilter("External Document No.", ExtDoc); // YF 02 Nov 2021 // Bug fix
        CLERec.SetFilter("Document No.", ExtDoc); // YF 02 Nov 2021 // Bug fix
        CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice);
        if CLERec.FindFirst() then
            exit(CLERec."Document No.")
        else
            exit('');
    end;

    local procedure GetCustNoByExtDocNo(ExtDoc: Code[35]): Code[20]
    var
        CLERec: Record "Cust. Ledger Entry";
    begin
        CLERec.reset;
        // CLERec.SetFilter("External Document No.", ExtDoc); // YF 02 Nov 2021 // Bug fix
        CLERec.SetFilter("Document No.", ExtDoc); // YF 02 Nov 2021 // Bug fix
        CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice);
        if CLERec.FindFirst() then
            exit(CLERec."Customer No.")
        else
            exit('');
    end;

    // YF 21 Jan 2022
    local procedure GetCustNoByExtDocNo(ExtDoc: Code[35]; SenderAcctNo: Text[30]): Code[20]
    var
        CLERec: Record "Cust. Ledger Entry";
        CustBankAcct: Record "Customer Bank Account";
    begin
        // Find Customer No. based on Customer Reference
        CLERec.Reset;
        CLERec.SetFilter("Document No.", ExtDoc);
        CLERec.SetRange("Document Type", CLERec."Document Type"::Invoice);
        if CLERec.FindFirst() then
            exit(CLERec."Customer No.")
        else begin
            // If cannot find, try using sender account no.
            CustBankAcct.Reset;
            CustBankAcct.SetRange("Bank Account No.", SenderAcctNo);
            if CustBankAcct.FindFirst() then
                exit(CustBankAcct."Customer No.");
        end;

        exit('');
    end;
    // YF 21 Jan 2022

}