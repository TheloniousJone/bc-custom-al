pageextension 55006 AssemblyOrderExt extends "Assembly Order"
{
    layout
    {
        addafter(Status)
        {
            field("Vendor No"; Rec."Vendor No")
            {
                ApplicationArea = All;
            }
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
            }
        }
        // Add changes to page layout here
        addlast(content)
        {
            group(Additional)
            {
                field("Customer Instructions"; Rec."Customer Instructions")
                {
                    ApplicationArea = all;
                }
                field("Picking Instructions"; Rec."Picking Instructions")
                {
                    ApplicationArea = all;
                }

                // YF 13 Dec 2021
                field("Packing Instructions"; Rec."Packing Instructions")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                // YF 13 Dec 2021

                field("Delivery Instructions"; Rec."Delivery Instructions")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
            }
        }
        //DX        09 July 2021        To fulfill issue 11 as per issue list
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                if Rec.Quantity <> 0 then begin
                    ALrec.reset;
                    ALrec.SetRange("Document No.", Rec."No.");
                    ALrec.SetFilter(Quantity, '<>0');
                    if ALrec.FindSet() then
                        repeat
                            ALrec.Validate(ALrec.Quantity, Round(ALrec.Quantity, 1, '>'));
                            ALrec.Validate(ALrec."Quantity to Consume", Round(ALrec.Quantity, 1, '>'));
                            ALrec.Modify(true);
                        until ALrec.next = 0;
                end;

            end;
        }
        //DX        09 July 2021 
        //DX        08 Aug 2021
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                ItemRec: Record item;
            begin
                ItemRec.reset;
                ItemRec.SetRange("No.", Rec."Item No.");
                if ItemRec.FindFirst() then begin
                    Rec."Packing Instructions" := ItemRec."Packing Instructions";
                end;
            end;
        }
        //DX        08 Aug 2021
        //DX        08 July 2021    add attachment
        addfirst(factboxes)
        {
            part("Attachnment"; AOAttachmentFactbox)
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
        //DX        08 July 2021
    }

    actions
    {
        // Add changes to page actions here
        /*
        modify(Print)
        {
            trigger onBeforeACtion()
            var
                myInt: Integer;
                RecordLink: Record "Record Link";
            begin
                RecordLink.reset;
                RecordLink.SetRange("Record ID", Rec.RecordId);
                if NOT (RecordLink.FindFirst()) then
                    Error('No attachments found for this production order, please attach before printing.');
            end;
        }
        */
        modify("Create Warehouse Pick")
        {
            trigger OnAfterAction()
            var
                myInt: Integer;
                WHCU: Codeunit "Warehouse CU";
            begin
                WHCU.CreateALEforAO(Rec);
            end;
        }
        addafter(Print)
        {
            action("Print DO")
            {
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    AORec: Record "Assembly Header";
                begin
                    CurrPage.SetSelectionFilter(AORec);
                    report.Run(57114, true, true, AORec);
                end;
            }
        }

        // YF 11 Feb 2022
        addafter("Update Unit Cost")
        {
            action(UpdateLotNo)
            {
                Caption = 'Update Lot No.';
                Image = UpdateDescription;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    lcdu_IT: Codeunit "Item Track CU";
                begin
                    lcdu_IT.ClearTrackingLinesAO(Rec."No.");
                    lcdu_IT.AutoPopulateTrackingAO(Rec."No.");
                end;
            }

            action(CreatePO)
            {
                Caption = 'Create Purchase Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PMPEnhanceCU: Codeunit "PMP-Enhancements";
                    PONum: Code[20];
                begin
                    // Check if PO already created for this AO
                    if Rec."PO No." <> '' then
                        Error('Purchase Order already created from this Assembly Order');

                    // Check if Vendor No. exists for PO creation
                    if Rec."Vendor No" = '' then
                        Error('Vendor No. required');

                    Clear(PMPEnhanceCU);
                    Clear(PONum);

                    if Confirm('Create Purchase Order from this Assembly Order?', false) then begin
                        // Call Codeunit to Create PO and Get PO No. as return value
                        PONum := PMPEnhanceCU.CreatePOFromAO(Rec."No.", Rec."Document Type");
                        // Update AO with PO No.
                        if PONum = '' then
                            Message('Purchase Order not created')
                        else begin
                            Rec."PO No." := PONum;
                            CurrPage.Update(true); // Refresh Page
                            Message('Purchase Order ' + PONum + ' created'); // Completion Message
                        end;
                    end;
                end;
            }
        }
        // YF 11 Feb 2022
        modify("P&ost")
        {
            trigger OnBeforeAction()
            begin
                Message('%1', 'Please ensure Unit Cost is updated.');
            end;
        }
    }

    var
        ALrec: Record "Assembly Line";
}