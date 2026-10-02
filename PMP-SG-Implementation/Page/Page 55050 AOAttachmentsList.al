page 55050 "AO Attachments List"
{

    ApplicationArea = All;
    Caption = 'AO Attachments List';
    PageType = List;
    SourceTable = "Document Attachment";
    UsageCategory = Lists;
    RefreshOnActivate = true;
    // Permissions = TableData "17" = IMD, Tabledata "36" = IMD, Tabledata "37" = IMD, Tabledata "38" = IMD, Tabledata "39" = IMD, Tabledata "81" = IMD, Tabledata "21" = IMD, Tabledata "25" = IMD, Tabledata "32" = IMD, Tabledata "110" = IMD, TableData "111" = IMD, TableData "112" = IMD, TableData "113" = IMD, TableData "114" = IMD, TableData "115" = IMD, TableData "120" = IMD, Tabledata "121" = IMD, Tabledata "122" = IMD, Tabledata "123" = IMD, Tabledata "124" = IMD, Tabledata "125" = IMD, Tabledata "169" = IMD, Tabledata "379" = IMD, Tabledata "380" = IMD, Tabledata "271" = IMD, Tabledata "5802" = IMD, Tabledata "5964" = IMD, Tabledata "5965" = IMD, Tabledata "5900" = IMD, Tabledata "5901" = IMD, Tabledata "5902" = IMD; // YF 08 Aug 2024 // MS BC25 Patch
    Permissions = TableData "G/L Entry" = IMD,
                    Tabledata "Sales Header" = IMD,
                    Tabledata "Sales Line" = IMD,
                    Tabledata "Purchase Header" = IMD,
                    Tabledata "Purchase Line" = IMD,
                    Tabledata "Gen. Journal Line" = IMD,
                    Tabledata "Cust. Ledger Entry" = IMD,
                    Tabledata "Vendor Ledger Entry" = IMD,
                    Tabledata "Item Ledger Entry" = IMD,
                    Tabledata "Sales Shipment Header" = IMD,
                    TableData "Sales Shipment Line" = IMD,
                    TableData "Sales Invoice Header" = IMD,
                    TableData "Sales Invoice Line" = IMD,
                    TableData "Sales Cr.Memo Header" = IMD,
                    TableData "Sales Cr.Memo Line" = IMD,
                    TableData "Purch. Rcpt. Header" = IMD,
                    Tabledata "Purch. Rcpt. Line" = IMD,
                    Tabledata "Purch. Inv. Header" = IMD,
                    Tabledata "Purch. Inv. Line" = IMD,
                    Tabledata "Purch. Cr. Memo Hdr." = IMD,
                    Tabledata "Purch. Cr. Memo Line" = IMD,
                    Tabledata "Job Ledger Entry" = IMD,
                    Tabledata "Detailed Cust. Ledg. Entry" = IMD,
                    Tabledata "Detailed Vendor Ledg. Entry" = IMD,
                    Tabledata "Bank Account Ledger Entry" = IMD,
                    Tabledata "Value Entry" = IMD,
                    Tabledata "Service Contract Line" = IMD,
                    Tabledata "Service Contract Header" = IMD,
                    Tabledata "Service Header" = IMD,
                    Tabledata "Service Item Line" = IMD,
                    Tabledata "Service Line" = IMD; // YF 08 Aug 2024 // MS BC25 Patch

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Attached By"; Rec."Attached By")
                {
                    ToolTip = 'Specifies the value of the Attached By field';
                    ApplicationArea = All;
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ToolTip = 'Specifies the value of the Attached Date field';
                    ApplicationArea = All;
                }
                field("Document Flow Purchase"; Rec."Document Flow Purchase")
                {
                    ToolTip = 'Specifies the value of the Flow to Purch. Trx field';
                    ApplicationArea = All;
                }
                field("Document Flow Sales"; Rec."Document Flow Sales")
                {
                    ToolTip = 'Specifies the value of the Flow to Sales Trx field';
                    ApplicationArea = All;
                }
                field("Document Reference ID"; Rec."Document Reference ID")
                {
                    ToolTip = 'Specifies the value of the Document Reference ID field';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field';
                    ApplicationArea = All;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ToolTip = 'Specifies the value of the File Extension field';
                    ApplicationArea = All;
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the Attachment field';
                    ApplicationArea = All;
                }
                field("File Type"; Rec."File Type")
                {
                    ToolTip = 'Specifies the value of the File Type field';
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field';
                    ApplicationArea = All;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the value of the Table ID field';
                    ApplicationArea = All;
                }
                field(User; Rec.User)
                {
                    ToolTip = 'Specifies the value of the User field';
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        Recs: Record "Assembly Header";

    procedure Export2(ShowFileDialog: Boolean): Text
    var
        FullFileName: Text;
        DocumentStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
    begin

        IF Rec.ID = 0 THEN
            EXIT;
        // Ensure document has value in DB
        IF NOT Rec."Document Reference ID".HASVALUE THEN
            EXIT;

        FullFileName := Rec."File Name" + '.' + Rec."File Extension";
        TempBlob.CREATEOUTSTREAM(DocumentStream);
        Rec."Document Reference ID".EXPORTSTREAM(DocumentStream);
        EXIT(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;

    procedure SaveAttachment2(RecRef: RecordRef; FileName: Text; TempBlob: Codeunit "Temp Blob"; OpportunityAttachment: Boolean; OpportunityNo: Code[30])
    var
        IncomingFileName2: Text;
        DocStream2: Instream;
        EmptyFileNameErr: Label 'No content';
        FileManagement: Codeunit "File Management";
        NoDocumentAttachedErr: Label 'No document attached';
        FieldRef: FieldRef;
        LineNo: Integer;
        Rec_Document: Record "Document Attachment";
        Rec_Attachment: Record "Document Attachment";
    begin
        IF FileName = '' THEN
            ERROR(EmptyFileNameErr);
        // Validate file/media is not empty
        IF NOT TempBlob.HASVALUE THEN
            ERROR(EmptyFileNameErr);

        IncomingFileName2 := FileName;
        Clear(Rec_Attachment);
        Rec_Attachment.Reset();
        Rec_Attachment.INIT;
        Rec_Attachment.VALIDATE("File Extension", FileManagement.GetExtension(IncomingFileName2));
        Rec_Attachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(IncomingFileName2), 1, MAXSTRLEN(Rec."File Name")));
        Rec_Attachment.Validate("Document Type", Rec."Document Type"::Order);
        Rec_Attachment.VALIDATE("Table ID", RecRef.NUMBER);
        Rec_Attachment.Validate("No.", Recs."No.");
        // Rec_Attachment.Validate("Date Time", CurrentDateTime); //KM20200317
        // Rec_Attachment.Validate(Cluster, true);//KM20200907
        // Rec_Attachment.Validate("Attached By", UserSecurityId());//KM20200803
        Rec_Attachment."Attached By" := UserSecurityId();//KM20200805
        TempBlob.CREATEINSTREAM(DocStream2);
        Rec_Attachment."Document Reference ID".IMPORTSTREAM(DocStream2, '', IncomingFileName2);
        IF NOT Rec_Attachment."Document Reference ID".HASVALUE THEN
            ERROR(NoDocumentAttachedErr);
        CASE RecRef.NUMBER OF
            DATABASE::Opportunity:
                BEGIN
                    FieldRef := RecRef.FIELD(1);
                    Clear(Rec_Document);
                    Rec_Document.SetRange("Table ID", RecRef.Number);
                    Rec_Document.SetRange("No.", Recs."No.");
                    IF Rec_Document.FindLast() then begin
                        Rec_Attachment.Validate("Line No.", Rec_Document."Line No." + 1000);
                    end
                    else begin
                        Rec_Attachment.Validate("Line No.", 1000);
                    end;

                END;
        END;
        Rec_Attachment.INSERT(TRUE);
    end;

}
