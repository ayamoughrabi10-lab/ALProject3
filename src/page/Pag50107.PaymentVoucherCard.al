// page 50107 "Payment Voucher Card"
// {
//     PageType = Card;
//     SourceTable = "Income/Expense Journal";
//     Caption = 'Payment Voucher Card';
//     InsertAllowed = false; // Records come from the Payment Order

//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 field("Document No."; Rec."Document No.") { ApplicationArea = All; Editable = false; }
//                 field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
//                 field("Account Type"; Rec."Account Type") { ApplicationArea = All; }
//                 field("Account No."; Rec."Account No.") { ApplicationArea = All; }
//                 field(Amount; Rec.Amount) { ApplicationArea = All; }
//                 field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }
//             }
//             group(Balancing)
//             {
//                 field("Bal. Account Type"; Rec."Bal. Account Type") { ApplicationArea = All; }
//                 field("Bal. Account No."; Rec."Bal. Account No.") { ApplicationArea = All; }
//                 field("Bal. Amount"; Rec."Bal. Amount") { ApplicationArea = All; }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(Post)
//             {
//                 Caption = 'Post';
//                 Image = PostOrder;
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     // Insert your Posting logic here (e.g., Codeunit.Run)

//                     Message('Voucher %1 posted successfully.', Rec."Document No.");

//                     // Requirement: No records are reserved, delete after posting
//                     Rec.Delete(true);
//                     CurrPage.Close();
//                 end;
//             }
//         }
//     }
// }

page 50107 "Payment Voucher Card"
{
    PageType = Card;
    SourceTable = "Income/Expense Journal";
    Caption = 'Payment Voucher Card';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Payment Details';
                field("Document No."; Rec."Document No.") { ApplicationArea = All; Editable = false; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Journal Type"; Rec."Journal Type") { ApplicationArea = All; Editable = false; }

                group("Account Side")
                {
                    Caption = 'Account (Credit Side)';
                    field("Account Type"; Rec."Account Type") { ApplicationArea = All; }
                    field("Account No."; Rec."Account No.") { ApplicationArea = All; }
                    field(Amount; Rec.Amount) { ApplicationArea = All; }
                    field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }
                }
            }
            group(Balancing)
            {
                Caption = 'Balancing (Debit Side)';
                field("Bal. Account Type"; Rec."Bal. Account Type") { ApplicationArea = All; }
                field("Bal. Account No."; Rec."Bal. Account No.") { ApplicationArea = All; }
                field("Bal. Amount"; Rec."Bal. Amount") { ApplicationArea = All; Editable = false; }
                field("Bal. Currency Code"; Rec."Bal. Currency Code") { ApplicationArea = All; Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Caption = 'Post Payment';
                Image = PostOrder;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Post the payment voucher to the General Ledger and close the voucher.';

                trigger OnAction()
                var
                    CashierUtil: Codeunit "Cashier Utility";
                begin
                    if Confirm('Are you sure you want to post this Payment Voucher?', false) then begin
                        CashierUtil.PostVoucher(Rec);
                        // PostVoucher in your codeunit handles the Rec.Delete()
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }
}