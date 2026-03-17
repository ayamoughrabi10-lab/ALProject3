namespace ALProject.ALProject;

using System.Security.User;

tableextension 50101 UserSetupExt extends "User Setup"
{
    fields
    {
        field(50100; "Is Accountant"; Boolean)
        {
            Caption = 'Is Accountant';
            DataClassification = ToBeClassified;
        }
        field(50101; "Is Cashier"; Boolean)
        {
            Caption = 'Is Cashier';
            DataClassification = ToBeClassified;
        }
        field(50102; "Is Manager"; Boolean)
        {
            Caption = 'Is Manager';
            DataClassification = ToBeClassified;
        }
    }
}
