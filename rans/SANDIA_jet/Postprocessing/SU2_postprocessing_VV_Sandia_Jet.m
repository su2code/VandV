%% Clear all
clear all
clc
close all

%% Setup script
path = "C:\...\";

%% Constants
D_jet = 0.00526; % Jet diameter [m]

%% IMPORT DATA SANDIA SPECIES $\frac{y}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 10);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["xD", "yD", "density", "species0", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, "VarName10", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "VarName10", "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["xD", "yD", "density", "species0", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9"], "ThousandsSeparator", ",");
% Import the data
paxray = readtable(path+"SANDC3H8.JET\ray\raystat\paxray.txt", opts);
paxray_xD = paxray{:,1};
paxray_yD = paxray{:,2};
paxray_rho = paxray{:,3};
paxray_species0 = paxray{:,4};

%% IMPORT DATA SANDIA VEL_JET $\frac{y}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["xD", "yD", "U", "V", "U_RMS", "V_RMS", "VarName7"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["xD", "yD", "U", "V", "U_RMS", "V_RMS", "VarName7"], "ThousandsSeparator", ",");
% Import the data
paxv_jet = readtable(path+"SANDC3H8.JET\vel\velstat\paxv.jet.txt", opts);
clear opts
paxv_xD_jet = paxv_jet{:,1};
paxv_U_jet = paxv_jet{:,3};
paxv_V_jet = paxv_jet{:,4};
paxv_U_RMS_jet = paxv_jet{:,5};
paxv_V_RMS_jet = paxv_jet{:,6};
paxv_TKE_jet = 1/2.*(paxv_U_RMS_jet.^2+2.*paxv_V_RMS_jet.^2);

%% IMPORT DATA SANDIA VEL_AIR $\frac{y}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["xD", "yD", "U", "V", "U_RMS", "V_RMS", "VarName7"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["xD", "yD", "U", "V", "U_RMS", "V_RMS", "VarName7"], "ThousandsSeparator", ",");
% Import the data
paxv_air = readtable(path+"SANDC3H8.JET\vel\velstat\paxv.air.txt", opts);
clear opts
paxv_xD_air = paxv_air{:,1};
paxv_U_air = paxv_air{:,3};
paxv_V_air = paxv_air{:,4};
paxv_U_RMS_air = paxv_air{:,5};
paxv_V_RMS_air = paxv_air{:,6};
paxv_TKE_air = 1/2.*(paxv_U_RMS_air.^2+2.*paxv_V_RMS_air.^2);

%% IMPORT DATA SANDIA VEL $\frac{x}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 4);
% Specify range and delimiter
opts.DataLines = [8, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["xD", "yD", "U", "U_RMS"];
opts.VariableTypes = ["double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["xD", "yD", "U", "U_RMS"], "ThousandsSeparator", ",");
% Import the data
p00v = readtable(path+"SANDC3H8.JET\vel\velstat\p00v.txt", opts);
clear opts
p00v_xD = p00v{:,1};
p00v_yD = p00v{:,2};
p00v_U = p00v{:,3};
p00v_U_RMS = p00v{:,4};

p00v_TKE_air = 1/2.*(p00v_U_RMS.^2);
%SU2_XD0_y_air=SU2_XD0_y0(45:length(SU2_XD0_y0));
%SU2_XD0_TKE_air=SU2_XD0_TKE(45:length(SU2_XD0_TKE));


%% IMPORT DATA SANDIA SPECIES $\frac{x}{D}$ = 4
opts = delimitedTextImportOptions("NumVariables", 4);
% Specify range and delimiter
opts.DataLines = [8, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["CCFILENAMEP04ray", "VarName2", "VarName3", "VarName4"];
opts.VariableTypes = ["double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["CCFILENAMEP04ray", "VarName2", "VarName3", "VarName4"], "ThousandsSeparator", ",");
% Import the data
p04ray = readtable(path+"SANDC3H8.JET\ray\raystat\p04ray.txt", opts);
clear opts
p04ray_xD = p04ray{:,1};
p04ray_yD = p04ray{:,2};
p04ray_species0 = p04ray{:,3};

%% IMPORT DATA SANDIA SPECIES $\frac{x}{D}$ = 15
opts = delimitedTextImportOptions("NumVariables", 10);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["xD", "yD", "rho", "species0", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, "VarName10", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "VarName10", "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["xD", "yD", "rho", "species0", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9"], "ThousandsSeparator", ",");
% Import the data
p15ray = readtable(path+"SANDC3H8.JET\ray\raystat\p15ray.txt", opts);
clear opts
p15ray_xD = p15ray{:,1};
p15ray_yD = p15ray{:,2};
p15ray_rho = p15ray{:,3};
p15ray_species0 = p15ray{:,4};

%% IMPORT DATA SANDIA SPECIES $\frac{x}{D}$ = 30
opts = delimitedTextImportOptions("NumVariables", 10);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["xD", "yD", "rho", "species0", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, "VarName10", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "VarName10", "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["xD", "yD", "rho", "species0", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9"], "ThousandsSeparator", ",");
% Import the data
p30ray = readtable(path+"SANDC3H8.JET\ray\raystat\p30ray.txt", opts);
clear opts
p30ray_xD = p30ray{:,1};
p30ray_yD = p30ray{:,2};
p30ray_rho = p30ray{:,3};
p30ray_species0 = p30ray{:,4};

%% IMPORT DATA SANDIA SPECIES $\frac{x}{D}$ = 50
opts = delimitedTextImportOptions("NumVariables", 10);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["xD", "yD", "rho", "species0", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, "VarName10", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "VarName10", "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["xD", "yD", "rho", "species0", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9"], "ThousandsSeparator", ",");
% Import the data
p50ray = readtable(path+"SANDC3H8.JET\ray\raystat\p50ray.txt", opts);
clear opts
p50ray_xD = p50ray{:,1};
p50ray_yD = p50ray{:,2};
p50ray_rho = p50ray{:,3};
p50ray_species0 = p50ray{:,4};

%% IMPORT DATA SANDIA VEL_JET $\frac{x}{D}$ = 4
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["Var1", "p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS", "Var7"];
opts.SelectedVariableNames = ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var7"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"], "ThousandsSeparator", ",");
% Import the data
p04v_jet = readtable(path+"SANDC3H8.JET\vel\velstat\p04v.jet.txt", opts);
clear opts
p04v_yD_jet = p04v_jet{:,1};
p04v_U_jet = p04v_jet{:,2};
p04v_V_jet = p04v_jet{:,3};
p04v_U_RMS_jet = p04v_jet{:,4};
p04v_V_RMS_jet = p04v_jet{:,5};
p04v_TKE_jet = 1/2.*(p04v_U_RMS_jet.^2+2.*p04v_V_RMS_jet.^2);

