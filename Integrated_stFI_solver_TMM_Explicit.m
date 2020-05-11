clear;

global EPSILON
global DIM
global DISPDEBUGGINGMESSAGE
global DISPCAUTIONMESSAGE
global DOEIGVANALYSIS

EPSILON = 10^(-7)
DIM = 2; %number of spatial dimensions: DO NOT CHANGE unless you rewrited the codes for 3D analysis
DISPCAUTIONMESSAGE =true
DISPDEBUGGINGMESSAGE = true
DOEIGVANALYSIS =false

%% Spatial Meshing and Impedance for belt-like subgrid region with triangle faces 

% Img_MeshMeasLocation=imread('MeshMeasurements_triangle_belt.png');
% image(Img_MeshMeasLocation)
% MeshMeasurements=MeshMeasurements_100times100_withTriangle;
% MeshParam = MeshParameters_triangle_belt(MeshMeasurements);
% MeshParam.deltatriangle=0.1;
% MeshParam.deltaboundary=1.0/12.0;
% UpdateNum_belt=2;
% [sC,sG,UpdateNum,edgevec,first_pIdx,tilde_node_position,MeshNum,MeshParam] ...
%     = GenerateMesh_triangular_belt(UpdateNum_belt,MeshParam);

% first_i_triangle_scatterer=20;
% ImpedanceParam.freespace=1.0;
% ImpedanceParam.medium=0.01;
% Zinv_p ...
%     = Impedance_TriangleScatterer(ImpedanceParam,first_i_triangle_scatterer,sC,UpdateNum,first_pIdx,MeshNum,MeshParam);

% disp('Initial conditions: Gaussian Distribution of Bz, centered at the Dead center of the mesh')
% gauss_center.x=MeshParam.Size_X/2.0;
% gauss_center.y=0.5*(MeshParam.Fine_Y_from-1 ...
%     +(MeshParam.Fine_Y_to-MeshParam.Fine_Y_from+1)/2.0...
%     +(MeshParam.Size_Y-MeshParam.Fine_Y_to));

%% Spatial Meshing and Impedance for belt-like subgrid region only with square faces

% Img_MeshMeasLocation=imread('MeshMeasurements_square_belt.png');
% image(Img_MeshMeasLocation)
% % MeshMeasurements=MeshMeasurements_100times100_SquareBelt_belt65to85;
% 
% %% test
% 
% MeshMeasurements.XCoord=10;
% MeshMeasurements.YCoord=10;
% MeshMeasurements.FineStartAtYCoord=6;
% MeshMeasurements.FineEndAtYCoord=8;
% 
% ScattererMeasurements.FromXCoord=6.5;
% ScattererMeasurements.ToXCoord=7.5;
% ScattererMeasurements.FromYCoord=6.5;
% ScattererMeasurements.ToYCoord=7.5;
% 
% GaussParam.Ampl=1;
% GaussParam.relaxfact=1;
% 
% %% end test
% MeshParam = MeshParameters_square_belt(MeshMeasurements);
% MeshParam.deltaboundary=1.0/12.0;
% UpdateNum_belt=2;
% [sC,sG,UpdateNum,edgevec,first_pIdx,tilde_node_position,MeshNum,MeshParam] ...
%     = GenerateMesh_square_belt(UpdateNum_belt,MeshParam);
% 
% % ScattererMeasurements.FromXCoord=17;
% % ScattererMeasurements.ToXCoord=33;
% % ScattererMeasurements.FromYCoord=67;
% % ScattererMeasurements.ToYCoord=83;
% ImpedanceParam.freespace=1.0;
% ImpedanceParam.medium=1.0;
% %ImpedanceParam.medium=0.01;
% %Zinv_p=ones(MeshNum.P,1);
%  Zinv_p...
%      = Impedance_SquareScatterer_BeltlikeSubgrid(ImpedanceParam,ScattererMeasurements,sC,UpdateNum,first_pIdx,MeshNum,MeshParam,MeshMeasurements);
% disp('Initial conditions: Gaussian Distribution of Bz, centered at the Dead center of the mesh')
% gauss_center.x=MeshParam.Size_X/2.0;
% gauss_center.y=0.5*(MeshParam.Fine_Y_from-1 ...
%     +(MeshParam.Fine_Y_to-MeshParam.Fine_Y_from+1)/2.0...
%     +(MeshParam.Size_Y-MeshParam.Fine_Y_to));

%% Spatial Meshing and Impedance for square-like subgrid region only with square faces

%Img_MeshMeasLocation=imread('MeshMeasurements_square_belt.png');
%image(Img_MeshMeasLocation)
% MeshMeasurements=MeshMeasurements_100times100_SquareBelt_belt65to85;

%% test

MeshMeasurements.XCoord=100;
MeshMeasurements.YCoord=100;
MeshMeasurements.FineStartAtXCoord=15;
MeshMeasurements.FineEndAtXCoord=35;
MeshMeasurements.FineStartAtYCoord=15;
MeshMeasurements.FineEndAtYCoord=35;

ScattererMeasurements.FromXCoord=20;
ScattererMeasurements.ToXCoord=30;
ScattererMeasurements.FromYCoord=20;
ScattererMeasurements.ToYCoord=30;

GaussParam.Ampl=1;
GaussParam.relaxfact=10;

