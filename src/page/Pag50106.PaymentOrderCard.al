page 50106 "Payment Order Card"
{
    PageType = Card;
    SourceTable = "Payment Order";
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Payment No."; Rec."Payment No.") { ApplicationArea = All; }
                field("Payment Type"; Rec."Payment Type") { ApplicationArea = All; }
                field("Account Type"; Rec."Account Type") { ApplicationArea = All; }
                field("Account No."; Rec."Account No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; Editable = false; }
            }
            group(Lines)
            {
                Caption = 'Payment Amount';
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount(LCY)"; Rec."Amount(LCY)") { ApplicationArea = All; Editable = false; }
            }
            group(Balancing)
            {
                Caption = 'Balancing';
                field("Bal. Account Type"; Rec."Bal. Account Type") { ApplicationArea = All; }
                field("Bal. Account No."; Rec."Bal. Account No.") { ApplicationArea = All; }
                field("Bal. Currency Code"; Rec."Bal. Currency Code") { ApplicationArea = All; TableRelation = Currency; }
                field("Bal. Amount"; Rec."Bal. Amount") { ApplicationArea = All; }
                field("Bal. Amount(LCY)"; Rec."Bal. Amount(LCY)") { ApplicationArea = All; Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Change Status")
            {
                Caption = 'Change Status';
                Image = Edit;

                action(WaitApproval)
                {
                    Caption = 'Waiting Approval';
                    ApplicationArea = All;
                    Image = SendApprovalRequest;
                    trigger OnAction()
                    var
                        CashierUtils: Codeunit "Cashier Utility";
                    begin
                        CashierUtils.ChangeStatus(Rec, Rec.Status::"Waiting Approval");
                    end;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    ApplicationArea = All;
                    Image = Approve;
                    trigger OnAction()
                    var
                        CashierUtils: Codeunit "Cashier Utility";
                    begin
                        CashierUtils.ChangeStatus(Rec, Rec.Status::Approved);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    ApplicationArea = All;
                    Image = Reject;
                    trigger OnAction()
                    var
                        CashierUtils: Codeunit "Cashier Utility";
                    begin
                        CashierUtils.ChangeStatus(Rec, Rec.Status::Rejected);
                    end;
                }
            }

            action(CreateVoucher)
            {
                Caption = 'Create Voucher';
                ApplicationArea = All;
                Image = CreateDocument;
                // Visible only if Status is Approved AND user is a Cashier in User Setup
                Visible = (Rec.Status = Rec.Status::Approved) and IsCashier;

                trigger OnAction()
                var
                    CashierUtils: Codeunit "Cashier Utility";
                begin
                    CashierUtils.CreateVoucherFromOrder(Rec);
                    CurrPage.Close(); // Requirement: Page will close
                end;
            }
        }
    }

    var
        IsCashier: Boolean;

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        CashierUtils: Codeunit "Cashier Utility";
    begin
        CashierUtils.SetSecurityFilter(Rec);

        if UserSetup.Get(UserId) then
            IsCashier := UserSetup."Is Cashier";
    end;
}
