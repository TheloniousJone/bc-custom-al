pageextension 55041 PostedSalesCrMemoPageExt extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field(Rebill; Rec.Rebill)
            {
                ApplicationArea = ALL;
            }
            field("Rebill SO"; Rec."Rebill SO")
            {
                ApplicationArea = all;
            }

            // YF 28 Oct 2021
            field("Branch/Subsidiary"; Rec."Branch/Subsidiary")
            {
                ApplicationArea = All;
            }

            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = All;
            }
            // YF 28 Oct 2021
            field("Customer Group"; Rec."Customer Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Group field.', Comment = '%';
            }

            // Task 2560 // Begin
            field("I9G_Bill_to_Customer_No"; Rec."Bill-to Customer No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bill-to Customer No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Allow_Line_Disc"; Rec."Allow Line Disc.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Line Disc. field.', Comment = '%';
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
            field("I9G_Alt_VAT_Registration_No"; Rec."Alt. VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Alternative VAT Registration No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G Amount"; Rec.Amount)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the total of the amounts on all the credit memo lines, in the currency of the credit memo. The amount does not include VAT.';
                Visible = false;
            }
            field("I9G_Amount_Including_VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
                Visible = false;
            }
            field("I9G_Area"; Rec."Area")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Area field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Bal_Account_No"; Rec."Bal. Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Bal_Account_Type"; Rec."Bal. Account Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bal. Account Type field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Bill_to_Name_2"; Rec."Bill-to Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bill-to Name 2 field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Campaign_No"; Rec."Campaign No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Campaign No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Comment"; Rec.Comment)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Currency_Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency Factor field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Cust_Ledger_Entry_No"; Rec."Cust. Ledger Entry No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cust. Ledger Entry No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Customer_Disc_Group"; Rec."Customer Disc. Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Disc. Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Customer_Price_Group"; Rec."Customer Price Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Price Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Dimension_Set_ID"; Rec."Dimension Set ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Doc_Exch_Original_Identifier"; Rec."Doc. Exch. Original Identifier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Doc. Exch. Original Identifier field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Document_Exchange_Identifier"; Rec."Document Exchange Identifier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Exchange Identifier field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Draft_Cr_Memo_SystemId"; Rec."Draft Cr. Memo SystemId")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Draft Cr. Memo System Id field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Due_Date"; Rec."Due Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date on which the shipment is due for payment.';
                Visible = false;
            }
            field("I9G_Exit_Point"; Rec."Exit Point")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exit Point field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Format_Region"; Rec."Format Region")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Format Region field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Gen_Bus_Posting_Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Get_Return_Receipt_Used"; Rec."Get Return Receipt Used")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Get Return Receipt Used field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Invoice_Disc_Code"; Rec."Invoice Disc. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice Disc. Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Invoice_Discount_Amount"; Rec."Invoice Discount Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice Discount Amount field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Language_Code"; Rec."Language Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Language Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_No_Series"; Rec."No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                Visible = false;
            }
            field("I9G_On_Hold"; Rec."On Hold")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the On Hold field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Opportunity_No"; Rec."Opportunity No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Opportunity No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Paid"; Rec.Paid)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the posted sales invoice that relates to this sales credit memo is paid.';
                Visible = false;
            }
            field("I9G_Payment_Discount_Percent"; Rec."Payment Discount %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Discount % field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Payment_Terms_Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Terms Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Pmt_Discount_Date"; Rec."Pmt. Discount Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pmt. Discount Date field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Posting_Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies any text that is entered to accompany the posting, for example for information to auditors.';
                Visible = false;
            }
            field("I9G_Pre_Assigned_No_Series"; Rec."Pre-Assigned No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pre-Assigned No. Series field.', Comment = '%';
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
            field("I9G_Prepmt_Cr_Memo_No_Series"; Rec."Prepmt. Cr. Memo No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepmt. Cr. Memo No. Series field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Price_Calculation_Method"; Rec."Price Calculation Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Calculation Method field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Prices_Including_VAT"; Rec."Prices Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prices Including VAT field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Rcvd_from_Count_Region_Code"; Rec."Rcvd.-from Count./Region Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Received-from Country/Region Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Reason_Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Registration_Number"; Rec."Registration Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Registration No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Remaining_Amount"; Rec."Remaining Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the amount that remains to be paid for the posted sales invoice.';
                Visible = false;
            }
            field("I9G_Return_Order_No_Series"; Rec."Return Order No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Return Order No. Series field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Sell_to_Customer_Name_2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sell-to Customer Name 2 field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Sell_to_E_Mail"; Rec."Sell-to E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Email field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Sell_to_Phone_No"; Rec."Sell-to Phone No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sell-to Phone No. field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Ship_to_Code"; Rec."Ship-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.';
                Visible = false;
            }
            field("I9G_Shipment_Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipment Date field.', Comment = '%';
                Visible = false;
            }
            field("I9G_Source_Code"; Rec."Source Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                Visible = false;
            }
            field("I9G_SystemCreatedAt"; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                Visible = false;
            }
            field("I9G_SystemCreatedBy"; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
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
            field("I9G_Transaction_Specification"; Rec."Transaction Specification")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transaction Specification field.', Comment = '%';
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
            field("I9G_User_ID"; Rec."User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                Visible = false;
            }
            field("I9G_VAT_Base_Discount_Percent"; Rec."VAT Base Discount %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Base Discount % field.', Comment = '%';
                Visible = false;
            }
            field("I9G_VAT_Bus_Posting_Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.', Comment = '%';
                Visible = false;
            }
            field("I9G_VAT_Country_Region_Code"; Rec."VAT Country/Region Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Country/Region Code field.', Comment = '%';
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

        }
    }
}