%% IMPORT DATA SANDIA VEL_JET $\frac{x}{D}$ = 15
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["Var1", "p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS", "Var7"];
opts.SelectedVariableNames = ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var7"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"], "ThousandsSeparator", ",");
% Import the data
p15v_jet = readtable(path+"SANDC3H8.JET\vel\velstat\p15v.jet.txt", opts);
clear opts
p15v_yD_jet = p15v_jet{:,1};
p15v_U_jet = p15v_jet{:,2};
p15v_V_jet = p15v_jet{:,3};
p15v_U_RMS_jet = p15v_jet{:,4};
p15v_V_RMS_jet = p15v_jet{:,5};
p15v_TKE_jet = 1/2.*(p15v_U_RMS_jet.^2+2.*p15v_V_RMS_jet.^2);

%% IMPORT DATA SANDIA VEL_JET $\frac{x}{D}$ = 30
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["Var1", "p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS", "Var7"];
opts.SelectedVariableNames = ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var7"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"], "ThousandsSeparator", ",");
% Import the data
p30v_jet = readtable(path+"SANDC3H8.JET\vel\velstat\p30v.jet.txt", opts);
clear opts
p30v_yD_jet = p30v_jet{:,1};
p30v_U_jet = p30v_jet{:,2};
p30v_V_jet = p30v_jet{:,3};
p30v_U_RMS_jet = p30v_jet{:,4};
p30v_V_RMS_jet = p30v_jet{:,5};
p30v_TKE_jet = 1/2.*(p30v_U_RMS_jet.^2+2.*p30v_V_RMS_jet.^2);

%% IMPORT DATA SANDIA VEL_JET $\frac{x}{D}$ = 50
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["Var1", "p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS", "Var7"];
opts.SelectedVariableNames = ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var7"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"], "ThousandsSeparator", ",");
% Import the data
p50v_jet = readtable(path+"SANDC3H8.JET\vel\velstat\p50v.jet.txt", opts);
clear opts
p50v_yD_jet = p50v_jet{:,1};
p50v_U_jet = p50v_jet{:,2};
p50v_V_jet = p50v_jet{:,3};
p50v_U_RMS_jet = p50v_jet{:,4};
p50v_V_RMS_jet = p50v_jet{:,5};
p50v_TKE_jet = 1/2.*(p50v_U_RMS_jet.^2+2.*p50v_V_RMS_jet.^2);

%% IMPORT DATA SANDIA VEL_AIR $\frac{x}{D}$ = 4
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["Var1", "p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS", "Var7"];
opts.SelectedVariableNames = ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var7"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"], "ThousandsSeparator", ",");
% Import the data
p04v_air = readtable(path+"SANDC3H8.JET\vel\velstat\p04v.air.txt", opts);
clear opts
p04v_yD_air = p04v_air{:,1};
p04v_U_air = p04v_air{:,2};
p04v_V_air = p04v_air{:,3};
p04v_U_RMS_air = p04v_air{:,4};
p04v_V_RMS_air = p04v_air{:,5};
p04v_TKE_air = 1/2.*(p04v_U_RMS_air.^2+2.*p04v_V_RMS_air.^2);

%% IMPORT DATA SANDIA VEL_AIR $\frac{x}{D}$ = 15
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["Var1", "p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS", "Var7"];
opts.SelectedVariableNames = ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var7"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"], "ThousandsSeparator", ",");
% Import the data
p15v_air = readtable(path+"SANDC3H8.JET\vel\velstat\p15v.air.txt", opts);
clear opts
p15v_yD_air = p15v_air{:,1};
p15v_U_air = p15v_air{:,2};
p15v_V_air = p15v_air{:,3};
p15v_U_RMS_air = p15v_air{:,4};
p15v_V_RMS_air = p15v_air{:,5};
p15v_TKE_air = 1/2.*(p15v_U_RMS_air.^2+2.*p15v_V_RMS_air.^2);

%% IMPORT DATA SANDIA VEL_AIR $\frac{x}{D}$ = 30
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["Var1", "p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS", "Var7"];
opts.SelectedVariableNames = ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var7"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"], "ThousandsSeparator", ",");
% Import the data
p30v_air = readtable(path+"SANDC3H8.JET\vel\velstat\p30v.air.txt", opts);
clear opts
p30v_yD_air = p30v_air{:,1};
p30v_U_air = p30v_air{:,2};
p30v_V_air = p30v_air{:,3};
p30v_U_RMS_air = p30v_air{:,4};
p30v_V_RMS_air = p30v_air{:,5};
p30v_TKE_air = 1/2.*(p30v_U_RMS_air.^2+2.*p30v_V_RMS_air.^2);

%% IMPORT DATA SANDIA VEL_AIR $\frac{x}{D}$ = 50
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["Var1", "p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS", "Var7"];
opts.SelectedVariableNames = ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var7"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["p04v_Yd", "p04v_U", "Var4", "p04v_U_RMS", "p04v_V_RMS"], "ThousandsSeparator", ",");
% Import the data
p50v_air = readtable(path+"SANDC3H8.JET\vel\velstat\p50v.air.txt", opts);
clear opts
p50v_yD_air = p50v_air{:,1};
p50v_U_air = p50v_air{:,2};
p50v_V_air = p50v_air{:,3};
p50v_U_RMS_air = p50v_air{:,4};
p50v_V_RMS_air = p50v_air{:,5};
p50v_TKE_air = 1/2.*(p50v_U_RMS_air.^2+2.*p50v_V_RMS_air.^2);

%% IMPORT DATA SU2 $\frac{y}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_YD0 = readtable(path+"data1994\DATA_yD=0.csv", opts);
clear opts
SU2_V1994m_YD0_rho             = DATA_YD0{:,1};
SU2_V1994m_YD0_species0        = DATA_YD0{:,2};
SU2_V1994m_YD0_TKE             = DATA_YD0{:,3};
SU2_V1994m_YD0_U               = DATA_YD0{:,4};
SU2_V1994m_YD0_V               = DATA_YD0{:,5};
SU2_V1994m_YD0_x               = DATA_YD0{:,6}./D_jet;
SU2_V1994m_YD0_y               = DATA_YD0{:,7}./D_jet;

