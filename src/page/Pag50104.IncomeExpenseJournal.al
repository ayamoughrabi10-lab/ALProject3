namespace ALProject.ALProject;

page 50104 "Income/Expense Journal"
{
    ApplicationArea = All;
    Caption = 'Income/Expense Journal';
    PageType = List;
    SourceTable = "Income/Expense Journal";
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Amount(LCY)"; Rec."Amount(LCY)")
                {
                    ToolTip = 'Specifies the value of the Amount(LCY) field.', Comment = '%';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Bal. Account Type field.', Comment = '%';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                }
                field("Bal. Currency Code"; Rec."Bal. Currency Code")
                {
                    ToolTip = 'Specifies the value of the Bal. Currency Code field.', Comment = '%';
                }
                field("Bal. Amount"; Rec."Bal. Amount")
                {
                    ToolTip = 'Specifies the value of the Bal. Amount field.', Comment = '%';
                }
                field("Journal Type"; Rec."Journal Type")
                {
                    ToolTip = 'Specifies the value of the Journal Type field.', Comment = '%';
                }
            }
        }
    }
}
