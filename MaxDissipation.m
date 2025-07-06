function totalDampingEnergy= MaxDissipation (nmat, model, geometry, F, bigMaterialArray, matNumArray, directory, filename, nEle)
    
    %%
    global NFE;
    if isempty(NFE)
        NFE=0;
    end
    NFE=NFE+1;

    %% inputs
    
    % number of the near frequencies
    nearFrq = 2;
    
    % target frequency range
%     targetFrequencyRange = [10, 50, 100, 500, 1000]; % Hz
    targetFrequencyRange = [5]; % Hz
      
    % Number of iterations
    maxIt = 150;
    
    %Beam/Truss radius
    radius = 0.15; % 0.01 mm
    % area = 3.14e-06; %mm^2
      
    % Read materials data
    [allMasterCurves, mat_inf] = Read_Material3D_Truss(nmat, directory);
        
    % Remove duplicates from matNumArray while preserving the order
    uniqueMatNumArray = unique(matNumArray);
    
    % Initialize the selectedMasterCurves cell array
    selectedMasterCurves = cell(size(uniqueMatNumArray));
    
    % Loop through uniqueMatNumArray to select the corresponding master curves
    for i = 1:numel(uniqueMatNumArray)
        selectedMasterCurves{i} = allMasterCurves{uniqueMatNumArray(i)};
    end
    
    for ifrq = 1: length(targetFrequencyRange)
        disp(['Frequency ',num2str(targetFrequencyRange(ifrq))])
        targetFrequency = targetFrequencyRange(ifrq);
        materials = material3D_Target_Properties_Truss(allMasterCurves, nmat, nearFrq, targetFrequency);
        % call a function to make the abaqus input file
        if strcmp(geometry, 'Truncated_Octahedron')
            Inp_Truncated_Octahedron(bigMaterialArray, materials, mat_inf, targetFrequency, nmat, model, F, radius, nEle, directory, [filename,'_',num2str(ifrq),'_',num2str(0)]);
        elseif strcmp(geometry, 'Octet')
            Inp_Octet(bigMaterialArray, materials, mat_inf, targetFrequency, nmat, model, F, radius, nEle, directory, [filename,'_',num2str(ifrq),'_',num2str(0)]);
        elseif strcmp(geometry, 'Bending1')
            BendingStructure1(bigMaterialArray, materials, mat_inf, targetFrequency, nmat, model, radius, nEle, directory, [filename,'_',num2str(ifrq),'_',num2str(0)]);
        end
        % running the input file
    
        system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus job=', [filename,'_',num2str(ifrq),'_',num2str(0)],' input=', directory, [filename,'_',num2str(ifrq),'_',num2str(0)],'.inp interactive ask_delete=OFF']);
    
        % exporting stress and strain values
        if strcmp(model, '3DTruss')
            system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus python ',directory, 'ResultsExtractor.py ',[directory,filename,'_',num2str(ifrq),'_',num2str(0)], ' ', num2str(targetFrequency)]);
        elseif strcmp(model, '3DBeam')
            system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus python ',directory, 'ResultExtrator3D_Beam.py ',[directory,filename,'_',num2str(ifrq),'_',num2str(0)], ' ', num2str(targetFrequency)]);
        end
        StressData = dlmread([directory,filename,'_',num2str(ifrq),'_', num2str(0), '_Stress.txt'], '\t', 1, 0);
        S_fr = StressData(1:nEle,:); % StressData at TargetFrequency
        StrainData = dlmread([directory,filename,'_',num2str(ifrq),'_', num2str(0), '_Strain.txt'], '\t', 1, 0);
        E_fr = StrainData(1:nEle,:); % StrainData at TargetFrequency
    
        %% DD Solver
        for it=1:maxIt
    
            convergence = true;
    
            % iterating on the elements
            for eln = 1: nEle
                materialNumberElement = mod(bigMaterialArray(eln), nmat);
                if materialNumberElement == 0
                    materialNumberElement = nmat;
                end
                matArray = materialNumberElement:nmat:nmat*nearFrq;
                ElementMaterialPoints = materials(matArray,:);
                [C, cutoff] = findDDVparameters(ElementMaterialPoints);
    
                if strcmp(model, '3DTruss')
                    S = [complex(S_fr(eln,2),S_fr(eln,3)); complex(0,0); complex(0,0); complex(0,0); complex(0,0); complex(0,0)];
                    E = [complex(E_fr(eln,2),E_fr(eln,3)); complex(0,0); complex(0,0); complex(0,0); complex(0,0); complex(0,0)];
                elseif strcmp(model, '3DBeam')
                    S = [complex(S_fr(eln,2),S_fr(eln,3)); complex(0,0); complex(0,0); complex(S_fr(eln,4),S_fr(eln,5)); complex(0,0); complex(0,0)];
                    E = [complex(E_fr(eln,2),E_fr(eln,3)); complex(0,0); complex(0,0); complex(E_fr(eln,4),E_fr(eln,5)); complex(0,0); complex(0,0)];
                end
    
                matn=bigMaterialArray(eln);  % material number
    
                matMin = matn;
                dist_min=distance(E, S, targetFrequency, complex(materials(matn,2),materials(matn,3)), materials(matn,1), C, cutoff);
    
                newMatArray = matArray(matArray ~= matn);  % Remove the chosen number
    
                for l= newMatArray
    
                    dist_new=distance(E, S, targetFrequency, complex(materials(l,2),materials(l,3)), materials(l,1), C, cutoff);
    
                    if (dist_new < dist_min)
                        matMin = l;
                        dist_min = dist_new;
                    end
                end
    
                if ( complex(materials(matn,2),materials(matn,3)) ~= complex(materials(matMin,2),materials(matMin,3)))
                    convergence = false;
                    bigMaterialArray(eln) = matMin;
                    materialNumber = mod(matMin, nmat);
                    if materialNumber == 0
                        materialNumber = nmat;
                    end
                    matNumArray(eln) = materialNumber;
    
                end
    
            end
            if convergence
                break
            end

            % call a function to make the abaqus input file
            if strcmp(geometry, 'Truncated_Octahedron')
                Inp_Truncated_Octahedron(bigMaterialArray, materials, mat_inf, targetFrequency, nmat, model, F, radius, nEle, directory, [filename,'_',num2str(ifrq),'_',num2str(it)]);
            elseif strcmp(geometry, 'Octet')
                Inp_Octet(bigMaterialArray, materials, mat_inf, targetFrequency, nmat, model, F, radius, nEle, directory, [filename,'_',num2str(ifrq),'_',num2str(it)]);
            elseif strcmp(geometry, 'Bending1')
                BendingStructure1(bigMaterialArray, materials, mat_inf, targetFrequency, nmat, model, radius, nEle, directory, [filename,'_',num2str(ifrq),'_',num2str(it)]);
            end

            system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus job=', [filename,'_',num2str(ifrq),'_',num2str(it)],' input=', directory, [filename,'_',num2str(ifrq),'_',num2str(it)],'.inp interactive ask_delete=OFF']);
            if strcmp(model, '3DTruss')
                system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus python ',directory, 'ResultsExtractor.py ',[directory,filename,'_',num2str(ifrq),'_',num2str(it)], ' ', num2str(targetFrequency)]);
            elseif strcmp(model, '3DBeam')
                system(['/var/DassaultSystemes/SIMULIA/Commands/abaqus python ',directory, 'ResultExtrator3D_Beam.py ',[directory,filename,'_',num2str(ifrq),'_',num2str(it)], ' ', num2str(targetFrequency)]);
            end

            StressData = dlmread([directory,filename,'_',num2str(ifrq),'_', num2str(it), '_Stress.txt'], '\t', 1, 0);
            S_fr = StressData(1:nEle,:); % StressData at TargetFrequency
            StrainData = dlmread([directory,filename,'_',num2str(ifrq),'_', num2str(it), '_Strain.txt'], '\t', 1, 0);
            E_fr = StrainData(1:nEle,:); % StrainData at TargetFrequency
    
        end
        EnergyData = dlmread([directory,filename,'_',num2str(ifrq),'_', num2str(it-1), '_Energy.txt'], '\t', 1, 0);
        ALLHDE_fr = EnergyData(1,:); % EnergyData at TargetFrequency
        dampingEnergy(ifrq) = ALLHDE_fr(1,2);
    end

    totalDampingEnergy = sum(dampingEnergy);
end