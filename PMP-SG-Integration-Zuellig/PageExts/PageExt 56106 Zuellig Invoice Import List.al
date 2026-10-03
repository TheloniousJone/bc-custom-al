pageextension 56106 ExtendZPInvoiceImportList extends "Zuellig Invoices"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Import)
        {
            // action("Create")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Create Documents';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = CreateDocuments;
            //     InFooterBar = true;
            //     trigger OnAction()
            //     var
            //         PMPCU: Codeunit "PMP Integrations";
            //     begin
            //         if Confirm('Are you sure you wish to create documents from Zuelig Invoices?') then begin
            //             Message('%1 Transactions created', PMPCU.CreateDocuments());
            //         end;
            //         // if UploadIntoStream('Please choose your excel file', '', '', Filename, Ins) then begin
            //     end;
            // }

            action("CreateV2")
            {
                ApplicationArea = All;
                Caption = 'Create Documents V2';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocuments;
                InFooterBar = true;
                trigger OnAction()
                var
                    PMPZPCU: Codeunit "Zuellig Integrations";
                begin
                    if Confirm('Are you sure you wish to create documents from Zuelig Invoices?') then begin
                        Message('%1 Transactions created', PMPZPCU.CreateZPInvCRDocs());
                    end;
                    // if UploadIntoStream('Please choose your excel file', '', '', Filename, Ins) then begin
                end;
            }
        }
    }

}