permissionset 66000 MaxxholoPermissions
{
    Assignable = true;
    Permissions = tabledata MaxxholoHeader = RIMD,
        tabledata MaxxholoLine = RIMD,
        tabledata MaxxholoSetup = RIMD,
        table MaxxholoHeader = X,
        table MaxxholoLine = X,
        table MaxxholoSetup = X,
        codeunit "Maxxholo Integration" = X,
        page "Maxxholo Label Doc." = X,
        page "Maxxholo Label List" = X,
        page "Maxxholo Label Subform" = X,
        page "Maxxholo Setup" = X,
        tabledata "Checking Proof Tag Line" = RIMD,
        tabledata "Proof Tag" = RIMD,
        table "Checking Proof Tag Line" = X,
        table "Proof Tag" = X,
        page "Checking Proof Tag Lines" = X,
        page "Proof Tag List" = X,
        page "Checking Proof Tag Line List" = X,
        page "Maxxholo Label Line List" = X;
}