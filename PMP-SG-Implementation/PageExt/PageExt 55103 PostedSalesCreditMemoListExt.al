pageextension 55103 PostedSalesCRListExt extends "Posted Sales Credit Memos"
{
    layout
    {
        // layout changes here
        addafter("Sell-to Customer Name")
        {
            field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
            {
                ApplicationArea = All;
            }

            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = All;
            }

            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("I9 Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s reference. The contents will be printed on sales documents.';
                Caption = 'Your Reference';
            }

            field(ReasonCode; ReasonCode)
            {
                ApplicationArea = All;
                Caption = 'Return Reason';
            }

        }
        addlast(Control1)
        {
            // Task 2560 // Begin
            field("I9G_Bill_to_Name_2"; Rec."Bill-to Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bill-to Name 2 field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Bill_to_Address"; Rec."Bill-to Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the address of the customer that the credit memo was sent to.';
                Visible = false;
            }
            field("I9G_Bill_to_Address_2"; Rec."Bill-to Address 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies additional address information.';
                Visible = false;
            }
            field("I9G_Bill_to_City"; Rec."Bill-to City")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the city of the customer on the sales document.';
                Visible = false;
            }
            field("I9G_Ship_to_Name_2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies an additional part of the name of the customer that the items were shipped to.';
                Visible = false;
            }
            field("I9G_Ship_to_Address"; Rec."Ship-to Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the address that the items were shipped to.';
                Visible = false;
            }
            field("I9G_Ship_to_Address_2"; Rec."Ship-to Address 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies additional address information.';
                Visible = false;
            }
            field("I9G_Ship_to_City"; Rec."Ship-to City")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the city of the customer on the sales document.';
                Visible = false;
            }
            field("I9G_Shipment_Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipment Date field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Posting_Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies any text that is entered to accompany the posting, for example for information to auditors.';
                Visible = false;
            }
            field("I9G_Payment_Terms_Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Terms Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Payment_Discount_Percent"; Rec."Payment Discount %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Discount % field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Pmt_Discount_Date"; Rec."Pmt. Discount Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pmt. Discount Date field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Shipment_Method_Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the shipment method for the shipment.';
                Visible = false;
            }
            field("I9G_Customer_Posting_Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                Visible = false;
            }
            field("I9G_Currency_Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency Factor field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Customer_Price_Group"; Rec."Customer Price Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Price Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Prices_Including_VAT"; Rec."Prices Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prices Including VAT field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Invoice_Disc_Code"; Rec."Invoice Disc. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice Disc. Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Customer_Disc_Group"; Rec."Customer Disc. Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Disc. Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Language_Code"; Rec."Language Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Language Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Format_Region"; Rec."Format Region")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Format Region field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Comment"; Rec.Comment)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                Visible = false;
            }
            field("I9G_On_Hold"; Rec."On Hold")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the On Hold field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Applies_to_Doc_No"; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                Visible = false;
            }
            field("I9G_Bal_Account_No"; Rec."Bal. Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_VAT_Registration_No"; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s VAT registration number for customers.';
                Visible = false;
            }
            field("I9G_Registration_Number"; Rec."Registration Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Registration No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Reason_Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Gen_Bus_Posting_Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_EU_3_Party_Trade"; Rec."EU 3-Party Trade")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the invoice was part of an EU 3-party trade transaction.';
                Visible = false;
            }
            field("I9G_Transaction_Type"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transaction Type field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Transport_Method"; Rec."Transport Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transport Method field.', Comment = '%';
                Visible = false;
            }
            field("I9G_VAT_Country_Region_Code"; Rec."VAT Country/Region Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Country/Region Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Sell_to_Customer_Name_2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sell-to Customer Name 2 field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Sell_to_Address"; Rec."Sell-to Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the address of the customer that the items on the credit memo were sent to.';
                Visible = false;
            }
            field("I9G_Sell_to_Address_2"; Rec."Sell-to Address 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies additional address information.';
                Visible = false;
            }
            field("I9G_Sell_to_City"; Rec."Sell-to City")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the city of the customer on the sales document.';
                Visible = false;
            }
            field("I9G_Bill_to_County"; Rec."Bill-to County")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the state, province or county as a part of the address.';
                Visible = false;
            }
            field("I9G_Sell_to_County"; Rec."Sell-to County")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the state, province or county as a part of the address.';
                Visible = false;
            }
            field("I9G_Ship_to_County"; Rec."Ship-to County")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the state, province or county as a part of the address.';
                Visible = false;
            }
            field("I9G_Bal_Account_Type"; Rec."Bal. Account Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bal. Account Type field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Exit_Point"; Rec."Exit Point")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exit Point field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Correction"; Rec.Correction)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the entry was posted as a corrective entry.';
                Visible = false;
            }
            field("I9G_Area"; Rec."Area")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Area field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Transaction_Specification"; Rec."Transaction Specification")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transaction Specification field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Payment_Method_Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s method of payment. The program has copied the code from the Payment Method Code field on the sales header.';
                Visible = false;
            }
            field("I9G_Shipping_Agent_Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                Visible = false;
            }
            field("I9G_Package_Tracking_No"; Rec."Package Tracking No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the shipping agent''s package number.';
                Visible = false;
            }
            field("I9G_Pre_Assigned_No_Series"; Rec."Pre-Assigned No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pre-Assigned No. Series field.', Comment = '%';
                Visible = false;
            }
            field("I9G_No_Series"; Rec."No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Pre_Assigned_No"; Rec."Pre-Assigned No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the credit memo that the posted credit memo was created from.';
                Visible = false;
            }
            field("I9G_User_ID"; Rec."User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Source_Code"; Rec."Source Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Tax_Area_Code"; Rec."Tax Area Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                Visible = false;
            }
            field("I9G_Tax_Liable"; Rec."Tax Liable")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                Visible = false;
            }
            field("I9G_VAT_Bus_Posting_Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_VAT_Base_Discount_Percent"; Rec."VAT Base Discount %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Base Discount % field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Prepmt_Cr_Memo_No_Series"; Rec."Prepmt. Cr. Memo No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepmt. Cr. Memo No. Series field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Prepayment_Credit_Memo"; Rec."Prepayment Credit Memo")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepayment Credit Memo field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Prepayment_Order_No"; Rec."Prepayment Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepayment Order No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Company_Bank_Account_Code"; Rec."Company Bank Account Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the bank account to use for bank information when the document is printed.';
                Visible = false;
            }
            field("I9G_Alt_VAT_Registration_No"; Rec."Alt. VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Alternative VAT Registration No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Alt_Gen_Bus_Posting_Group"; Rec."Alt. Gen. Bus Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Alternative Gen. Bus. Posting Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Alt_VAT_Bus_Posting_Group"; Rec."Alt. VAT Bus Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Alternative VAT Bus. Posting Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Sell_to_Phone_No"; Rec."Sell-to Phone No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sell-to Phone No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Sell_to_E_Mail"; Rec."Sell-to E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Email field.', Comment = '%';
                Visible = false;
            }
            field("I9G_VAT_Reporting_Date"; Rec."VAT Reporting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the VAT date on the invoice.';
                Visible = false;
            }
            field("I9G_Rcvd_from_Count_Region_Code"; Rec."Rcvd.-from Count./Region Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Received-from Country/Region Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Ship_to_Phone_No"; Rec."Ship-to Phone No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the telephone number of the company''s shipping address.';
                Visible = false;
            }
            field("I9G_Dimension_Set_ID"; Rec."Dimension Set ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Document_Exchange_Identifier"; Rec."Document Exchange Identifier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Exchange Identifier field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Doc_Exch_Original_Identifier"; Rec."Doc. Exch. Original Identifier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Doc. Exch. Original Identifier field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Cust_Ledger_Entry_No"; Rec."Cust. Ledger Entry No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cust. Ledger Entry No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Invoice_Discount_Amount"; Rec."Invoice Discount Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice Discount Amount field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Campaign_No"; Rec."Campaign No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Campaign No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Sell_to_Contact_No"; Rec."Sell-to Contact No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the contact at the customer who handles the credit memo.';
                Visible = false;
            }
            field("I9G_Bill_to_Contact_No"; Rec."Bill-to Contact No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the contact at the customer who handles the credit memo.';
                Visible = false;
            }
            field("I9G_Opportunity_No"; Rec."Opportunity No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Opportunity No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Responsibility_Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the responsibility center that serves the customer on this sales document.';
                Visible = false;
            }
            field("I9G_Shipping_Agent_Service_Code"; Rec."Shipping Agent Service Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies which shipping agent service is used to transport the items on the sales document to the customer.';
                Visible = false;
            }
            field("I9G_Return_Order_No_Series"; Rec."Return Order No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Return Order No. Series field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Price_Calculation_Method"; Rec."Price Calculation Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Calculation Method field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Allow_Line_Disc"; Rec."Allow Line Disc.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Line Disc. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Get_Return_Receipt_Used"; Rec."Get Return Receipt Used")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Get Return Receipt Used field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Draft_Cr_Memo_SystemId"; Rec."Draft Cr. Memo SystemId")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Draft Cr. Memo System Id field.', Comment = '%';
                Visible = false;
            }
            field("I9G_SystemId"; Rec.SystemId)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                Visible = false;
            }
            field("I9G_SystemModifiedAt"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                Visible = false;
            }
            field("I9G_SystemModifiedBy"; Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                Visible = false;
            }

            field(I9G_ReturnReasonCode; Rec.I9G_ReturnReasonCode)
            {
                ApplicationArea = All;
                Visible = false;
            }

            field(I9G_Reason_Text; Rec.I9G_Reason_Text)
            {
                ApplicationArea = All;
                Visible = false;
            }
            // Task 2560 // End

            field(SystemCreatedBy; EnhanceCU.GetUsername(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // action changes here
    }

    var
        ReasonCode: Code[20];

        EnhanceCU: Codeunit "PMP-Enhancements";

    trigger OnAfterGetRecord()
    var
        SCLRec: Record "Sales Cr.Memo Line";
    begin

        Clear(ReasonCode);
        SCLRec.Reset();
        SCLRec.SetRange("Document No.", Rec."No.");
        SCLRec.SetFilter("Return Reason Code", '<>%1', '');
        if SCLRec.FindFirst() then
            ReasonCode := SCLRec."Return Reason Code";


    end;
}
