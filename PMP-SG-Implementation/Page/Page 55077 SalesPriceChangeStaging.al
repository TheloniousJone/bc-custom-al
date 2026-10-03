page 55077 "Sales Price Change Staging"
{
    ApplicationArea = All;
    Caption = 'Sales Price Change Staging';
    PageType = List;
    SourceTable = "Sales Price Change Staging";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the vendor who offers the line discount on the item.';
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Entry Timestamp"; Rec."Entry Timestamp")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the item that the purchase price applies to.';
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field(ItemDesc; ItemDesc)
                {
                    ApplicationArea = all;
                    Visible = true;
                    Caption = 'Description';
                    Editable = false;
                }
                //DX        31 Jan 2025
                field(ItemStatus; ItemRec."Item Status")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //DX        31 Jan 2025

                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;

                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code of the purchase price.';
                    Visible = true;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the minimum quantity of the item that you must buy from the vendor in order to get the purchase price.';
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("FOC Qty"; Rec."FOC Qty")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }
                //DX        31 Jan 2025
                field(CustName; CustName)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                    Editable = false;
                }
                field(CustPriceGroup; CustPriceGrp)
                {
                    ApplicationArea = all;
                    Caption = 'Price Group';
                    Editable = false;
                }
                field(CustStatus; custStatus)
                {
                    ApplicationArea = all;
                    Caption = 'Customer Status';
                    Editable = false;
                }
                field(CustSalesClassification; CustomerRec."Customer Sales Classification")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                //DX        31 Jan 2025

                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date from which the purchase price is valid.';
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date to which the purchase price is valid.';
                    StyleExpr = gFieldStyle;
                    Editable = true;
                }

                field("Revised Price Start Date"; Rec."Revised Price Start Date")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Revised Price End Date"; Rec."Revised Price End Date")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("New Price Start Date"; Rec."New Price Start Date")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    // Editable = true; // YF 03 Jan 2022 
                    Editable = true; // YF 12 Jan 2022
                    trigger OnValidate()
                    begin
                        if Rec."Starting Date" = 0D then
                            exit;

                        Rec."Ending Date" := Rec."New Price Start Date" - 1;
                        // Rec."New Price End Date" := Rec."New Price Start Date" - 1;
                    end;

                    /*
                    trigger OnValidate()
                    begin
                        if Not true then // YF 12 Jan 2022
                            Rec."Revised Price End Date" := Rec."New Price Start Date" - 1;
                    end;
                    */
                }

                field("New Price End Date"; Rec."New Price End Date")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }

                field("Original Cost Price"; Rec."Original Cost Price")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                    Visible = false; //RL   5 Jan 2022
                }

                field("New Cost Price"; Rec."New Cost Price")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                    Visible = false; //RL   5 Jan 2022
                }

                field("Markup Percent"; Rec."Markup Percent")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Original Selling Price"; Rec."Original Selling Price")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Suggested Selling Price"; Rec."Suggested Selling Price")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = true; // YF 03 Jan 2022 
                }

                // YF 18 Mar 2022
                field("TA Type"; Rec."TA Type")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }

                field("Find Next"; Rec."Find Next")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                // YF 18 Mar 2022

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        if (Rec.Status <> Rec.Status::Pending) And (Rec.Status <> Rec.Status::Failed) then
                            gFieldStyle := ''
                        else
                            gFieldStyle := 'Attention';
                    end;
                }

                field("Status Descr"; Rec."Status Descr")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                // YF 07 Mar 2022
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }
                // YF 07 Mar 2022

                field("Processed By"; Rec."Processed By")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }

                field("Processed On"; Rec."Processed On")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Editable = false;
                }
                field(SalesRepWS; SalesRepWS)
                {
                    ApplicationArea = All;
                    caption = 'Sales Rep (WS)';
                }

            }
        }
    }

    // actions
    actions
    {
        area(Processing)
        {
            action("Reject Suggested Sales Price")
            {
                ApplicationArea = All;
                Image = SuggestSalesPrice;

                trigger OnAction();
                var
                    TradeAgreementCU: Codeunit "Trade Agreement CU";
                begin
                    CurrPage.SetSelectionFilter(SalesPriceChangeRec);
                    Clear(TradeAgreementCU);

                    // YF 12 Jan 2022
                    TradeAgreementCU.ProcessSuggestedSalesPriceV3(SalesPriceChangeRec, false);
                    // YF 12 Jan 2022

                    CurrPage.Update();
                end;
            }

            action("Apply Suggested Sales Price")
            {
                ApplicationArea = All;
                Image = SuggestSalesPrice;

                trigger OnAction();
                var
                    TradeAgreementCU: Codeunit "Trade Agreement CU";
                begin
                    CurrPage.SetSelectionFilter(SalesPriceChangeRec);
                    Clear(TradeAgreementCU);

                    // YF 12 Jan 2022
                    TradeAgreementCU.ProcessSuggestedSalesPriceV3(SalesPriceChangeRec, true);
                    // YF 12 Jan 2022

                    CurrPage.Update();
                end;
            }

            // YF 07 Mar 2022
            action("Import Agreed Sales Price Changes")
            {
                ApplicationArea = All;
                Image = SuggestSalesPrice;

                trigger OnAction();
                var
                    TradeAgreementCU: Codeunit "Trade Agreement CU";
                begin
                    Clear(TradeAgreementCU);
                    // Error('Not available');
                    TradeAgreementCU.ImportSalesPriceChange();
                    CurrPage.Update();
                end;
            }
            // YF 07 Mar 2022       
        }
    }

    var
        gFieldStyle: Text[50];
        ItemDesc: Text[100];
        ItemRec: Record item;
        SalesPriceChangeRec: Record "Sales Price Change Staging";
        CustomerRec: Record Customer;
        SalesRepWS: Code[20];
        CustName: text[100];
        CustPriceGrp: text[100];
        custStatus: text[100];

    trigger OnAfterGetCurrRecord()
    begin
        if (Rec.Status <> Rec.Status::Pending) And (Rec.Status <> Rec.Status::Failed) then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';

        if Rec."Item No." <> '' then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."Item No.");
            if ItemRec.FindFirst() then begin
                ItemDesc := ItemRec.Description;
            end else
                ItemDesc := '';
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        clear(CustName);
        clear(CustPriceGrp);
        clear(custStatus);
        if (Rec.Status <> Rec.Status::Pending) And (Rec.Status <> Rec.Status::Failed) then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';
        ItemDesc := '';
        if Rec."Item No." <> '' then begin
            ItemRec.reset;
            ItemRec.SetLoadFields("No.", "Item Sales Classification", Description, "Item Status");
            ItemRec.SetRange("No.", Rec."Item No.");
            if ItemRec.FindFirst() then begin
                ItemDesc := ItemRec.Description;
            end else
                ItemDesc := '';
        end;
        CustomerRec.reset;
        CustomerRec.SetLoadFields("No.", "Corporate  Sales Rep (WS)", "Customer Price Group", "Customer Sales Classification", "Customer Status", Name);
        SalesRepWS := '';
        CustomerRec.SetRange("No.", Rec."Sales Code");
        if (Rec."Sales Code" <> '') and (Rec."Sales Type" = Rec."Sales Type"::Customer) then begin
            if CustomerRec.FindFirst() then begin
                SalesRepWS := CustomerRec."Corporate  Sales Rep (WS)";
                CustName := CustomerRec.Name;
                CustPriceGrp := CustomerRec."Customer Price Group";
                custStatus := format(CustomerRec."Customer Status");
            end;

        end;
    end;


}
