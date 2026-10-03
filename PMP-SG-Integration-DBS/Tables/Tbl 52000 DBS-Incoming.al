table 52000 "DBS Incoming"
{
    DataClassification = ToBeClassified;
    Caption = 'Incoming DBS Receipts';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = True;
        }
        field(10; msgID; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Message ID';
        }
        field(20; orgID; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Organisation ID';
        }
        field(30; DBS_timeStamp; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'DBS Time Stamp';
        }
        field(40; Country; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country';
        }

        field(50; txnType; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction Type';
        }
        field(52; "Customer Ref."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer Reference';
        }
        field(60; txnRefID; code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction Ref. ID';
        }
        field(70; txnDate; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction Date';
        }
        field(80; valueDate; Date)
        {
            DataClassification = ToBeClassified;
            caption = 'Value Date';
        }
        field(90; "Recipient Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            caption = 'Recipient Name';
        }
        field(100; "Recipient Acct. No."; Code[50])
        {
            DataClassification = ToBeClassified;
            caption = 'Recipient Acct. No';
        }
        field(110; txnCcy; Code[3])
        {
            DataClassification = ToBeClassified;
            caption = 'Transaction Currency';
        }
        field(120; txnAmt; Decimal)
        {
            DataClassification = ToBeClassified;
            caption = 'Transaction Amount.';
        }
        field(130; "Sender Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            caption = 'Sender Name.';
        }
        field(140; "Sender Acct. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            caption = 'Sender Acct. No.';
        }
        field(150; "Payment Details"; Text[140])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Details';
        }
        field(160; "Additional Info."; Text[520])
        {
            DataClassification = ToBeClassified;
            Caption = 'Additional Info.';
        }
        field(170; "Journals Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Journals created.';
        }
        field(180; "Journal Doc. No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Journal Doc. No.';
        }

        // YF 19 Nov 2021 // Internal Status Fields
        field(190; "Has Error"; Boolean)
        {
            Caption = 'Has Error';
        }

        field(200; "Process Remark"; Text[150])
        {
            Caption = 'Process Remark';
        }

        field(210; "Entry Processed"; DateTime)
        {
            Caption = 'Entry Processed';
        }
        // YF 19 Nov 2021 // Internal Status Fields

        // YF 09 Dec 2021
        field(220; "Sender Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sender Acct. No.';
        }
        // YF 09 Dec 2021
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}