%% end test
MeshParam = MeshParameters_squarefaces_squaresubgrid(MeshMeasurements);
MeshParam.deltaboundary=1.0/12.0;
MeshParam.deltacorner=0;
UpdateNum_subgrid=2;
[sC,sG,UpdateNum,edgevec,first_pIdx,tilde_f,MeshNum,MeshParam] ...
    = GenerateMesh_squarefaces_squaresubgrid(UpdateNum_subgrid,MeshParam);

% ScattererMeasurements.FromXCoord=17;
% ScattererMeasurements.ToXCoord=33;
% ScattererMeasurements.FromYCoord=67;
% ScattererMeasurements.ToYCoord=83;
ImpedanceParam.freespace=1.0;
ImpedanceParam.medium=0.01;
%ImpedanceParam.medium=0.01;
%Zinv_p=ones(MeshNum.P,1);
 Zinv_p...
     = Impedance_SquareScatterer(ImpedanceParam,ScattererMeasurements,sC,UpdateNum,first_pIdx,MeshNum,MeshParam,MeshMeasurements);
disp('Initial conditions: Gaussian Distribution of Bz, centered at the Dead center of the mesh')
gauss_center.x=0.5*MeshMeasurements.XCoord;
gauss_center.y=0.5*MeshMeasurements.YCoord;

%% Calculate Constitutive Equation

% Future tasks; modify att into nested structures like att.e(e).bound
att = attribute_f_and_e(sC,sG,UpdateNum, MeshNum);

cdt=0.51;

% Future tasks; adapt Constitutive to partially non-orthogonal grids:DONE
% but not been tested yet
% Future tasks; adapt Constitutive to subgrid corners
% Future tasks; utilize spatial-FI-like calculation in Constitutive
disp('Constitutive: CALLING')
[kappa,b_area,att,MeshNum]=Constitutive(cdt,sC,sG,UpdateNum,edgevec,first_pIdx,att,MeshNum);
disp('Constitutive: ENDED')
kappaoverZ=kappa.*Zinv_p;

%% calculating initial distribution

% GaussParam.Ampl=1;
% GaussParam.relaxfact=10;

InitVal ...
    =GaussianDistributBz(GaussParam,tilde_f,b_area,MeshNum,gauss_center);

%% Obtain Time-marching Matrix 

% #4: combine both space-time and spatial FI in order to make the size of D
% small
disp('Divide_into_induced_subgraphs:CALLING')
[subG_bin,subG_sizes,allIdx_stFI,UpdateNum] ...
    = Divide_into_induced_subgraphs(sC,UpdateNum,MeshNum,att);
disp('Divide_into_induced_subgraphs:ENDED')

% task: allocate TMM beforehand to reduce overheads
[Taskorder,task,D,Ctrans] ...
    = Obtain_TaskOrderandIncMat(sC,UpdateNum,allIdx_stFI,subG_bin,subG_sizes,att,first_pIdx,MeshNum);

D_tildeD_Zinv=[D;Ctrans * spdiags(kappaoverZ,0,MeshNum.P,MeshNum.P)];
clearvars D Ctrans

disp('Construct_TMM_Explicit:CALLING')
[TMM_Explicit] ...
    = Construct_TMM_Explicit(Taskorder,task,D_tildeD_Zinv,kappaoverZ,sC,UpdateNum,subG_bin,first_pIdx,MeshNum);
disp('Construct_TMM_Explicit:ENDED')

%% Execute Explicit Calculation 

time=0;
variables_f_then_e=[InitVal.f; InitVal.e];

number_of_steps=1000000

CalPeriod=cdt * number_of_steps;
disp(['Executing Calculation: from ct = ',num2str(time), ' to ct = ',num2str(time+CalPeriod)])

time = time + CalPeriod;
[variables_f_then_e] ...
    = execution_with_TMM_Explicit(TMM_Explicit,variables_f_then_e,number_of_steps);

b_f = variables_f_then_e(1:MeshNum.F);
disp(['plotting Bz at ct = ', num2str(time)])
plot_bface_general(b_f,b_area,tilde_f,MeshParam,MeshNum)

%% Eigenvalue Analysis
if DOEIGVANALYSIS ==true
    disp('Calculating Eigenvalues')
    
    eigenvalues = eigs(TMM_Explicit,100,'largestabs');
    figure
    theta = linspace(0,2*pi);
    x = cos(theta);
    y = sin(theta);
    eigv_re=real(eigenvalues);
    eigv_im=imag(eigenvalues);
    plot(eigv_re,eigv_im,'or',x,y,'-b')
    axis equal
    EigValAbs=abs(eigenvalues);
    EigvEpsilon=10^(-7);
    IdxUnstabEigVal=find(EigValAbs>1+EigvEpsilon);
    if size(IdxUnstabEigVal,1)==0
        disp(['stable for cdt = ',num2str(cdt),' (EigvEpsilon = ',num2str(EigvEpsilon),')'])
        %disp(EigValAbs)
    else
        disp(['unstable for cdt = ',num2str(cdt),' (EigvEpsilon = ',num2str(EigvEpsilon),')'])
        %disp(EigValAbs)
    end
end

%% Error to Conventional stFI

%b_error=b_reduced-b_obi;
%plot_bface_general(b_error,b_area,tilde_node_position,Size_X,Size_Y,FNum)


%% far-future tasks
% include PML, PEC tasks.