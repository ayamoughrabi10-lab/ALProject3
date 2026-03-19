namespace ALProject.ALProject;

page 50103 "Receipt Voucher List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Income/Expense Journal";
    SourceTableView = where("Journal Type" = const(Receipt));
    CardPageId = "Receipt Voucher Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field("Journal Type"; Rec."Journal Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Caption = 'Post Receipt';
                ApplicationArea = All;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CashierUtils: Codeunit "Cashier Utility";
                begin
                    CashierUtils.PostVoucher(Rec);
                end;
            }
        }
    }
}