%% IMPORT DATA SU2 $\frac{x}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD0 = readtable(path+"data1994\DATA_xD=0.csv", opts);
clear opts
SU2_V1994m_XD0_rho         = DATA_XD0{:,1};
SU2_V1994m_XD0_species0    = DATA_XD0{:,2};
SU2_V1994m_XD0_TKE0        = DATA_XD0{:,3};
SU2_V1994m_XD0_U           = DATA_XD0{:,4};
SU2_V1994m_XD0_V           = DATA_XD0{:,5};
SU2_V1994m_XD0_x           = DATA_XD0{:,6};
SU2_V1994m_XD0_y0           = DATA_XD0{:,7}./(D_jet);
SU2_V1994m_XD0_TKE = cat(1,SU2_V1994m_XD0_TKE0,SU2_V1994m_XD0_TKE0);
SU2_V1994m_XD0_y = cat(1,-1.*SU2_V1994m_XD0_y0,SU2_V1994m_XD0_y0);
SU2_V1994m_XD0_y_air=SU2_V1994m_XD0_y0(45:length(SU2_V1994m_XD0_y0));
SU2_V1994m_XD0_TKE_air=SU2_V1994m_XD0_TKE0(45:length(SU2_V1994m_XD0_TKE0));

%% IMPORT DATA SU2 $\frac{x}{D}$ = 4
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD4 = readtable(path+"data1994\DATA_xD=4.csv", opts);
clear opts
SU2_V1994m_XD4_rho             = DATA_XD4{:,1};
SU2_V1994m_XD4_species0        = DATA_XD4{:,2};
SU2_V1994m_XD4_TKE0            = DATA_XD4{:,3};
SU2_V1994m_XD4_U               = DATA_XD4{:,4};
SU2_V1994m_XD4_V               = DATA_XD4{:,5};
SU2_V1994m_XD4_x               = DATA_XD4{:,6};
SU2_V1994m_XD4_y0              = DATA_XD4{:,7}./D_jet;
SU2_V1994m_XD4_TKE = cat(1,SU2_V1994m_XD4_TKE0,SU2_V1994m_XD4_TKE0);
SU2_V1994m_XD4_y = cat(1,-1.*SU2_V1994m_XD4_y0,SU2_V1994m_XD4_y0);
SU2_V1994m_XD4_U = cat(1,SU2_V1994m_XD4_U,SU2_V1994m_XD4_U);
SU2_V1994m_XD4_V = cat(1,-1.*SU2_V1994m_XD4_V,SU2_V1994m_XD4_V);

%% IMPORT DATA SU2 $\frac{x}{D}$ = 15
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD15 = readtable(path+"data1994\DATA_xD=15.csv", opts);
clear opts
SU2_V1994m_XD15_rho             = DATA_XD15{:,1};
SU2_V1994m_XD15_species0        = DATA_XD15{:,2};
SU2_V1994m_XD15_TKE0            = DATA_XD15{:,3};
SU2_V1994m_XD15_U               = DATA_XD15{:,4};
SU2_V1994m_XD15_V               = DATA_XD15{:,5};
SU2_V1994m_XD15_x               = DATA_XD15{:,6};
SU2_V1994m_XD15_y0              = DATA_XD15{:,7}./D_jet;
SU2_V1994m_XD15_TKE = cat(1,SU2_V1994m_XD15_TKE0,SU2_V1994m_XD15_TKE0);
SU2_V1994m_XD15_y = cat(1,-1.*SU2_V1994m_XD15_y0,SU2_V1994m_XD15_y0);
SU2_V1994m_XD15_U = cat(1,SU2_V1994m_XD15_U,SU2_V1994m_XD15_U);
SU2_V1994m_XD15_V = cat(1,-1.*SU2_V1994m_XD15_V,SU2_V1994m_XD15_V);
SU2_V1994m_XD15_species0 = cat(1,SU2_V1994m_XD15_species0,SU2_V1994m_XD15_species0);

%% IMPORT DATA SU2 $\frac{x}{D}$ = 30
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD30 = readtable(path+"data1994\DATA_xD=30.csv", opts);
clear opts
SU2_V1994m_XD30_rho             = DATA_XD30{:,1};
SU2_V1994m_XD30_species0        = DATA_XD30{:,2};
SU2_V1994m_XD30_TKE0            = DATA_XD30{:,3};
SU2_V1994m_XD30_U               = DATA_XD30{:,4};
SU2_V1994m_XD30_V               = DATA_XD30{:,5};
SU2_V1994m_XD30_x               = DATA_XD30{:,6};
SU2_V1994m_XD30_y0              = DATA_XD30{:,7}./D_jet;
SU2_V1994m_XD30_TKE = cat(1,SU2_V1994m_XD30_TKE0,SU2_V1994m_XD30_TKE0);
SU2_V1994m_XD30_y = cat(1,-1.*SU2_V1994m_XD30_y0,SU2_V1994m_XD30_y0);
SU2_V1994m_XD30_U = cat(1,SU2_V1994m_XD30_U,SU2_V1994m_XD30_U);
SU2_V1994m_XD30_V = cat(1,-1.*SU2_V1994m_XD30_V,SU2_V1994m_XD30_V);
SU2_V1994m_XD30_species0 = cat(1,SU2_V1994m_XD30_species0,SU2_V1994m_XD30_species0);

%% IMPORT DATA SU2 $\frac{x}{D}$ = 50
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD50 = readtable(path+"data1994\DATA_xD=50.csv", opts);
clear opts
SU2_V1994m_XD50_rho             = DATA_XD50{:,1};
SU2_V1994m_XD50_species0        = DATA_XD50{:,2};
SU2_V1994m_XD50_TKE0            = DATA_XD50{:,3};
SU2_V1994m_XD50_U               = DATA_XD50{:,4};
SU2_V1994m_XD50_V               = DATA_XD50{:,5};
SU2_V1994m_XD50_x               = DATA_XD50{:,6};
SU2_V1994m_XD50_y0              = DATA_XD50{:,7}./D_jet;
SU2_V1994m_XD50_TKE = cat(1,SU2_V1994m_XD50_TKE0,SU2_V1994m_XD50_TKE0);
SU2_V1994m_XD50_y = cat(1,-1.*SU2_V1994m_XD50_y0,SU2_V1994m_XD50_y0);
SU2_V1994m_XD50_U = cat(1,SU2_V1994m_XD50_U,SU2_V1994m_XD50_U);
SU2_V1994m_XD50_V = cat(1,-1.*SU2_V1994m_XD50_V,SU2_V1994m_XD50_V);
SU2_V1994m_XD50_species0 = cat(1,SU2_V1994m_XD50_species0,SU2_V1994m_XD50_species0);

%% IMPORT DATA SU2 $\frac{y}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_YD0 = readtable(path+"data2003\DATA_yD=0.csv", opts);
clear opts
SU2_V2003m_YD0_rho             = DATA_YD0{:,1};
SU2_V2003m_YD0_species0        = DATA_YD0{:,2};
SU2_V2003m_YD0_TKE             = DATA_YD0{:,3};
SU2_V2003m_YD0_U               = DATA_YD0{:,4};
SU2_V2003m_YD0_V               = DATA_YD0{:,5};
SU2_V2003m_YD0_x               = DATA_YD0{:,6}./D_jet;
SU2_V2003m_YD0_y               = DATA_YD0{:,7}./D_jet;

