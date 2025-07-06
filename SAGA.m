clc;
clear;
close all;

% Start the timer
tic;

% Initialize the parallel pool
parpool;

%% Model parameters
model = '3DTruss'; %3DBeam or 3DTruss
geometry = 'Truncated_Octahedron'; % Octet or Truncated_Octahedron or bending1

% number of elements
if strcmp(geometry, 'Truncated_Octahedron')
    nEle = 36;
elseif strcmp(geometry, 'Octet')
    nEle = 36;
elseif strcmp(geometry, 'Bending1')
    nEle = 625;
end

directory = '/home/rkm41/Desktop/Final/';
% directory = 'C:\Users\BrinsonLab\Desktop\DataDrivenViscoelasticity\Codes\Heterogeneous\';
filename0 = ['SAGA_',geometry,'_',model];

% Load
LoadCase = 1;
if LoadCase == 1
    F = [1 0.01 0; 0.01 1 0; 0 0 1];
    filename = [filename0,'_PureShearXY'];
elseif LoadCase == 2
    F = [1.01 0 0; 0 1 0; 0 0 1];
    filename = [filename0,'_UniaxialTensionX'];
elseif LoadCase == 3
    F = [0.99 0 0; 0 0.99 0; 0 0 0.99];
    filename = [filename0,'_IsotropicCompression'];
elseif LoadCase == 4
    F = [1 0.01 0; 0 1 0; 0 0 1];
    filename = [filename0,'_SimpleShearXY'];
elseif LoadCase == 5
    F = [0 0 0; 0 0 0; 0 0 0];
    filename = filename0;
end

% number of materials
nmat = 25;

% allowedMaterials = [1, 10, 15];
allowedMaterials = 1:nmat;

% targetElements = [1, 2, 3, 12, 13, 14, 15, 16, 17, 40, 41, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 166, 167, 168, 169, 170, 171, 172, 173, 177, 196, 197, 198, 199, 200, 226, 227, 243, 244, 245, 246, 247, 248, 249, 250, 263, 264, 265, 266, 267, 293, 294, 310, 311, 312, 313, 314, 315, 316, 317, 330, 331, 332, 333, 334, 335, 336, 337, 349, 350, 358, 359, 360, 361, 362, 363, 372, 383, 384, 385, 396, 405, 406, 407, 433, 442, 443, 444, 470, 479, 494, 495, 496, 502, 503, 504, 505, 506, 507, 508, 509, 510, 518, 525, 526, 527, 531, 532, 533, 534, 535, 536, 538, 539, 549, 550, 551, 552, 553, 554, 555, 556, 557, 565, 572, 573, 574, 578, 579, 580, 581, 583, 584, 591, 592, 617, 618, 621, 622];
targetElements = 1:nEle;

% Making the place holder materials
% MakeMaterials(nmat, directory)

%% Problem Definition

nVar=nEle;            % Number of Decision variables

VarSize=[1 nVar];   % Variables Martix Size

%% GA Parameters

MaxIt=1;        % Maximum Number of Iterations

MaxSubIt=3;       % Maimum Number of Sub-iterations

T0=10;             % Initial Temp.

alpha=0.99;        % Temp. Reduction Rate

nPop=4;           % Population Size

pc=0.7;                   % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number fo Parents (Offsprings)

pm=0.2;                   % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

gamma=0.4;              % Crossover Inflation Rate

mu=0.15;                 % Mutation Rate

MutationMode='rand';    % Mutation Mode

TournamentSize=3;   % Tournamnet Size

%% Initialization

global NFE;
NFE=0;

% Create Empty Structure
empty_individual.Position=[];
empty_individual.Cost=[];

% Create Structre Array to Save Population Data
pop=repmat(empty_individual,nPop,1);

% Initilize Population
parfor i=1:nPop
    % Initialize Position
    matNumArray = ones(nEle, 1) * allowedMaterials(2);
   
    matNumArray(targetElements) = allowedMaterials(randi(length(allowedMaterials), [numel(targetElements), 1]));
   
    % matNumArray = randi([1 nmat], [nEle, 1]);
    bigMaterialArray = matNumArray;
    pop(i).Position = matNumArray;
    % Evaluation
    pop(i).Cost=MaxDissipation(nmat, model, geometry, F, pop(i).Position, pop(i).Position, directory, [filename,num2str(i)], nEle);
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs, 'descend');
pop=pop(SortOrder);

