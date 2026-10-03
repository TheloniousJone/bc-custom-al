page 55072 AssignPicker
{

    ApplicationArea = All;
    Caption = 'AssignPicker';
    PageType = List;
    SourceTable = "Assignment Ledger Entry";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Tasks;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {

                //Dx        31 Aug 2021
                field("Pick By Date"; Rec."Pick By Date")
                {
                    ApplicationArea = all;
                }
                field("Priority Picking"; Rec."Priority Picking")
                {
                    ApplicationArea = all;
                }
                //Dx        31 Aug 2021
                //DX        22 Aug 2021
                field("Chain Pharmacy"; Rec."Chain Pharmacy")
                {
                    ApplicationArea = all;
                }
                field("Controlled Drug"; Rec."Controlled Drug")
                {
                    ApplicationArea = all;
                }

                // YF 24 Mar 2025
                field(I9G_STBio; Rec.I9G_STBio)
                {
                    ApplicationArea = All;
                    Visible = ShowSTBio;
                }
                // YF 24 Mar 2025

                field(Wellaway; Rec.Wellaway)
                {
                    ApplicationArea = all;
                }
                //DX        22 Aug 2021
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Name; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Pick Type"; Rec."Pick Type")
                {
                    ApplicationArea = all;
                }
                field("Picking Doc No."; Rec."Picking Doc No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Assign)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    CurrPage.SetSelectionFilter(ALERec);
                    if ALERec.Count = 0 then
                        Error('Please select lines that you wish to assign');

                    clear(PickerList);
                    PickerList.LookupMode := true;
                    if PickerList.RunModal() = Action::LookupOK then begin
                        PickerList.SetSelectionFilter(PickRec);

                        if PickRec.Count > 1 then
                            Error('Please select only 1 picker.');
                        if ALERec.FindSet() then
                            repeat
                                if PickRec.FindFirst() then begin
                                    ALERec.Picker := PickRec."User ID";
                                    ALERec.Modify(FALSE);
                                end;
                            //ALECU.AssignPickerToPL(ALERec, PickRec."User ID");

                            until ALERec.next = 0;
                        CurrPage.Close();

                        Message('Pick lists updated.');
                    end;
                end;
            }
        }
    }
    var
        ALERec: Record "Assignment Ledger Entry";
        PickerList: Page "Picker List";
        PickRec: Record Picker;
        ALECU: Codeunit "Assignment CU";
        ShowSTBio: Boolean; // YF 25 Mar 2025

    // YF 25 Mar 2025
    trigger OnOpenPage()
    var
        PMPCU: Codeunit "PMP-Enhancements";
    begin
        ShowSTBio := PMPCU.IsPMPCompany();
    end;
    // YF 25 Mar 2025
}