%% IMPORT DATA SU2 $\frac{x}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD0 = readtable(path+"data2003\DATA_xD=0.csv", opts);
clear opts
SU2_V2003m_XD0_rho         = DATA_XD0{:,1};
SU2_V2003m_XD0_species0    = DATA_XD0{:,2};
SU2_V2003m_XD0_TKE0        = DATA_XD0{:,3};
SU2_V2003m_XD0_U           = DATA_XD0{:,4};
SU2_V2003m_XD0_V           = DATA_XD0{:,5};
SU2_V2003m_XD0_x           = DATA_XD0{:,6};
SU2_V2003m_XD0_y0           = DATA_XD0{:,7}./(D_jet);
SU2_V2003m_XD0_TKE = cat(1,SU2_V2003m_XD0_TKE0,SU2_V2003m_XD0_TKE0);
SU2_V2003m_XD0_y = cat(1,-1.*SU2_V2003m_XD0_y0,SU2_V2003m_XD0_y0);
SU2_V2003m_XD0_y_air=SU2_V2003m_XD0_y0(45:length(SU2_V2003m_XD0_y0));
SU2_V2003m_XD0_TKE_air=SU2_V2003m_XD0_TKE0(45:length(SU2_V2003m_XD0_TKE0));

%% IMPORT DATA SU2 $\frac{x}{D}$ = 4
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD4 = readtable(path+"data2003\DATA_xD=4.csv", opts);
clear opts
SU2_V2003m_XD4_rho             = DATA_XD4{:,1};
SU2_V2003m_XD4_species0        = DATA_XD4{:,2};
SU2_V2003m_XD4_TKE0            = DATA_XD4{:,3};
SU2_V2003m_XD4_U               = DATA_XD4{:,4};
SU2_V2003m_XD4_V               = DATA_XD4{:,5};
SU2_V2003m_XD4_x               = DATA_XD4{:,6};
SU2_V2003m_XD4_y0              = DATA_XD4{:,7}./D_jet;
SU2_V2003m_XD4_TKE = cat(1,SU2_V2003m_XD4_TKE0,SU2_V2003m_XD4_TKE0);
SU2_V2003m_XD4_y = cat(1,-1.*SU2_V2003m_XD4_y0,SU2_V2003m_XD4_y0);
SU2_V2003m_XD4_U = cat(1,SU2_V2003m_XD4_U,SU2_V2003m_XD4_U);
SU2_V2003m_XD4_V = cat(1,-1.*SU2_V2003m_XD4_V,SU2_V2003m_XD4_V);

%% IMPORT DATA SU2 $\frac{x}{D}$ = 15
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD15 = readtable(path+"data2003\DATA_xD=15.csv", opts);
clear opts
SU2_V2003m_XD15_rho             = DATA_XD15{:,1};
SU2_V2003m_XD15_species0        = DATA_XD15{:,2};
SU2_V2003m_XD15_TKE0            = DATA_XD15{:,3};
SU2_V2003m_XD15_U               = DATA_XD15{:,4};
SU2_V2003m_XD15_V               = DATA_XD15{:,5};
SU2_V2003m_XD15_x               = DATA_XD15{:,6};
SU2_V2003m_XD15_y0              = DATA_XD15{:,7}./D_jet;
SU2_V2003m_XD15_TKE = cat(1,SU2_V2003m_XD15_TKE0,SU2_V2003m_XD15_TKE0);
SU2_V2003m_XD15_y = cat(1,-1.*SU2_V2003m_XD15_y0,SU2_V2003m_XD15_y0);
SU2_V2003m_XD15_U = cat(1,SU2_V2003m_XD15_U,SU2_V2003m_XD15_U);
SU2_V2003m_XD15_V = cat(1,-1.*SU2_V2003m_XD15_V,SU2_V2003m_XD15_V);
SU2_V2003m_XD15_species0 = cat(1,SU2_V2003m_XD15_species0,SU2_V2003m_XD15_species0);

%% IMPORT DATA SU2 $\frac{x}{D}$ = 30
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD30 = readtable(path+"data2003\DATA_xD=30.csv", opts);
clear opts
SU2_V2003m_XD30_rho             = DATA_XD30{:,1};
SU2_V2003m_XD30_species0        = DATA_XD30{:,2};
SU2_V2003m_XD30_TKE0            = DATA_XD30{:,3};
SU2_V2003m_XD30_U               = DATA_XD30{:,4};
SU2_V2003m_XD30_V               = DATA_XD30{:,5};
SU2_V2003m_XD30_x               = DATA_XD30{:,6};
SU2_V2003m_XD30_y0              = DATA_XD30{:,7}./D_jet;
SU2_V2003m_XD30_TKE = cat(1,SU2_V2003m_XD30_TKE0,SU2_V2003m_XD30_TKE0);
SU2_V2003m_XD30_y = cat(1,-1.*SU2_V2003m_XD30_y0,SU2_V2003m_XD30_y0);
SU2_V2003m_XD30_U = cat(1,SU2_V2003m_XD30_U,SU2_V2003m_XD30_U);
SU2_V2003m_XD30_V = cat(1,-1.*SU2_V2003m_XD30_V,SU2_V2003m_XD30_V);
SU2_V2003m_XD30_species0 = cat(1,SU2_V2003m_XD30_species0,SU2_V2003m_XD30_species0);

%% IMPORT DATA SU2 $\frac{x}{D}$ = 50
opts = delimitedTextImportOptions("NumVariables", 31);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Density", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Species_0", "Var21", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Var25", "Var26", "Var27", "Var28", "Points0", "Points1", "Var31"];
opts.SelectedVariableNames = ["Density", "Species_0", "Turb_Kin_Energy", "Velocity0", "Velocity1", "Points0", "Points1"];
opts.VariableTypes = ["double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "double", "double", "double", "string", "string", "string", "string", "double", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var21", "Var25", "Var26", "Var27", "Var28", "Var31"], "EmptyFieldRule", "auto");
% Import the data
DATA_XD50 = readtable(path+"data2003\DATA_xD=50.csv", opts);
clear opts
SU2_V2003m_XD50_rho             = DATA_XD50{:,1};
SU2_V2003m_XD50_species0        = DATA_XD50{:,2};
SU2_V2003m_XD50_TKE0            = DATA_XD50{:,3};
SU2_V2003m_XD50_U               = DATA_XD50{:,4};
SU2_V2003m_XD50_V               = DATA_XD50{:,5};
SU2_V2003m_XD50_x               = DATA_XD50{:,6};
SU2_V2003m_XD50_y0              = DATA_XD50{:,7}./D_jet;
SU2_V2003m_XD50_TKE = cat(1,SU2_V2003m_XD50_TKE0,SU2_V2003m_XD50_TKE0);
SU2_V2003m_XD50_y = cat(1,-1.*SU2_V2003m_XD50_y0,SU2_V2003m_XD50_y0);
SU2_V2003m_XD50_U = cat(1,SU2_V2003m_XD50_U,SU2_V2003m_XD50_U);
SU2_V2003m_XD50_V = cat(1,-1.*SU2_V2003m_XD50_V,SU2_V2003m_XD50_V);
SU2_V2003m_XD50_species0 = cat(1,SU2_V2003m_XD50_species0,SU2_V2003m_XD50_species0);

