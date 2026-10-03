table 52003 "DBS Host2Host Staging Archive"
{
    DataClassification = ToBeClassified;
    Caption = 'DBS Host2Host Staging Archive';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            // AutoIncrement = True;
            Caption = 'Entry No.';
        }

        // Header
        field(10; "Header Record Type"; Text[6])
        {
            DataClassification = ToBeClassified;
            Caption = 'Header Record Type';
            InitValue = 'HEADER';
        }

        field(20; "Header File Creation Date"; Text[8])
        {
            Caption = 'Header File Creation Date';
            DataClassification = ToBeClassified;
        }

        field(30; "Header Org ID"; Text[12])
        {
            Caption = 'Header Organization ID';
            DataClassification = ToBeClassified;
        }

        field(40; "Header Sender Name"; Text[140])
        {
            Caption = 'Header Sender Name';
            DataClassification = ToBeClassified;
        }
        // Header

        // Details
        field(50; "Detail Record Type"; Text[7])
        {
            Caption = 'Detail Record Type';
            DataClassification = ToBeClassified;
            InitValue = 'PAYMENT';
        }

        field(60; "Product Type"; Text[3])
        {
            Caption = 'Product Type';
            DataClassification = ToBeClassified;
        }

        field(70; "Orig. Account No."; Text[35])
        {
            Caption = 'Originating Account No.';
            DataClassification = ToBeClassified;
        }

        field(80; "Orig. Account Currency"; Text[3])
        {
            Caption = 'Originating Account Currency';
            DataClassification = ToBeClassified;
        }

        field(90; "Cust. Batch Reference"; Text[35])
        {
            Caption = 'Customer/Batch Reference';
            DataClassification = ToBeClassified;
        }

        field(100; "Payment Currency"; Text[3])
        {
            Caption = 'Payment Currency';
            DataClassification = ToBeClassified;
        }

        field(110; "Batch ID"; Text[5])
        {
            Caption = 'Batch ID';
            DataClassification = ToBeClassified;
        }

        field(115; "Base Batch ID"; Text[5])
        {
            Caption = 'Base Batch ID';
            DataClassification = ToBeClassified;
        }

        field(120; "Payment Date"; Text[8])
        {
            Caption = 'Payment Date';
            DataClassification = ToBeClassified;
        }

        field(130; "Bank Charges"; Text[3])
        {
            Caption = 'Bank Charges';
            DataClassification = ToBeClassified;
        }

        field(140; "Debit Acct for Bank Charges"; Text[35])
        {
            Caption = 'Debit Account for Bank Charges';
            DataClassification = ToBeClassified;
        }

        field(150; "Receiving Party Name"; Text[35])
        {
            Caption = 'Receiving Party Name';
            DataClassification = ToBeClassified;
        }

        field(160; "Payable To"; Text[70])
        {
            Caption = 'Payable To';
            DataClassification = ToBeClassified;
        }

        field(170; "Recv Party Address 1"; Text[35])
        {
            Caption = 'Receiving Party Address 1';
            DataClassification = ToBeClassified;
        }

        field(180; "Recv Party Address 2"; Text[35])
        {
            Caption = 'Receiving Party Address 2';
            DataClassification = ToBeClassified;
        }

        field(190; "Recv Party Address 3"; Text[35])
        {
            Caption = 'Receiving Party Address 3';
            DataClassification = ToBeClassified;
        }

        field(200; "Recv Acct No. IBAN"; Text[34])
        {
            Caption = 'Receiving Account No./IBAN';
            DataClassification = ToBeClassified;
        }

        field(210; "Country Specific"; Text[2])
        {
            Caption = 'Country Specific';
            DataClassification = ToBeClassified;
        }

        field(220; "Receiving Bank Code"; Text[4])
        {
            Caption = 'Receiving Bank Code';
            DataClassification = ToBeClassified;
        }

        field(230; "Receiving Branch Code"; Text[4])
        {
            Caption = 'Receiving Branch Code';
            DataClassification = ToBeClassified;
        }

        field(240; "Clearing Code"; Text[12])
        {
            Caption = 'Clearing Code';
            DataClassification = ToBeClassified;
        }

        field(250; "Bene Bank SWIFT BIC"; Text[11])
        {
            Caption = 'Beneficiary Bank SWIFT BIC';
            DataClassification = ToBeClassified;
        }

        field(260; "Bene Bank Name"; Text[35])
        {
            Caption = 'Beneficiary Bank Name';
            DataClassification = ToBeClassified;
        }

        field(270; "Bene Bank Address"; Text[70])
        {
            Caption = 'Beneficiary Bank Address';
            DataClassification = ToBeClassified;
        }

        field(280; "Bene Bank Country"; Text[2])
        {
            Caption = 'Beneficiary Bank Country';
            DataClassification = ToBeClassified;
        }

        field(290; "Routing Code"; Text[31])
        {
            Caption = 'Routing Code';
            DataClassification = ToBeClassified;
        }

        field(300; "Intermed. Bank SWIFT BIC"; Text[11])
        {
            Caption = 'Intermed. Bank SWIFT BIC';
            DataClassification = ToBeClassified;
        }

        field(310; "Amount Currency"; Text[1])
        {
            Caption = 'Amount Currency';
            DataClassification = ToBeClassified;
        }

        field(320; "Amount Value"; Decimal)
        {
            Caption = 'Amount Value';
            DataClassification = ToBeClassified;
        }

        field(330; "Amount Text"; Text[13])
        {
            Caption = 'Amount Text';
            DataClassification = ToBeClassified;
        }

        field(340; "FX Contract Reference 1"; Text[50])
        {
            Caption = 'FX Contract Reference 1';
            DataClassification = ToBeClassified;
        }

        field(350; "Amount to Use for FX 1"; Decimal)
        {
            Caption = 'Amount to Use for FX 1';
            DataClassification = ToBeClassified;
        }

        field(360; "Amt to Use for FX 1 Text"; Text[11])
        {
            Caption = 'Amt to Use for FX 1 Text';
            DataClassification = ToBeClassified;
        }

        field(370; "FX Contract Reference 2"; Text[50])
        {
            Caption = 'FX Contract Reference 2';
            DataClassification = ToBeClassified;
        }

        field(380; "Amount to Use for FX 2"; Decimal)
        {
            Caption = 'Amount to Use for FX 2';
            DataClassification = ToBeClassified;
        }

        field(390; "Amt to Use for FX 2 Text"; Text[11])
        {
            Caption = 'Amt to Use for FX 2 Text';
            DataClassification = ToBeClassified;
        }

        field(400; "Transaction Code"; Text[2])
        {
            Caption = 'Transaction Code';
            DataClassification = ToBeClassified;
        }

        field(410; "Payer Bene Particulars"; Text[35])
        {
            Caption = 'Payer/Beneficiary Particulars';
            DataClassification = ToBeClassified;
        }

        field(420; "DDA"; Text[35])
        {
            Caption = 'DDA';
            DataClassification = ToBeClassified;
        }

        field(430; "Payment Details"; Text[140])
        {
            Caption = 'Payment Details';
            DataClassification = ToBeClassified;
        }

        field(440; "Instruction to Order Bank"; Text[128])
        {
            Caption = 'Instruction to Order Bank';
            DataClassification = ToBeClassified;
        }

        field(450; "Bene Resident Status"; Text[1])
        {
            Caption = 'Beneficiary Resident Status';
            DataClassification = ToBeClassified;
        }

        field(460; "Beneficiary Category"; Text[2])
        {
            Caption = 'Beneficiary Category';
            DataClassification = ToBeClassified;
        }

        field(470; "Transaction Relationship"; Text[1])
        {
            Caption = 'Transaction Relationship';
            DataClassification = ToBeClassified;
        }

        field(480; "Payee Role"; Text[1])
        {
            Caption = 'Payee Role';
            DataClassification = ToBeClassified;
        }

        field(490; "Remitter Identity"; Text[2])
        {
            Caption = 'Remitter Identity';
            DataClassification = ToBeClassified;
        }

        field(500; "Purpose of Payment"; Text[4])
        {
            Caption = 'Purpose of Payment';
            DataClassification = ToBeClassified;
        }

        field(510; "Supplementary Info"; Text[35])
        {
            Caption = 'Supplementary Info';
            DataClassification = ToBeClassified;
        }

        field(520; "Delivery Mode"; Text[1])
        {
            Caption = 'Delivery Mode';
            DataClassification = ToBeClassified;
        }

        field(530; "Print or Pickup Location"; Text[16])
        {
            Caption = 'Print/Pickup Location';
            DataClassification = ToBeClassified;
        }

        field(540; "Payable Location"; Text[16])
        {
            Caption = 'Payable Location';
            DataClassification = ToBeClassified;
        }

        field(550; "Mail to Party Name"; Text[35])
        {
            Caption = 'Mail to Party Name';
            DataClassification = ToBeClassified;
        }

        field(560; "Mail to Party Address 1"; Text[35])
        {
            Caption = 'Mail to Party Address 1';
            DataClassification = ToBeClassified;
        }

        field(570; "Mail to Party Address 2"; Text[35])
        {
            Caption = 'Mail to Party Address 2';
            DataClassification = ToBeClassified;
        }

        field(580; "Mail to Party Address 3"; Text[35])
        {
            Caption = 'Mail to Party Address 3';
            DataClassification = ToBeClassified;
        }

        field(590; "Reserved Field"; Text[1])
        {
            Caption = 'Reserved Field';
            DataClassification = ToBeClassified;
        }

        field(600; "Mail to Party Postal Code"; Text[8])
        {
            Caption = 'Mail to Party Postal Code';
            DataClassification = ToBeClassified;
        }

        field(610; "Email 1"; Text[75])
        {
            Caption = 'Email 1';
            DataClassification = ToBeClassified;
        }

        field(620; "Email 2"; Text[75])
        {
            Caption = 'Email 2';
            DataClassification = ToBeClassified;
        }

        field(630; "Email 3"; Text[75])
        {
            Caption = 'Email 3';
            DataClassification = ToBeClassified;
        }

        field(640; "Email 4"; Text[75])
        {
            Caption = 'Email 4';
            DataClassification = ToBeClassified;
        }

        field(650; "Email 5"; Text[75])
        {
            Caption = 'Email 5';
            DataClassification = ToBeClassified;
        }

        field(660; "Phone Number 1"; Text[35])
        {
            Caption = 'Phone Number 1';
            DataClassification = ToBeClassified;
        }

        field(670; "Phone Number 2"; Text[35])
        {
            Caption = 'Phone Number 2';
            DataClassification = ToBeClassified;
        }

        field(680; "Phone Number 3"; Text[35])
        {
            Caption = 'Phone Number 3';
            DataClassification = ToBeClassified;
        }

        field(690; "Phone Number 4"; Text[35])
        {
            Caption = 'Phone Number 4';
            DataClassification = ToBeClassified;
        }

        field(700; "Phone Number 5"; Text[35])
        {
            Caption = 'Phone Number 5';
            DataClassification = ToBeClassified;
        }

        field(710; "Invoice Details"; Text[500])
        {
            Caption = 'Invoice Details';
            DataClassification = ToBeClassified;
        }

        field(720; "Client Reference 1"; Text[40])
        {
            Caption = 'Client Reference 1';
            DataClassification = ToBeClassified;
        }

        field(730; "Client Reference 2"; Text[40])
        {
            Caption = 'Client Reference 2';
            DataClassification = ToBeClassified;
        }

        field(740; "Client Reference 3"; Text[40])
        {
            Caption = 'Client Reference 3';
            DataClassification = ToBeClassified;
        }

        field(750; "Client Reference 4"; Text[40])
        {
            Caption = 'Client Reference 4';
            DataClassification = ToBeClassified;
        }
        // Details

        // Trailer
        field(760; "Trailer Record Type"; Text[7])
        {
            Caption = 'Trailer Record Type';
            DataClassification = ToBeClassified;
            InitValue = 'TRAILER';
        }

        field(770; "Total No. of Transactions"; Integer)
        {
            Caption = 'Total No. of Transactions';
            DataClassification = ToBeClassified;
        }

        field(780; "Total Transaction Amount"; Decimal)
        {
            Caption = 'Total Transaction Amount';
            DataClassification = ToBeClassified;
        }

        field(785; "Total Transaction Amount Text"; Text[50])
        {
            Caption = 'Total Transaction Amount';
            DataClassification = ToBeClassified;
        }
        // Trailer

        // System Administration
        field(790; "Validated"; Boolean)
        {
            Caption = 'Validated';
            DataClassification = ToBeClassified;
        }

        field(800; "Process Remarks"; Text[500])
        {
            Caption = 'Process Remarks';
            DataClassification = ToBeClassified;
        }

        field(810; "Date Created Timestamp"; DateTime)
        {
            Caption = 'Date Created Timestamp';
            DataClassification = ToBeClassified;
        }

        field(820; Exported; Boolean)
        {
            Caption = 'Exported';
            DataClassification = ToBeClassified;
        }
        // System Administration

        // Source Journal Tracking
        field(830; "Src Jnl Template Name"; Code[10])
        {
            Caption = 'Source Journal Template Name';
            DataClassification = ToBeClassified;
        }

        field(840; "Src Jnl Batch Name"; Code[10])
        {
            Caption = 'Source Journal Batch Name';
            DataClassification = ToBeClassified;
        }

        field(850; "Src Jnl Line No."; Integer)
        {
            Caption = 'Source Journal Line No.';
            DataClassification = ToBeClassified;
        }
        // Source Journal Tracking
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}