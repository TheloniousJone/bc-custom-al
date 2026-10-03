page 55003 "Assignment List"
{
    PageType = List;
    Caption = 'System Automated Assignment List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Assignment Ledger Entry";
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Details)
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //Dx        31 Aug 2021
                field("On Hold"; Rec."On Hold")
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
                    Caption = 'Transfer/Wellaway';
                    ApplicationArea = all;
                }
                //DX        22 Aug 2021
                //PK 08112023
                field(WellawayPicks; Rec."Wellaway Picks")
                {
                    Caption = 'Wellaway Picks';
                    ApplicationArea = all;
                }
                //PK 08112023

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    // Editable = false;
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
                    TableRelation = "Sales Header"."No.";
                    LookupPageId = "Sales Order List";
                }
                field("Trip Doc No."; Rec."Trip Doc No.")
                {
                    ApplicationArea = all;
                    TableRelation = "WH Trip Header"."No.";
                    LookupPageId = "WH Trip List";
                }
                field("Basket"; Rec.Basket)
                {
                    ApplicationArea = all;
                }
                field("2nd Basket Code"; Rec."2nd Basket Code")
                {
                    Caption = 'Cold Store Basket for 2nd Trip';
                    ApplicationArea = all;
                }
                field("Pick Type"; Rec."Pick Type")
                {
                    ApplicationArea = all;
                }
                field("Picking Doc No."; Rec."Picking Doc No.")
                {
                    ApplicationArea = all;
                    TableRelation = "Warehouse Activity Header"."No.";
                    LookupPageId = "Warehouse Picks";
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = all;
                    Caption = 'Picking Start Time';

                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = all;
                    Caption = 'Picking End Time';

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Pick By Date"; Rec."Pick By Date")
                {
                    ApplicationArea = all;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;

                }
                field(Picker; Rec.Picker)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("No. of Lines"; Rec."No. of Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Lines field.';
                }

                field("Checker ID"; Rec."Checker ID")
                {
                    ApplicationArea = all;
                }
                field("2nd Checker ID"; Rec."2nd Checker ID")
                {
                    Caption = '2nd Checker';
                    ApplicationArea = all;
                }
                field("Checking Doc No."; Rec."Checking Doc No.")
                {
                    ApplicationArea = all;

                    // TableRelation = "Checking Header"."No.";
                    LookupPageId = "Checking List";
                    /*
                    trigger OnLookup(var Text: text): Boolean
                    var
                        myInt: Integer;
                    begin

                    end;;*/
                }
                field("Check Start Time"; Rec."Check Start Time")
                {
                    ApplicationArea = all;
                }
                field("Check End Time"; Rec."Check End Time")
                {
                    ApplicationArea = all;
                }

                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = all;
                    TableRelation = "Sales Invoice Header"."No.";
                    LookupPageId = "Posted Sales Invoices";
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                //LK26Jun2024
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                //LK26Jun2024

                field("Picker Error"; Rec."Picker Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Picker Error field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        UpdateCheckingHeader('picker');
                    end;
                }
                field("Checker Error"; Rec."Checker Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Checker Error field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        UpdateCheckingHeader('checker');
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Assign Picker")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = SetPriorities;
                trigger OnAction()
                var
                    myInt: Integer;
                    ALERec: Record "Assignment Ledger Entry";
                    ALEPage: page AssignPicker;
                begin
                    ALERec.reset;
                    ALERec.SetRange(Status, ALERec.Status::Processing);
                    clear(ALEPage);
                    ALEPage.SetTableView(ALERec);
                    ALEPage.Run();
                end;
            }
            action("View Source Document")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    SHRec: Record "Sales Header";
                    SOPage: page "Sales Order";
                    AssignRec: Record "Assignment Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(AssignRec);
                    if AssignRec.FindFirst() then begin
                        SHRec.reset;
                        SHRec.SetRange("No.", AssignRec."Document No.");
                        if SHRec.FindFirst() then begin
                            Clear(SOPage);
                            SOPage.SetTableView(SHRec);
                            SOPage.Run();
                        end;

                    end;

                end;
            }
            action("View Picking Doc.")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    WHRec: Record "Warehouse Activity Header";
                    WHPage: page "Warehouse Pick";
                    AssignRec: Record "Assignment Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(AssignRec);
                    if AssignRec.FindFirst() then begin

                        WHRec.reset;
                        WHRec.SetRange("No.", AssignRec."Picking Doc No.");
                        if WHRec.FindFirst() then begin
                            Clear(WHPage);
                            WHPage.SetTableView(WHRec);
                            WHPage.Run();
                        end;
                    end;
                end;
            }
            action("Delete Reserv Entry.")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    WHRec: Record "Warehouse Activity Header";
                    WHPage: page "Warehouse Pick";
                    AssignRec: Record "Assignment Ledger Entry";
                begin

                end;
            }
            action("Delete PL to reset SO.")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    WHRec: Record "Warehouse Activity Header";
                    WHPage: page "Warehouse Pick";
                    AssignRec: Record "Assignment Ledger Entry";
                begin

                    CurrPage.SetSelectionFilter(AssignRec);
                    if AssignRec.FindFirst() then
                        PMPWH.DeleteWHPLforSOBatch(AssignRec);

                end;
            }

            // YF 28 Feb 2022
            action("Archive Completed Assignment Ledger Entries")
            {
                ApplicationArea = All;
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                var
                    ALECU: Codeunit "Assignment CU";
                begin
                    if Confirm('Archive Completed Assignment Ledger Entries?', false) then begin
                        ALECU.ArchiveCompletedALE();
                        CurrPage.Update(false);
                    end;
                end;
            }
            // YF 28 Feb 2022            

        }
    }
    trigger OnOpenPage()
    var
        PMPCU: Codeunit "PMP-Enhancements"; // YF 25 Mar 2025
    begin
        ShowSTBio := PMPCU.IsPMPCompany(); // YF 25 Mar 2025
        Rec.SetCurrentKey("Entry No.");
        if Rec.FindFirst() then begin end;
    end;

    local procedure UpdateCheckingHeader(ErrorType: Text)
    var
        CheckingHdrRec: Record "Checking Header";
    begin
        CheckingHdrRec.Reset();
        CheckingHdrRec.SetLoadFields("No.", "Picker Error", "Checker Error");
        CheckingHdrRec.SetRange("No.", Rec."Checking Doc No.");
        if CheckingHdrRec.FindFirst() then begin
            case ErrorType of
                'picker':
                    begin
                        CheckingHdrRec."Picker Error" := Rec."Picker Error";
                        CheckingHdrRec.Modify(false);
                    end;
                'checker':
                    begin
                        CheckingHdrRec."Checker Error" := Rec."Checker Error";
                        CheckingHdrRec.Modify(false);
                    end;
            end;
        end;
    end;

    var
        PMPWH: Codeunit "Warehouse CU";
        ShowSTBio: Boolean; // YF 25 Mar 2025
}