%% IMPORT DATA MFSIM VEL  $\frac{y}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 2);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2"];
opts.VariableTypes = ["double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
URANSu = readtable(path+"MFSim_u.csv", opts);
clear opts
MFSim_YD0_U     = URANSu{:,2};
MFSim_YD0_x     = URANSu{:,1};

%% IMPORT DATA MFSIM SPECIES  $\frac{y}{D}$ = 0
opts = delimitedTextImportOptions("NumVariables", 2);
% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2"];
opts.VariableTypes = ["double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
URANSfr = readtable(path+"MFSim_fr.csv", opts);
clear opts
MFSim_YD0_x_species = URANSfr{:,1};
MFSim_YD0_species0 = URANSfr{:,2};

%% IMPORT DATA OPENFOAM yD0
opts = delimitedTextImportOptions("NumVariables", 25);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["C3H8", "EDCpsiChemistryCombustionkappa", "N2", "O2", "Qdot", "T", "U0", "U1", "U2", "Ux", "Uy", "Uz", "alphat", "epsilon", "k", "magU", "nut", "p", "rDeltaT", "rho", "vtkValidPointMask", "arc_length", "Points0", "Points1", "Points2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
OF_DATA_YD0 = readtable(path+"dataOpenFOAM\DATA_yD=0.csv", opts);
clear opts

OPENFOAM_YD0_rho             = OF_DATA_YD0{:,20};
OPENFOAM_YD0_species0        = OF_DATA_YD0{:,1};
OPENFOAM_YD0_TKE             = OF_DATA_YD0{:,15};
OPENFOAM_YD0_U               = OF_DATA_YD0{:,10};
OPENFOAM_YD0_V               = OF_DATA_YD0{:,11};
OPENFOAM_YD0_x               = (OF_DATA_YD0{:,23}-0.1)./D_jet;
OPENFOAM_YD0_y0              = OF_DATA_YD0{:,24};

%% IMPORT DATA OPENFOAM xD0
opts = delimitedTextImportOptions("NumVariables", 25);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["C3H8", "EDCpsiChemistryCombustionkappa", "N2", "O2", "Qdot", "T", "U0", "U1", "U2", "Ux", "Uy", "Uz", "alphat", "epsilon", "k", "magU", "nut", "p", "rDeltaT", "rho", "vtkValidPointMask", "arc_length", "Points0", "Points1", "Points2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
OF_DATA_XD0 = readtable(path+"dataOpenFOAM\DATA_xD=0.csv", opts);
clear opts

OPENFOAM_XD0_rho             = OF_DATA_XD0{:,20};
OPENFOAM_XD0_species0        = OF_DATA_XD0{:,1};
OPENFOAM_XD0_TKE0            = OF_DATA_XD0{:,15};
OPENFOAM_XD0_U               = OF_DATA_XD0{:,10};
OPENFOAM_XD0_V               = OF_DATA_XD0{:,11};
OPENFOAM_XD0_x               = OF_DATA_XD0{:,23}-0.1;
OPENFOAM_XD0_y0              = OF_DATA_XD0{:,24}./D_jet;
OPENFOAM_XD0_TKE = cat(1,flip(OPENFOAM_XD0_TKE0),OPENFOAM_XD0_TKE0);
OPENFOAM_XD0_y = cat(1,flip(-1.*OPENFOAM_XD0_y0),OPENFOAM_XD0_y0);
OPENFOAM_XD0_U = cat(1,flip(OPENFOAM_XD0_U),OPENFOAM_XD0_U);
OPENFOAM_XD0_V = cat(1,-1.*flip(OPENFOAM_XD0_V),OPENFOAM_XD0_V);
OPENFOAM_XD0_species0 = cat(1,flip(OPENFOAM_XD0_species0),OPENFOAM_XD0_species0);

%% IMPORT DATA OPENFOAM XD4
opts = delimitedTextImportOptions("NumVariables", 25);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["C3H8", "EDCpsiChemistryCombustionkappa", "N2", "O2", "Qdot", "T", "U0", "U1", "U2", "Ux", "Uy", "Uz", "alphat", "epsilon", "k", "magU", "nut", "p", "rDeltaT", "rho", "vtkValidPointMask", "arc_length", "Points0", "Points1", "Points2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
OF_DATA_XD4 = readtable(path+"dataOpenFOAM\DATA_xD=4.csv", opts);
clear opts

OPENFOAM_XD4_rho             = OF_DATA_XD4{:,20};
OPENFOAM_XD4_species0        = OF_DATA_XD4{:,1};
OPENFOAM_XD4_TKE0            = OF_DATA_XD4{:,15};
OPENFOAM_XD4_U               = OF_DATA_XD4{:,10};
OPENFOAM_XD4_V               = OF_DATA_XD4{:,11};
OPENFOAM_XD4_x               = OF_DATA_XD4{:,23}-0.1;
OPENFOAM_XD4_y0              = OF_DATA_XD4{:,24}./D_jet;
OPENFOAM_XD4_TKE = cat(1,flip(OPENFOAM_XD4_TKE0),OPENFOAM_XD4_TKE0);
OPENFOAM_XD4_y = cat(1,flip(-1.*OPENFOAM_XD4_y0),OPENFOAM_XD4_y0);
OPENFOAM_XD4_U = cat(1,flip(OPENFOAM_XD4_U),OPENFOAM_XD4_U);
OPENFOAM_XD4_V = cat(1,-1.*flip(OPENFOAM_XD4_V),OPENFOAM_XD4_V);
OPENFOAM_XD4_species0 = cat(1,flip(OPENFOAM_XD4_species0),OPENFOAM_XD4_species0);

%% IMPORT DATA OPENFOAM XD15
opts = delimitedTextImportOptions("NumVariables", 25);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["C3H8", "EDCpsiChemistryCombustionkappa", "N2", "O2", "Qdot", "T", "U0", "U1", "U2", "Ux", "Uy", "Uz", "alphat", "epsilon", "k", "magU", "nut", "p", "rDeltaT", "rho", "vtkValidPointMask", "arc_length", "Points0", "Points1", "Points2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
OF_DATA_XD15 = readtable(path+"dataOpenFOAM\DATA_xD=15.csv", opts);
clear opts

OPENFOAM_XD15_rho             = OF_DATA_XD15{:,20};
OPENFOAM_XD15_species0        = OF_DATA_XD15{:,1};
OPENFOAM_XD15_TKE0            = OF_DATA_XD15{:,15};
OPENFOAM_XD15_U               = OF_DATA_XD15{:,10};
OPENFOAM_XD15_V               = OF_DATA_XD15{:,11};
OPENFOAM_XD15_x               = OF_DATA_XD15{:,23}-0.1;
OPENFOAM_XD15_y0              = OF_DATA_XD15{:,24}./D_jet;
OPENFOAM_XD15_TKE = cat(1,flip(OPENFOAM_XD15_TKE0),OPENFOAM_XD15_TKE0);
OPENFOAM_XD15_y = cat(1,flip(-1.*OPENFOAM_XD15_y0),OPENFOAM_XD15_y0);
OPENFOAM_XD15_U = cat(1,flip(OPENFOAM_XD15_U),OPENFOAM_XD15_U);
OPENFOAM_XD15_V = cat(1,-1.*flip(OPENFOAM_XD15_V),OPENFOAM_XD15_V);
OPENFOAM_XD15_species0 = cat(1,flip(OPENFOAM_XD15_species0),OPENFOAM_XD15_species0);

%% IMPORT DATA OPENFOAM XD30
opts = delimitedTextImportOptions("NumVariables", 25);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["C3H8", "EDCpsiChemistryCombustionkappa", "N2", "O2", "Qdot", "T", "U0", "U1", "U2", "Ux", "Uy", "Uz", "alphat", "epsilon", "k", "magU", "nut", "p", "rDeltaT", "rho", "vtkValidPointMask", "arc_length", "Points0", "Points1", "Points2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
OF_DATA_XD30 = readtable(path+"dataOpenFOAM\DATA_xD=30.csv", opts);
clear opts

OPENFOAM_XD30_rho             = OF_DATA_XD30{:,20};
OPENFOAM_XD30_species0        = OF_DATA_XD30{:,1};
OPENFOAM_XD30_TKE0            = OF_DATA_XD30{:,15};
OPENFOAM_XD30_U               = OF_DATA_XD30{:,10};
OPENFOAM_XD30_V               = OF_DATA_XD30{:,11};
OPENFOAM_XD30_x               = OF_DATA_XD30{:,23}-0.1;
OPENFOAM_XD30_y0              = OF_DATA_XD30{:,24}./D_jet;
OPENFOAM_XD30_TKE = cat(1,flip(OPENFOAM_XD30_TKE0),OPENFOAM_XD30_TKE0);
OPENFOAM_XD30_y = cat(1,flip(-1.*OPENFOAM_XD30_y0),OPENFOAM_XD30_y0);
OPENFOAM_XD30_U = cat(1,flip(OPENFOAM_XD30_U),OPENFOAM_XD30_U);
OPENFOAM_XD30_V = cat(1,-1.*flip(OPENFOAM_XD30_V),OPENFOAM_XD30_V);
OPENFOAM_XD30_species0 = cat(1,flip(OPENFOAM_XD30_species0),OPENFOAM_XD30_species0);

%% IMPORT DATA OPENFOAM XD50
opts = delimitedTextImportOptions("NumVariables", 25);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["C3H8", "EDCpsiChemistryCombustionkappa", "N2", "O2", "Qdot", "T", "U0", "U1", "U2", "Ux", "Uy", "Uz", "alphat", "epsilon", "k", "magU", "nut", "p", "rDeltaT", "rho", "vtkValidPointMask", "arc_length", "Points0", "Points1", "Points2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
OF_DATA_XD50 = readtable(path+"dataOpenFOAM\DATA_xD=50.csv", opts);
clear opts

OPENFOAM_XD50_rho             = OF_DATA_XD50{:,20};
OPENFOAM_XD50_species0        = OF_DATA_XD50{:,1};
OPENFOAM_XD50_TKE0            = OF_DATA_XD50{:,15};
OPENFOAM_XD50_U               = OF_DATA_XD50{:,10};
OPENFOAM_XD50_V               = OF_DATA_XD50{:,11};
OPENFOAM_XD50_x               = OF_DATA_XD50{:,23}-0.1;
OPENFOAM_XD50_y0              = OF_DATA_XD50{:,24}./D_jet;
OPENFOAM_XD50_TKE = cat(1,flip(OPENFOAM_XD50_TKE0),OPENFOAM_XD50_TKE0);
OPENFOAM_XD50_y = cat(1,flip(-1.*OPENFOAM_XD50_y0),OPENFOAM_XD50_y0);
OPENFOAM_XD50_U = cat(1,flip(OPENFOAM_XD50_U),OPENFOAM_XD50_U);
OPENFOAM_XD50_V = cat(1,-1.*flip(OPENFOAM_XD50_V),OPENFOAM_XD50_V);
OPENFOAM_XD50_species0 = cat(1,flip(OPENFOAM_XD50_species0),OPENFOAM_XD50_species0);

%% Plotting

% TKE Radial profiles
figure(1)
hold on 
grid on
plot(p04v_yD_jet,p04v_TKE_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p04v_yD_air,p04v_TKE_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD4_y,SU2_V1994m_XD4_TKE,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD4_y,SU2_V2003m_XD4_TKE,'Color',[1 0 0])
plot(OPENFOAM_XD4_y,OPENFOAM_XD4_TKE,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([-1.5 1.5])
% xlim([-5 5])
ylim([0 140])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('TKE [$\frac{m^2}{s^2}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile TKE ($\frac{x}{D}$=4)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD04_TKE.png","Resolution",600)

figure(2)
hold on
grid on
plot(p15v_yD_jet,p15v_TKE_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p15v_yD_air,p15v_TKE_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD15_y,SU2_V1994m_XD15_TKE,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD15_y,SU2_V2003m_XD15_TKE,'Color',[1 0 0])
plot(OPENFOAM_XD15_y,OPENFOAM_XD15_TKE,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([-3 3])
% xlim([-5 5])
ylim([0 110])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('TKE [$\frac{m^2}{s^2}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile TKE ($\frac{x}{D}$=15)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD15_TKE.png","Resolution",600)

figure(3)
hold on
grid on
plot(p30v_yD_jet,p30v_TKE_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p30v_yD_air,p30v_TKE_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD30_y,SU2_V1994m_XD30_TKE,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD30_y,SU2_V2003m_XD30_TKE,'Color',[1 0 0])
plot(OPENFOAM_XD30_y,OPENFOAM_XD30_TKE,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([-4 4])
% xlim([-5 5])
ylim([0 40])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('TKE [$\frac{m^2}{s^2}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile TKE ($\frac{x}{D}$=30)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD30_TKE.png","Resolution",600)

figure(4)
hold on
grid on
plot(p50v_yD_jet,p50v_TKE_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p50v_yD_air,p50v_TKE_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD50_y,SU2_V1994m_XD50_TKE,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD50_y,SU2_V2003m_XD50_TKE,'Color',[1 0 0])
plot(OPENFOAM_XD50_y,OPENFOAM_XD50_TKE,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([-5 5])
ylim([0 18])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('TKE [$\frac{m^2}{s^2}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile TKE ($\frac{x}{D}$=50)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD50_TKE.png","Resolution",600)

% U_mean Radial profiles
figure(5)
hold on
grid on
plot(p04v_yD_jet,p04v_U_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p04v_yD_air,p04v_U_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD4_y,SU2_V1994m_XD4_U,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD4_y,SU2_V2003m_XD4_U,'Color',[1 0 0])
plot(OPENFOAM_XD4_y,OPENFOAM_XD4_U,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([-6 6])
ylim([0 75])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('U mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile U mean ($\frac{x}{D}$=4)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD04_U.png","Resolution",600)

figure(6)
hold on
grid on
plot(p15v_yD_jet,p15v_U_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p15v_yD_air,p15v_U_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD15_y,SU2_V1994m_XD15_U,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD15_y,SU2_V2003m_XD15_U,'Color',[1 0 0])
plot(OPENFOAM_XD15_y,OPENFOAM_XD15_U,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([-6 6])
ylim([0 50])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('U mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile U mean ($\frac{x}{D}$=15)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD15_U.png","Resolution",600)

figure(7)
hold on
grid on
plot(p30v_yD_jet,p30v_U_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p30v_yD_air,p30v_U_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD30_y,SU2_V1994m_XD30_U,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD30_y,SU2_V2003m_XD30_U,'Color',[1 0 0])
plot(OPENFOAM_XD30_y,OPENFOAM_XD30_U,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([-6 6])
ylim([0 35])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('U mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile U mean ($\frac{x}{D}$=30)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD30_U.png","Resolution",600)

figure(8)
hold on
grid on
plot(p50v_yD_jet,p50v_U_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p50v_yD_air,p50v_U_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD50_y,SU2_V1994m_XD50_U,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD50_y,SU2_V2003m_XD50_U,'Color',[1 0 0])
plot(OPENFOAM_XD50_y,OPENFOAM_XD50_U,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([-6 6])
ylim([0 25])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('U mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile U mean ($\frac{x}{D}$=50)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD50_U.png","Resolution",600)

% Plots along centerline
figure(9)
hold on
grid on
plot(paxv_xD_jet,paxv_U_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(paxv_xD_air,paxv_U_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_YD0_x,SU2_V1994m_YD0_U,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_YD0_x,SU2_V2003m_YD0_U,'Color',[1 0 0])
plot(OPENFOAM_YD0_x,OPENFOAM_YD0_U,'Color',[0.4660 0.6740 0.1880])
plot(MFSim_YD0_x,MFSim_YD0_U,'Color',[0.9290 0.6940 0.1250])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','MFSim (standard k-e)','Interpreter','latex','FontSize',9)
%xlim([-5 5])
ylim([10 75])
xlabel('$\frac{x}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('U mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Axial profile U mean ($\frac{y}{D}$=0)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"YD0_U.png","Resolution",600)

figure(10)
hold on
grid on
plot(paxv_xD_jet,paxv_TKE_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(paxv_xD_air,paxv_TKE_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_YD0_x,SU2_V1994m_YD0_TKE,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_YD0_x,SU2_V2003m_YD0_TKE,'Color',[1 0 0])
plot(OPENFOAM_YD0_x,OPENFOAM_YD0_TKE,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
%xlim([-5 5])
%ylim([10 75])
xlabel('$\frac{x}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('TKE [$\frac{m^2}{s^2}$]', 'Interpreter', 'latex','FontSize',15)
title('Axial profile TKE ($\frac{y}{D}$=0)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"YD0_TKE.png","Resolution",600)

figure(11)
hold on
grid on
plot(paxray_xD,paxray_species0,'linestyle',':','Marker','o','Color',[0 0 0])
plot(SU2_V1994m_YD0_x,SU2_V1994m_YD0_species0,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_YD0_x,SU2_V2003m_YD0_species0,'Color',[1 0 0])
plot(OPENFOAM_YD0_x,OPENFOAM_YD0_species0,'Color',[0.4660 0.6740 0.1880])
hold on
plot(MFSim_YD0_x_species,MFSim_YD0_species0,'Color',[0.9290 0.6940 0.1250])
grid on
legend('Schefer (Experimental)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','MFSim (standard k-e)','Interpreter','latex','FontSize',9)
%xlim([-5 5])
ylim([0 1.1])
xlabel('$\frac{x}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('$f$ [-]', 'Interpreter', 'latex','FontSize',15)
title('Axial profile $f$ ($\frac{y}{D}$=0)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"YD0_f.png","Resolution",600)

figure(12)
hold on
grid on
plot(paxv_xD_jet,-1*paxv_V_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(paxv_xD_air,-1*paxv_V_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_YD0_x,SU2_V1994m_YD0_V,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_YD0_x,SU2_V2003m_YD0_V,'Color',[1 0 0])
plot(OPENFOAM_YD0_x,OPENFOAM_YD0_V,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','Location','northeast','FontSize',9)
%xlim([-5 5])
%ylim([10 75])
xlabel('$\frac{x}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('V mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Axial profile V mean ($\frac{y}{D}$=0)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"YD0_V.png","Resolution",600)

figure(13)
hold on
grid on
plot(paxray_xD,paxray_rho,'linestyle',':','Marker','o','Color',[0 0 0])
plot(SU2_V1994m_YD0_x,SU2_V1994m_YD0_rho,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_YD0_x,SU2_V2003m_YD0_rho,'Color',[1 0 0])
plot(OPENFOAM_YD0_x,OPENFOAM_YD0_rho,'Color',[0.4660 0.6740 0.1880])
%plot(SU2_V1994m_YD0_x,SU2_V1994m_YD0_species0*1.6*1.2004+(1-SU2_V1994m_YD0_species0)*1.2004)
%plot(SU2_V1994m_YD0_x,1/((ratio+(1-ratio)*SU2_V1994m_YD0_species0)/density))
legend('Schefer (Experimental)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
%xlim([-5 5])
%ylim([10 75])
xlabel('$\frac{x}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('$\rho$ mean [$\frac{kg}{m^3}$]', 'Interpreter', 'latex','FontSize',15)
title('Axial profile density mean ($\frac{y}{D}$=0)','Interpreter','latex','FontSize',15)
ax = gca;
exportgraphics(ax,"YD0_rho.png","Resolution",600)

% U_mean Radial profiles
figure(14)
hold on
grid on
plot(p04v_yD_jet,p04v_V_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p04v_yD_air,p04v_V_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD4_y,SU2_V1994m_XD4_V,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD4_y,SU2_V2003m_XD4_V,'Color',[1 0 0])
plot(OPENFOAM_XD4_y,OPENFOAM_XD4_V,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','Location','Southeast','FontSize',9)
xlim([-6 6])
%ylim([10 75])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('V mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile V mean ($\frac{x}{D}$=4)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD04_V.png","Resolution",600)

figure(15)
hold on
grid on
plot(p15v_yD_jet,p15v_V_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p15v_yD_air,p15v_V_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD15_y,SU2_V1994m_XD15_V,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD15_y,SU2_V2003m_XD15_V,'Color',[1 0 0])
plot(OPENFOAM_XD15_y,OPENFOAM_XD15_V,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','Location','Southeast','FontSize',9)
xlim([-6 6])
%ylim([10 75])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('V mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile V mean ($\frac{x}{D}$=15)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD15_V.png","Resolution",600)

figure(16)
hold on
grid on
plot(p30v_yD_jet,p30v_V_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p30v_yD_air,p30v_V_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD30_y,SU2_V1994m_XD30_V,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD30_y,SU2_V2003m_XD30_V,'Color',[1 0 0])
plot(OPENFOAM_XD30_y,OPENFOAM_XD30_V,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','Location','Southeast','FontSize',9)
xlim([-6 6])
%ylim([10 75])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('V mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile V mean ($\frac{x}{D}$=30)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD30_V.png","Resolution",600)

figure(17)
hold on
grid on
plot(p50v_yD_jet,p50v_V_jet,'linestyle',':','Marker','o','Color',[0 0 0])
plot(p50v_yD_air,p50v_V_air,'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_XD50_y,SU2_V1994m_XD50_V,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD50_y,SU2_V2003m_XD50_V,'Color',[1 0 0])
plot(OPENFOAM_XD50_y,OPENFOAM_XD50_V,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','Location','Southeast','FontSize',9)
xlim([-6 6])
%ylim([10 75])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('V mean [$\frac{m}{s}$]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile V mean ($\frac{x}{D}$=50)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD50_V.png","Resolution",600)

% Species Radial profiles
figure(18)
hold on
grid on
plot(p04ray_yD,p04ray_species0,'linestyle',':','Marker','o','Color',[0 0 0])
plot(SU2_V1994m_XD4_y0,SU2_V1994m_XD4_species0,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD4_y0,SU2_V2003m_XD4_species0,'Color',[1 0 0])
plot(OPENFOAM_XD4_y,OPENFOAM_XD4_species0,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (Experimental)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([0 1.2])
ylim([-0.1 1.2])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('$f$ [-]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile $f$ ($\frac{x}{D}$=4)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD04_f.png","Resolution",600)

figure(19)
hold on
grid on
plot(p15ray_yD,p15ray_species0,'linestyle',':','Marker','o','Color',[0 0 0])
plot(SU2_V1994m_XD15_y,SU2_V1994m_XD15_species0,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD15_y,SU2_V2003m_XD15_species0,'Color',[1 0 0])
plot(OPENFOAM_XD15_y,OPENFOAM_XD15_species0,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (Experimental)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([0 3])
ylim([-0.1 0.6])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('$f$ [-]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile $f$ ($\frac{x}{D}$=15)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD15_f.png","Resolution",600)

figure(20)
hold on
grid on
plot(p30ray_yD,p30ray_species0,'linestyle',':','Marker','o','Color',[0 0 0])
plot(SU2_V1994m_XD30_y,SU2_V1994m_XD30_species0,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD30_y,SU2_V2003m_XD30_species0,'Color',[1 0 0])
plot(OPENFOAM_XD30_y,OPENFOAM_XD30_species0,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (Experimental)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([0 5])
ylim([-0.05 0.3])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('$f$ [-]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile $f$ ($\frac{x}{D}$=30)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD30_f.png","Resolution",600)

figure(21)
hold on
grid on
plot(p50ray_yD,p50ray_species0,'linestyle',':','Marker','o','Color',[0 0 0])
plot(SU2_V1994m_XD50_y,SU2_V1994m_XD50_species0,'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_XD50_y,SU2_V2003m_XD50_species0,'Color',[1 0 0])
plot(OPENFOAM_XD50_y,OPENFOAM_XD50_species0,'Color',[0.4660 0.6740 0.1880])
legend('Schefer (Experimental)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','Interpreter','latex','FontSize',9)
xlim([0 7])
ylim([-0.02 0.2])
xlabel('$\frac{y}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('$f$ [-]', 'Interpreter', 'latex','FontSize',15)
title('Radial profile $f$ ($\frac{x}{D}$=50)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"XD50_f.png","Resolution",600)

figure(22)
hold on
grid on
plot(paxv_xD_jet,(paxv_U_jet-9.2)/(max(paxv_U_jet)-9.2),'linestyle',':','Marker','o','Color',[0 0 0])
plot(paxv_xD_air,(paxv_U_air-9.2)/(max(paxv_U_air)-9.2),'linestyle',':','Marker','diamond','Color',[0 0 0])
plot(SU2_V1994m_YD0_x,(SU2_V1994m_YD0_U-9.2)/(max(SU2_V1994m_YD0_U)-9.2),'Color',[0 0.4470 0.7410])
plot(SU2_V2003m_YD0_x,(SU2_V2003m_YD0_U-9.2)/(max(SU2_V2003m_YD0_U)-9.2),'Color',[1 0 0])
plot(OPENFOAM_YD0_x,(OPENFOAM_YD0_U-9.2)/(max(OPENFOAM_YD0_U)-9.2),'Color',[0.4660 0.6740 0.1880])
plot(MFSim_YD0_x,(MFSim_YD0_U-9.2)/(max(MFSim_YD0_U)-9.2),'Color',[0.9290 0.6940 0.1250])
legend('Schefer (JET)','Schefer (AIR)','SU2 (SST V1994m)','SU2 (SST V2003m)','openFOAM (Realizable k-$\varepsilon$)','MFSim (standard k-e)','Interpreter','latex','FontSize',9)
%xlim([-5 5])
ylim([0 1.1])
xlabel('$\frac{x}{D}$ [-]', 'Interpreter', 'latex','FontSize',15)
ylabel('$\frac{U(x,r)-U_\infty}{U(x,0)-U_\infty} [-]$', 'Interpreter', 'latex','FontSize',15)
title('Axial profile U mean ($\frac{y}{D}$=0)','Interpreter','latex','FontSize',14)
ax = gca;
exportgraphics(ax,"YD0_U_norm.png","Resolution",600)
