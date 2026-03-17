// namespace ALProject.ALProject;

// page 50103 PaymentOrder
// {
//     ApplicationArea = All;
//     Caption = 'Payment Order';
//     PageType = Document;
//     SourceTable = "Payment Order";

//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 Caption = 'General';

//                 field("Payment No."; Rec."Payment No.")
//                 {
//                     ToolTip = 'Specifies the value of the Payment No. field.', Comment = '%';
//                 }
//                 field("Payment Type"; Rec."Payment Type")
//                 {
//                     ToolTip = 'Specifies the value of the Payment Type field.', Comment = '%';
//                 }
//                 field("Account Type"; Rec."Account Type")
//                 {
//                     ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
//                 }
//                 field("Account No."; Rec."Account No.")
//                 {
//                     ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
//                 }
//                 field("Currency Code"; Rec."Currency Code")
//                 {
//                     ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
//                 }
//                 field("Currency Factor"; Rec."Currency Factor")
//                 {
//                     ToolTip = 'Specifies the value of the Currency Factor field.', Comment = '%';
//                 }
//                 field(Amount; Rec.Amount)
//                 {
//                     ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
//                 }
//                 field("Amount(LCY)"; Rec."Amount(LCY)")
//                 {
//                     ToolTip = 'Specifies the value of the Amount(LCY) field.', Comment = '%';
//                 }
//                 field("Posting Date"; Rec."Posting Date")
//                 {
//                     ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
//                 }
//                 field("Last Date Modified "; Rec."Last Date Modified ")
//                 {
//                     ToolTip = 'Specifies the value of the Last Date Modified field.', Comment = '%';
//                 }
//                 field("Created By"; Rec."Created By")
//                 {
//                     ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
//                 }
//                 field("Bal. Account Type"; Rec."Bal. Account Type")
//                 {
//                     ToolTip = 'Specifies the value of the Bal. Account Type field.', Comment = '%';
//                 }
//                 field("Bal. Account No."; Rec."Bal. Account No.")
//                 {
//                     ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
//                 }
//                 field("Bal. Currency Code"; Rec."Bal. Currency Code")
//                 {
//                     ToolTip = 'Specifies the value of the Bal. Currency Code field.', Comment = '%';
//                 }
//                 field("Bal. Amount"; Rec."Bal. Amount")
//                 {
//                     ToolTip = 'Specifies the value of the Bal. Amount field.', Comment = '%';
//                 }
//                 field("Bal. Amount(LCY)"; Rec."Bal. Amount(LCY)")
//                 {
//                     ToolTip = 'Specifies the value of the Bal. Amount(LCY) field.', Comment = '%';
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     ToolTip = 'Specifies the value of the Status field.', Comment = '%';
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             // This creates the "Option Button" feel by grouping them
//             group("Change Status Group")
//             {
//                 Caption = 'Change Status';
//                 Image = EditStatus;

//                 action(ActionWaiting)
//                 {
//                     Caption = 'Waiting Approval';
//                     ApplicationArea = All;
//                     Image = SendApprovalRequest;

//                     trigger OnAction()
//                     var
//                         CU: Codeunit "Cashier Utility";
//                     begin
//                         CU.SetStatusToWaitingApproval(Rec);
//                     end;
//                 }

//                 action(ActionApprove)
//                 {
//                     Caption = 'Approved';
//                     ApplicationArea = All;
//                     Image = Approve;

//                     trigger OnAction()
//                     var
//                         CU: Codeunit "Cashier Utility";
//                     begin
//                         CU.SetStatusToApproved(Rec);
//                     end;
//                 }

//                 action(ActionReject)
//                 {
//                     Caption = 'Rejected';
//                     ApplicationArea = All;
//                     Image = Reject;

//                     trigger OnAction()
//                     var
//                         CU: Codeunit "Cashier Utility";
//                     begin
//                         CU.SetStatusToRejected(Rec);
//                     end;
//                 }
//             }
//         }
//     }
// }



namespace ALProject.ALProject;

page 50103 "Payment Order"
{
    ApplicationArea = All;
    Caption = 'Payment Order';
    PageType = Document;
    SourceTable = "Payment Order";
    UsageCategory = Tasks;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Payment No."; Rec."Payment No.") { ApplicationArea = All; }
                field("Payment Type"; Rec."Payment Type") { ApplicationArea = All; }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StrongAccent; // Makes status look blue/bold
                }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
            }

            group(PaymentDetails)
            {
                Caption = 'Payment Details';
                field("Account Type"; Rec."Account Type") { ApplicationArea = All; }
                field("Account No."; Rec."Account No.") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }

                // This is the important math field
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter 1/Exchange Rate (e.g., 0.02 for 50 EGP/USD)';
                }

                field("Amount (LCY)"; Rec."Amount(LCY)")
                {
                    ApplicationArea = All;
                    Editable = false; // System calculates this
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Status Actions")
            {
                Caption = 'Change Status';
                Image = EditStatus;

                action(WaitApproval)
                {
                    Caption = 'Waiting Approval';
                    ApplicationArea = All;
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        CU: Codeunit "Cashier Utility";
                    begin
                        CU.SetStatusToWaitingApproval(Rec);
                        CurrPage.Update(); // Refreshes the screen to show new status
                    end;
                }

                action(Approve)
                {
                    Caption = 'Approve';
                    ApplicationArea = All;
                    Image = Approve;

                    trigger OnAction()
                    var
                        CU: Codeunit "Cashier Utility";
                    begin
                        CU.SetStatusToApproved(Rec);
                        CurrPage.Update();
                    end;
                }
            }

            // This button is for the Report you already made
            action(PrintOrder)
            {
                Caption = 'Print Payment Order';
                ApplicationArea = All;
                Image = Print;

                trigger OnAction()
                var
                    PayOrderHeader: Record "Payment Order";
                begin
                    PayOrderHeader.SetRange("Payment No.", Rec."Payment No.");
                    Report.Run(Report::"Payment Order Report", true, false, PayOrderHeader);
                end;
            }
        }
    }
}