% Store Best Solution Ever Found
BestSol=pop(1);

% Store Worst Solution Ever Found
WorstSol=pop(end);

% Create Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Create Array to Hold NFEs
nfe=zeros(MaxIt,1);

% Initialize Temp.
T=T0;


%% GA Main Loop

for it=1:MaxIt
    
    for subit=1:MaxSubIt

        % Perform Crossover
        popc1 = repmat(empty_individual, nc/2, 1);  % Initialize popc1 with length nc/2
        popc2 = repmat(empty_individual, nc/2, 1);  % Initialize popc2 with length nc/2
        
        parfor k = 1:nc/2
            i1 = TournamentSelection(pop, TournamentSize);
            i2 = TournamentSelection(pop, TournamentSize);
        
            % Select Parents
            p1 = pop(i1);
            p2 = pop(i2);
        
            % Apply Crossover
            [child1Pos, child2Pos] = CrossoverBending(p1.Position, p2.Position, targetElements);
        
            % Evaluate Offsprings
            child1Cost = MaxDissipation(nmat, model, geometry, F, child1Pos, child1Pos, directory, [filename, num2str(k), '_1'], nEle);
            child2Cost = MaxDissipation(nmat, model, geometry, F, child2Pos, child2Pos, directory, [filename, num2str(k), '_2'], nEle);
        
            % Store results in popc1 and popc2 arrays
            popc1(k).Position = child1Pos;
            popc1(k).Cost = child1Cost;
            popc2(k).Position = child2Pos;
            popc2(k).Cost = child2Cost;
        end
        % Merge popc1 and popc2 into popc
        popc = [popc1; popc2];

        % Perform Mutation
        popm=repmat(empty_individual,nm,1);
        parfor l=1:nm

            % Select Parent
            i=randi([1 nPop]);
            p=pop(i);

            % Apply Mutation
            popm(l).Position=MutateBending(p.Position, mu, allowedMaterials, targetElements);

            % Evaluate Mutant
            popm(l).Cost=MaxDissipation(nmat, model, geometry, F, popm(l).Position, popm(l).Position, directory, [filename, num2str(l)], nEle);

        end

        % Perform Neighbor Creation
        popn=repmat(empty_individual,nm,1);
        parfor l=1:nm

            % Select Parent
            i=randi([1 nPop]);
            p=pop(i);

            % Perform Neighbor Creation
            popn(l).Position=CreateNeighborBending(p.Position, targetElements);

            % Evaluate Neighbor
            popn(l).Cost=MaxDissipation(nmat, model, geometry, F, popn(l).Position, popn(l).Position, directory, [filename, num2str(l)], nEle);


        end
        
        % Merge Offsprings Population
        newpop=[popc
                popm
                popn];
        
        % Sort NEWPOP
        [~, SortOrder]=sort([newpop.Cost], 'descend');
        newpop=newpop(SortOrder);
        
        % Compare using SA Rule
        for i=1:nPop
            
            if newpop(i).Cost>=pop(i).Cost
                pop(i)=newpop(i);
                
            else
                DELTA=(newpop(i).Cost-pop(i).Cost)/pop(i).Cost;
                P=exp(DELTA/T);
                if rand<=P
                    pop(i)=newpop(i);
                end
            end
        
            % Update Best Solution Ever Found
            if pop(i).Cost>=BestSol.Cost
                BestSol=pop(i);
            end

            % Update Worst Solution Ever Found
            if pop(i).Cost<=WorstSol.Cost
                WorstSol=pop(i);
            end
            
        end
        
    end
    
    % Store Best Cost
    BestCost(it)=BestSol.Cost;
    
    % Store NFE
    nfe(it)=NFE;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ...
          ': Best Cost = ' num2str(BestCost(it)) ...
          ', NFE = ' num2str(nfe(it))]);
    
    % Temp. Reduction
    T=alpha*T;
      
end

%% Results

% Stop the timer and store the elapsed time in RunTime
RunTime = toc;

delete(gcp('nocreate'));

save(filename)

disp(nfe)
figure;
plot([1:length(BestCost)],BestCost,'LineWidth',2);
xlabel('Generation');
ylabel('Max ALLHDE');
