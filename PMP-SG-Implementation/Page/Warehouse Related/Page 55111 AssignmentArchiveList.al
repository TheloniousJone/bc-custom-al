page 55111 "Assignment Archive"
{
    PageType = List;
    Caption = 'System Automated Assignment Archive List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALE Archive";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
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
                    Editable = false;
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
                    Editable = false;
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
                    Editable = false;

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
                    Editable = false;
                    TableRelation = "Sales Invoice Header"."No.";
                    LookupPageId = "Posted Sales Invoices";
                }
            }
        }
    }

    // YF 25 Mar 2025
    var
        ShowSTBio: Boolean;

    trigger OnOpenPage()
    var
        PMPCU: Codeunit "PMP-Enhancements";
    begin
        ShowSTBio := PMPCU.IsPMPCompany();
    end;
    // YF 25 Mar 2025

}