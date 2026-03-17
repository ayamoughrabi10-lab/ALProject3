namespace ALProject.ALProject;

using System.Security.User;

pageextension 50112 UserSetupExt extends "User Setup"
{
    layout
    {
        // Adding the fields to the end of the "Control1" group (the main list)
        addlast(Control1)
        {
            field("Is Accountant"; Rec."Is Accountant")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the user has Accountant permissions.';
            }
            field("Is Cashier"; Rec."Is Cashier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the user has Cashier permissions.';
            }
            field("Is Manager"; Rec."Is Manager")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the user has Manager permissions.';
            }
        }
    }

}
