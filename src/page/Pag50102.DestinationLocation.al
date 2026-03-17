page 50102 DestinationLocation
{
    ApplicationArea = All;
    Caption = 'Destination Location';
    PageType = List;
    SourceTable = "Destination Location";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            // CHANGE THIS: Replace 'group' with 'repeater'
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
            }
        }
    }
}
