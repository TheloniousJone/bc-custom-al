codeunit 52001 "DBS Host to Host Codeunit"
{

    procedure AddToStaging(var PaytJournal: Record "Gen. Journal Line")
    var
        NewStagingRec: Record "DBS Host2Host Staging";
        ProcessedCounter: Integer;
        CompanyInfoRec: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        BankAcctRec: Record "Bank Account";
        BatchNumber: Integer;
        CheckStagingRec: Record "DBS Host2Host Staging";
        VendorRec: Record Vendor;

        // Summary Fields
        HeaderRecordType: Text;
        HeaderFileCreationDateText: Text;
        HeaderOrgID: Text;
        HeaderSenderName: Text;

        DetailRecordType: Text;

        TrailerRecordType: Text;
        TotalNoOfTransactions: Integer;
        TotalTransactionAmount: Decimal;

        ValidatedState: Boolean;

        VendorName: Text[150]; // YF 10 Mar 2022
    // Summary Fields
    begin
        ProcessedCounter := 0;
        CompanyInfoRec.Get;
        GLSetup.Get;
        BatchNumber := 0;

        // Filter off valid product type
        PaytJournal.SetFilter("DBS Product Type", '%1|%2|%3|%4|%5|%6', 'ACT', 'TT', 'MEP', 'GPP', 'BPY', 'SAL');

        // Init and Set Summary Fields
        HeaderRecordType := 'HEADER';
        HeaderFileCreationDateText := IntToTextLeadingZeroes(Date2DMY(Today, 1), 2) + IntToTextLeadingZeroes(Date2DMY(Today, 2), 2) + Format(Date2DMY(Today, 3));
        HeaderOrgID := CompanyInfoRec."Organization ID for DBS";
        HeaderSenderName := CopyStr(UpperCase(CompanyInfoRec."Sender Name for DBS"), 1, 35); //RL 25 Mar 2022
        DetailRecordType := 'PAYMENT';
        TrailerRecordType := 'TRAILER';
        TotalNoOfTransactions := PaytJournal.Count;
        PaytJournal.CalcSums(Amount);
        TotalTransactionAmount := PaytJournal.Amount;
        ValidatedState := true;

        CheckStagingRec.Reset;
        if CheckStagingRec.FindLast() then
            if Not Evaluate(BatchNumber, CheckStagingRec."Batch ID") then
                BatchNumber := ProcessBatchNumber(BatchNumber, '');

        // loop thru selected journal for processing
        if PaytJournal.FindSet() then
            repeat
                // create new staging records go !
                NewStagingRec.Init();
                NewStagingRec."Entry No." := 0;
                //RL    25 March 22 - Start - insert line to get entry no. first
                // NewStagingRec.Insert(true);
                if NewStagingRec.Insert(true) then begin
                    //RL    25 March 22 - End
                    NewStagingRec."Header Record Type" := HeaderRecordType;
                    NewStagingRec."Process Remarks" := '';

                    if StrLen(HeaderFileCreationDateText) <> 8 then begin
                        NewStagingRec."Process Remarks" += ' | Header File Creation Date Issue | '; // Handle Error
                        ValidatedState := false;
                        NewStagingRec."Header File Creation Date" := HeaderFileCreationDateText;
                    end
                    else
                        NewStagingRec."Header File Creation Date" := HeaderFileCreationDateText;

                    if HeaderOrgID = '' then begin
                        NewStagingRec."Process Remarks" += ' | Header Org ID Issue | '; // Handle Error
                        ValidatedState := false;
                        NewStagingRec."Header Org ID" := HeaderOrgID;
                    end
                    else
                        NewStagingRec."Header Org ID" := HeaderOrgID;

                    if HeaderSenderName = '' then begin
                        NewStagingRec."Process Remarks" += ' | Header Sender Name Issue | '; // Handle Error
                        ValidatedState := false;
                        NewStagingRec."Header Sender Name" := HeaderSenderName;
                    end
                    else
                        NewStagingRec."Header Sender Name" := HeaderSenderName;

                    NewStagingRec."Detail Record Type" := DetailRecordType;
                    NewStagingRec."Product Type" := PaytJournal."DBS Product Type";
                    NewStagingRec."Orig. Account No." := '';
                    NewStagingRec."Orig. Account Currency" := '';

                    if (PaytJournal."Bal. Account Type" = PaytJournal."Bal. Account Type"::"Bank Account") And
                        (PaytJournal."Bal. Account No." <> '') then begin
                        if BankAcctRec.Get(PaytJournal."Bal. Account No.") then begin
                            // NewStagingRec."Orig. Account No." := RemoveDashesAndSpaces(BankAcctRec."Bank Account No."); // YF 21 Jan 2022
                            NewStagingRec."Orig. Account No." := RemoveDashesAndSpaces(BankAcctRec."H2H Export Account No."); // YF 21 Jan 2022
                            if BankAcctRec."Currency Code" = '' then
                                NewStagingRec."Orig. Account Currency" := GLSetup."LCY Code"
                            else
                                NewStagingRec."Orig. Account Currency" := BankAcctRec."Currency Code";
                        end
                        else begin
                            NewStagingRec."Process Remarks" += ' | Bal. Bank Acct not found | '; // Handle Error
                            ValidatedState := false;
                        end;
                    end
                    else begin
                        NewStagingRec."Process Remarks" += ' | Bal. Bank Acct not entered in journal | '; // Handle Error
                        ValidatedState := false;
                    end;
                    //RL    03 Mar 2022 - Start
                    // NewStagingRec."Cust. Batch Reference" := PaytJournal."Journal Batch Name";
                    if PaytJournal."DBS Product Type" in ['ACT', 'TT', 'MEP', 'GPP'] then
                        // NewStagingRec."Cust. Batch Reference" := CopyStr(PaytJournal."Account No.", 1, 16); //RL    02 Mar 2022
                        NewStagingRec."Cust. Batch Reference" := CopyStr(CompanyName + '-' + format(NewStagingRec."Entry No."), 1, 16); //RL   25 Mar 2022
                    if PaytJournal."DBS Product Type" in ['BPY', 'SAL'] then
                        NewStagingRec."Cust. Batch Reference" := PaytJournal."Journal Batch Name";
                    //RL    03 Mar 2022 - End

                    if PaytJournal."Currency Code" = '' then
                        NewStagingRec."Payment Currency" := GLSetup."LCY Code"
                    else
                        NewStagingRec."Payment Currency" := PaytJournal."Currency Code";

                    NewStagingRec."Base Batch ID" := IntToTextLeadingZeroes(BatchNumber, 5);
                    NewStagingRec."Batch ID" := IntToTextLeadingZeroes(ProcessBatchNumber(BatchNumber, PaytJournal."DBS Product Type"), 5);
                    NewStagingRec."Payment Date" := IntToTextLeadingZeroes(Date2DMY(PaytJournal."Posting Date", 1), 2) + IntToTextLeadingZeroes(Date2DMY(PaytJournal."Posting Date", 2), 2) + Format(Date2DMY(PaytJournal."Posting Date", 3));

                    if (PaytJournal."DBS Product Type" = 'TT') Or (PaytJournal."DBS Product Type" = 'MEP') then
                        NewStagingRec."Bank Charges" := 'SHA'
                    else
                        NewStagingRec."Bank Charges" := '';

                    NewStagingRec."Debit Acct for Bank Charges" := '';

                    NewStagingRec."Receiving Party Name" := '';
                    NewStagingRec."Recv Party Address 1" := '';
                    NewStagingRec."Recv Party Address 2" := '';
                    NewStagingRec."Recv Party Address 3" := '';
                    NewStagingRec."Recv Acct No. IBAN" := '';
                    NewStagingRec."Bene Bank SWIFT BIC" := '';

                    VendorName := ''; // YF 10 Mar 2022

                    if (PaytJournal."Account Type" = PaytJournal."Account Type"::Vendor) And (PaytJournal."Account No." <> '') then begin
                        if VendorRec.Get(PaytJournal."Account No.") then begin

                            // YF 10 Mar 2022
                            VendorName := VendorRec.Name;
                            VendorName := ReplaceString(VendorName, '&', 'and');
                            NewStagingRec."Receiving Party Name" := CopyStr(VendorName, 1, 35);
                            // NewStagingRec."Receiving Party Name" := CopyStr(VendorRec.Name, 1, 35);
                            // YF 10 Mar 2022

                            //RL    03 Mar 2022 - Start
                            if (StrLen(VendorRec.Name) > 35) and (PaytJournal."DBS Product Type" = 'TT') then
                                NewStagingRec."Recv Party Address 1" := CopyStr(VendorRec.Name, 36, 70);
                            if (StrLen(VendorRec.Name) <= 35) and (PaytJournal."DBS Product Type" = 'TT') then
                                NewStagingRec."Recv Party Address 1" := CopyStr(VendorRec.Address, 1, 35);
                            // if (PaytJournal."DBS Product Type" = 'TT') Or (PaytJournal."DBS Product Type" = 'MEP') Or (PaytJournal."DBS Product Type" = 'GPP') then
                            if (PaytJournal."DBS Product Type" = 'MEP') Or (PaytJournal."DBS Product Type" = 'GPP') then
                                //RL    03 Mar 2022 - End

                                NewStagingRec."Recv Party Address 1" := CopyStr(VendorRec.Address, 1, 35); // TT MEP GPP

                            NewStagingRec."Recv Acct No. IBAN" := RetrieveVendBankInfo('ACCOUNT', PaytJournal."Account No.", PaytJournal."Recipient Bank Account");
                            if NewStagingRec."Recv Acct No. IBAN" = '' then begin
                                NewStagingRec."Process Remarks" += ' | Vendor Bank Account No Issue | '; // Handle Error
                                ValidatedState := false;
                            end;

                            if PaytJournal."DBS Product Type" <> 'ACT' then // assuming valid product type filtered beforehand
                                begin
                                NewStagingRec."Bene Bank SWIFT BIC" := RetrieveVendBankInfo('SWIFT', PaytJournal."Account No.", PaytJournal."Recipient Bank Account");
                                if NewStagingRec."Bene Bank SWIFT BIC" = '' then begin
                                    NewStagingRec."Process Remarks" += ' | Vendor Bank Account SWIFT Issue | '; // Handle Error
                                    ValidatedState := false;
                                end;
                            end;
                        end
                        else begin
                            NewStagingRec."Process Remarks" += ' | Vendor not found | '; // Handle Error
                            ValidatedState := false;
                        end;
                    end
                    else begin
                        NewStagingRec."Process Remarks" += ' | No Vendor in Journal | '; // Handle Error
                        ValidatedState := false;
                    end;

                    NewStagingRec."Payable To" := '';
                    NewStagingRec."Country Specific" := '';
                    NewStagingRec."Receiving Bank Code" := '';
                    NewStagingRec."Receiving Branch Code" := '';
                    NewStagingRec."Clearing Code" := '';
                    NewStagingRec."Bene Bank Name" := '';
                    NewStagingRec."Bene Bank Address" := '';
                    NewStagingRec."Bene Bank Country" := '';
                    NewStagingRec."Routing Code" := '';
                    NewStagingRec."Intermed. Bank SWIFT BIC" := '';

                    if (PaytJournal."DBS Product Type" = 'ACT') Or (PaytJournal."DBS Product Type" = 'TT') Or (PaytJournal."DBS Product Type" = 'MEP') then
                        NewStagingRec."Amount Currency" := '0'
                    else
                        NewStagingRec."Amount Currency" := '';

                    NewStagingRec."Amount Value" := PaytJournal.Amount;
                    // NewStagingRec."Amount Text" := Format(PaytJournal.Amount, 0, '<Decimals,3>');
                    NewStagingRec."Amount Text" := Format(PaytJournal.Amount, 0, '<Precision,2><sign><Integer><Decimals,3>');

                    NewStagingRec."FX Contract Reference 1" := '';
                    NewStagingRec."Amount to Use for FX 1" := 0;
                    NewStagingRec."Amt to Use for FX 1 Text" := '';
                    NewStagingRec."FX Contract Reference 2" := '';
                    NewStagingRec."Amount to Use for FX 2" := 0;
                    NewStagingRec."Amt to Use for FX 2 Text" := '';
                    NewStagingRec."Transaction Code" := '';

                    if PaytJournal."DBS Product Type" = 'BPY' then
                        NewStagingRec."Transaction Code" := '20';

                    if PaytJournal."DBS Product Type" = 'SAL' then
                        NewStagingRec."Transaction Code" := '22';

                    if PaytJournal."DBS Product Type" = 'BPY' then
                        // NewStagingRec."Payer Bene Particulars" := PaytJournal."Account No."; //RL   02 Mar 2022
                        NewStagingRec."Payer Bene Particulars" := CopyStr(CompanyName + '-' + format(NewStagingRec."Entry No."), 1, 16); //RL   25 Mar 2022

                    NewStagingRec.DDA := '';

                    //RL 20 May 2022    -  Start -  Add description to payment details
                    if (PaytJournal."Currency Code" = 'CNY') and not (PaytJournal."DBS Product Type" in ['ACT', 'TT']) then
                        NewStagingRec."Payment Details" := CopyStr(PaytJournal.Description, 1, 60)
                    else
                        NewStagingRec."Payment Details" := PaytJournal.Description;
                    //RL 20 May 2022    -  End

                    NewStagingRec."Instruction to Order Bank" := '';
                    NewStagingRec."Bene Resident Status" := '';
                    NewStagingRec."Beneficiary Category" := '';
                    NewStagingRec."Transaction Relationship" := '';
                    NewStagingRec."Payee Role" := '';
                    NewStagingRec."Remitter Identity" := '';
                    NewStagingRec."Purpose of Payment" := '';

                    if PaytJournal."DBS Product Type" = 'GPP' then
                        NewStagingRec."Purpose of Payment" := 'IVPT';

                    if PaytJournal."DBS Product Type" = 'BPY' then
                        NewStagingRec."Purpose of Payment" := 'IVPT';

                    if PaytJournal."DBS Product Type" = 'SAL' then
                        NewStagingRec."Purpose of Payment" := 'SALA';

                    NewStagingRec."Supplementary Info" := '';
                    NewStagingRec."Delivery Mode" := 'E';
                    NewStagingRec."Print or Pickup Location" := '';
                    NewStagingRec."Payable Location" := '';
                    NewStagingRec."Mail to Party Name" := '';
                    NewStagingRec."Mail to Party Address 1" := '';
                    NewStagingRec."Mail to Party Address 2" := '';
                    NewStagingRec."Mail to Party Address 3" := '';
                    NewStagingRec."Reserved Field" := '';
                    NewStagingRec."Mail to Party Postal Code" := '';
                    NewStagingRec."Email 1" := CompanyInfoRec."Payment Advice Email";
                    NewStagingRec."Email 2" := CopyStr(RetrieveVendBankInfo('EMAIL', PaytJournal."Account No.", PaytJournal."Recipient Bank Account"), 1, 75); // BC 80 Char DBS 75 Char
                    NewStagingRec."Email 3" := '';
                    NewStagingRec."Email 4" := '';
                    NewStagingRec."Email 5" := '';
                    NewStagingRec."Phone Number 1" := '';
                    NewStagingRec."Phone Number 2" := '';
                    NewStagingRec."Phone Number 3" := '';
                    NewStagingRec."Phone Number 4" := '';
                    NewStagingRec."Phone Number 5" := '';
                    NewStagingRec."Invoice Details" := PaytJournal.Description;
                    NewStagingRec."Client Reference 1" := '';
                    NewStagingRec."Client Reference 2" := '';
                    NewStagingRec."Client Reference 3" := '';
                    NewStagingRec."Client Reference 4" := '';
                    NewStagingRec."Trailer Record Type" := TrailerRecordType;
                    NewStagingRec."Total No. of Transactions" := TotalNoOfTransactions;
                    NewStagingRec."Total Transaction Amount" := TotalTransactionAmount;
                    // NewStagingRec."Total Transaction Amount Text" := Format(TotalTransactionAmount, 0, '<Decimals,3>');
                    NewStagingRec."Total Transaction Amount Text" := Format(TotalTransactionAmount, 0, '<Precision,2><sign><Integer><Decimals,3>');
                    NewStagingRec.Validated := ValidatedState;
                    NewStagingRec."Date Created Timestamp" := CurrentDateTime;
                    NewStagingRec."Src Jnl Template Name" := PaytJournal."Journal Template Name";
                    NewStagingRec."Src Jnl Batch Name" := PaytJournal."Journal Batch Name";
                    NewStagingRec."Src Jnl Line No." := PaytJournal."Line No.";

                    //RL    25 March 22 - Start - insert line to get entry no. first
                    // NewStagingRec.Insert(true);
                    NewStagingRec.Modify;
                end;
                //RL    25 March 22 - End

                ProcessedCounter += 1;
            until PaytJournal.Next() = 0;

        Message(Format(ProcessedCounter) + ' journal lines added to DBS H2H Staging');
    end;

    procedure IntToTextLeadingZeroes(SourceInteger: Integer;
        ResultTextLength: Integer) ResultText: Text
    begin
        // usage sample
        /*
            Value := IntToTextLeadingZeros(5,10);
            //Value is 0000000005

            Value := IntToTextLeadingZeros(683,5);
            //Value is 00683
        */
        ResultText := PadStr('', ResultTextLength - StrLen(Format(SourceInteger)), '0') + Format(SourceInteger);
    end;

    procedure RemoveDashesAndSpaces(SourceText: Text[250]) ResultText: Text
    var
        NewString: Text[250];
    begin
        NewString := DelChr(SourceText); // remove spaces
        NewString := DelChr(NewString, '=', '-'); // remove dashes
        ResultText := NewString;
    end;

    local procedure ClearSpecialCharacters(InputText: Text) OutputText: Text
    var
        RemoveChar: Char;
    begin
        RemoveChar := '-';
        OutputText := DelChr(InputText, '=', RemoveChar);
        RemoveChar := ',';
        OutputText := DelChr(OutputText, '=', RemoveChar);
        RemoveChar := ' ';
        OutputText := DelChr(OutputText, '=', RemoveChar);
    end;

    local procedure RetrieveVendBankInfo(InputType: Text; VendCode: Code[20]; PVBAcctCode: Code[20]) Output: Code[140]
    var
        VendBankAcctRec: Record "Vendor Bank Account";
        VendRec: Record Vendor;
    begin
        If VendCode <> '' then begin
            VendRec.Reset;
            VendRec.Get(VendCode);
            if PVBAcctCode <> '' then begin
                VendBankAcctRec.Reset;
                VendBankAcctRec.SetRange("Vendor No.", VendCode);
                VendBankAcctRec.SetRange(Code, PVBAcctCode);
                if VendBankAcctRec.FindFirst() then begin
                    // YF 10 Mar 2022

                    if InputType = 'SWIFT' then
                        Output := VendBankAcctRec."SWIFT Code";
                    /*
                    if InputType = 'SWIFT' then begin
                        Output := VendBankAcctRec."SWIFT Code";
                        if StrLen(Output) >= 8 then begin
                            Output := DelStr(Output, 8, 1);
                            Output := InsStr(Output, '0', 8);
                        end;
                    end;
                    */
                    // YF 10 Mar 2022
                    if InputType = 'ACCOUNT' then
                        Output := VendBankAcctRec."Bank Account No.";
                    if InputType = 'EMAIL' then
                        Output := VendBankAcctRec."E-Mail";
                end;
            end
            else begin
                // if no receipient bank acct, get preferred from vendor bank card
                VendBankAcctRec.Reset;
                VendBankAcctRec.SetRange("Vendor No.", VendCode);
                VendBankAcctRec.SetRange(Code, VendRec."Preferred Bank Account Code");
                if VendBankAcctRec.FindFirst() then begin
                    // YF 10 Mar 2022
                    /*
                    if InputType = 'SWIFT' then
                        Output := VendBankAcctRec."SWIFT Code";
                    */
                    if InputType = 'SWIFT' then begin
                        Output := VendBankAcctRec."SWIFT Code";
                        if StrLen(Output) >= 8 then begin
                            Output := DelStr(Output, 8, 1);
                            Output := InsStr(Output, '0', 8);
                        end;
                    end;
                    // YF 10 Mar 2022
                    if InputType = 'ACCOUNT' then
                        Output := VendBankAcctRec."Bank Account No.";
                    if InputType = 'EMAIL' then
                        Output := VendBankAcctRec."E-Mail";
                end;
            end;
        end;
    end;

    local procedure ConvertAmtToCents(InputAmt: Decimal) EXitAmt: Text[50]
    var
        FillerLimit: integer;
        x: integer;
    begin
        FillerLimit := 17;      //According to bank file
        InputAmt := round(InputAmt, 0.01, '=');
        //ConvertAmt := Format(InputAmt, '<Precision,2:2><Standard Format,0>');
        EXitAmt := delchr(format(InputAmt * 100), '=', ',');
        while x < FillerLimit - StrLen(EXitAmt) do begin
            EXitAmt := '0' + EXitAmt;
        end;

    end;

    local procedure FormatSWIFTCode(Input: Text) Output: Text
    begin
        if StrLen(Input) = 8 then
            Output := Input + 'XXX'
        else
            Output := Input; // assuming it is 11 character
    end;

    local procedure ProcessBatchNumber(BatchNum: Integer; ProductType: Code[3]) ResultBatch: Integer
    var
        TempInteger: Integer;
    begin
        
        TempInteger := BatchNum;

        if ProductType = '' then begin
            TempInteger := Round(BatchNum, 10, '<'); // round down nearest 10
            TempInteger += 10; // increment
            ResultBatch := TempInteger;
        end;

        if ProductType = 'ACT' then
            TempInteger := BatchNum + 1;

        if ProductType = 'TT' then
            TempInteger := BatchNum + 2;

        if ProductType = 'MEP' then
            TempInteger := BatchNum + 3;

        if ProductType = 'GPP' then
            TempInteger := BatchNum + 4;

        if ProductType = 'BPY' then
            TempInteger := BatchNum + 5;

        if ProductType = 'SAL' then
            TempInteger := BatchNum + 6;

        ResultBatch := TempInteger;
    end;

    procedure GenerateExportFileBasic(var StagingRec: Record "DBS Host2Host Staging")
    var
        ToBeProcessedRecords: Record "DBS Host2Host Staging";

        TotalNoOfTransactions: Integer;
        TotalTransactionAmount: Decimal;
        TotalTransactionAmountText: Text;

        ContinueFlag: Boolean;

        TempBlob: Codeunit "Temp Blob";
        MyOutStream: OutStream;
        HeaderText: Text;
        BodyText: Text;
        TrailerText: Text;
        NewStream: InStream;
        Tofile: Variant;
        returnValue: Boolean;
    begin
        // Select Unique Originating Account, Payment Currency, Batch ID, Value Date from Dialog to generate CSV File
        ToBeProcessedRecords.Reset;
        ToBeProcessedRecords.SetRange("Orig. Account No.", StagingRec."Orig. Account No.");
        ToBeProcessedRecords.SetRange("Payment Currency", StagingRec."Payment Currency");
        ToBeProcessedRecords.SetRange("Batch ID", StagingRec."Batch ID");
        // ToBeProcessedRecords.SetRange("Header File Creation Date", StagingRec."Header File Creation Date");
        ContinueFlag := ToBeProcessedRecords.Count > 0;

        if ContinueFlag then begin
            // TempBlob.CreateOutStream(MyOutStream, TextEncoding::Windows);
            TempBlob.CreateOutStream(MyOutStream, TextEncoding::UTF8);

            // Generate Header Line
            HeaderText := '';
            MyOutStream.WriteText(HeaderText);

            // Generate Body
            MyOutStream.WriteText();
            BodyText := '';
            MyOutStream.WriteText(BodyText);

            // Generate Trailer
            TrailerText := '';
            MyOutStream.WriteText(TrailerText);

            // Update Exported Flag
            ToBeProcessedRecords.ModifyAll(Exported, true);

            // Generate File
            // TempBlob.CreateInStream(NewStream, TextEncoding::Windows);
            TempBlob.CreateInStream(NewStream, TextEncoding::UTF8);
            Tofile := (FORMAT(WorkDate(), 0, '<Day,2><Month,2><Year4>') + '-' + StagingRec."Batch ID" + '.csv');
            returnValue := DownloadFromStream(NewStream, 'Save File to RoleTailored Client', '', 'CSV File *.csv| *.csv', ToFile);
        end
        else
            Message('Nothing to process');
    end;


    // YF 10 Mar 2022
    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    var
        FindPos: Integer;
    begin
        FindPos := STRPOS(String, FindWhat);
        WHILE FindPos > 0 DO BEGIN
            NewString += DELSTR(String, FindPos) + ReplaceWith;
            String := COPYSTR(String, FindPos + STRLEN(FindWhat));
            FindPos := STRPOS(String, FindWhat);
        END;
        NewString += String;
    end;
    // YF 10 Mar 2022

}