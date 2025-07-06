function Inp_Octet (bigMaterialArray, materials, mat_inf, targetFrequency, nmat, model, F_matrix, radius, nEle, directory, filename)
    
    poissonRatio = 0.35;
    density = 1;
    
    %Loading
    % loadedLoading = load(fullfile(directory, 'F.mat'));
    % F_matrix = loadedLoading.F;
    x_master = [4;0;0];
    y_master = [0;4;0];
    z_master = [0;0;4];
    origin = [0;0;0];

    % Define the input file path
    inputFilePath = [directory,'Octet_Truss_Sets.txt'];
    additionalFilePath = [directory,'Octet_Truss_Equations.txt'];

    % Open the input file for reading
    fid2 = fopen(inputFilePath, 'r');
    fid3 = fopen(additionalFilePath, 'r');

    fid1 = fopen([directory, filename,'.inp'],'w');
    fprintf(fid1,'%s\n', '*Heading');
    fprintf(fid1,'%s\n', '** Job name: octet Model name: Model-1');
    fprintf(fid1,'%s\n', '*Preprint, echo=NO, model=NO, history=NO, contact=NO');
    fprintf(fid1,'%s\n', '**');
    fprintf(fid1,'%s\n', '** PART INSTANCE: Octet');
    fprintf(fid1,'%s\n', '*Node');
    % fprintf(fid1,'%s\n', '      1,           0.,          0.5,          0.5');
    % fprintf(fid1,'%s\n', '      2,           0.,           1.,           1.');
    % fprintf(fid1,'%s\n', '      3,          0.5,           1.,          0.5');
    % fprintf(fid1,'%s\n', '      4,          0.5,          0.5,           0.');
    % fprintf(fid1,'%s\n', '      5,           1.,           0.,           0.');
    % fprintf(fid1,'%s\n', '      6,           1.,          0.5,          0.5');
    % fprintf(fid1,'%s\n', '      7,           1.,           1.,           1.');
    % fprintf(fid1,'%s\n', '      8,           0.,           1.,           0.');
    % fprintf(fid1,'%s\n', '      9,           0.,           0.,           0.');
    % fprintf(fid1,'%s\n', '     10,           0.,           0.,           1.');
    % fprintf(fid1,'%s\n', '     11,          0.5,          0.5,           1.');
    % fprintf(fid1,'%s\n', '     12,          0.5,           0.,          0.5');
    % fprintf(fid1,'%s\n', '     13,           1.,           1.,           0.');
    % fprintf(fid1,'%s\n', '     14,           1.,           0.,           1.');

    fprintf(fid1,'%s\n', '      1,           0.00,          2.00,          2.00');
    fprintf(fid1,'%s\n', '      2,           0.00,          4.00,          4.00');
    fprintf(fid1,'%s\n', '      3,           2.00,          4.00,          2.00');
    fprintf(fid1,'%s\n', '      4,           2.00,          2.00,          0.00');
    fprintf(fid1,'%s\n', '      5,           4.00,          0.00,          0.00');
    fprintf(fid1,'%s\n', '      6,           4.00,          2.00,          2.00');
    fprintf(fid1,'%s\n', '      7,           4.00,          4.00,          4.00');
    fprintf(fid1,'%s\n', '      8,           0.00,          4.00,          0.00');
    fprintf(fid1,'%s\n', '      9,           0.00,          0.00,          0.00');
    fprintf(fid1,'%s\n', '     10,           0.00,          0.00,          4.00');
    fprintf(fid1,'%s\n', '     11,           2.00,          2.00,          4.00');
    fprintf(fid1,'%s\n', '     12,           2.00,          0.00,          2.00');
    fprintf(fid1,'%s\n', '     13,           4.00,          4.00,          0.00');
    fprintf(fid1,'%s\n', '     14,           4.00,          0.00,          4.00');

    if strcmp(model, '3DTruss')
        fprintf(fid1,'%s\n', '*Element, type=T3D2');
    elseif strcmp(model, '3DBeam')
        fprintf(fid1,'%s\n', '*Element, type=B31');
    end
    fprintf(fid1,'%s\n', '1, 1, 2');
    fprintf(fid1,'%s\n', '2, 2, 3');
    fprintf(fid1,'%s\n', '3, 3, 4');
    fprintf(fid1,'%s\n', '4, 4, 5');
    fprintf(fid1,'%s\n', '5, 6, 5');
    fprintf(fid1,'%s\n', '6, 7, 6');
    fprintf(fid1,'%s\n', '7, 3, 7');
    fprintf(fid1,'%s\n', '8, 3, 8');
    fprintf(fid1,'%s\n', ' 9, 4, 8');
    fprintf(fid1,'%s\n', '10, 4, 9');
    fprintf(fid1,'%s\n', '11, 1, 9');
    fprintf(fid1,'%s\n', '12,  1, 10');
    fprintf(fid1,'%s\n', '13, 8, 1');
    fprintf(fid1,'%s\n', '14,  2, 11');
    fprintf(fid1,'%s\n', '15, 3, 1');
    fprintf(fid1,'%s\n', '16, 3, 6');
    fprintf(fid1,'%s\n', '17, 12,  6');
    fprintf(fid1,'%s\n', '18, 12, 11');
    fprintf(fid1,'%s\n', '19,  1, 11');
    fprintf(fid1,'%s\n', '20, 12,  5');
    fprintf(fid1,'%s\n', '21, 12, 10');
    fprintf(fid1,'%s\n', '22, 11, 10');
    fprintf(fid1,'%s\n', '23, 11,  7');
    fprintf(fid1,'%s\n', '24,  3, 13');
    fprintf(fid1,'%s\n', '25, 4, 1');
    fprintf(fid1,'%s\n', '26, 13,  4');
    fprintf(fid1,'%s\n', '27,  6, 13');
    fprintf(fid1,'%s\n', '28,  6, 14');
    fprintf(fid1,'%s\n', '29, 14, 12');
    fprintf(fid1,'%s\n', '30, 12,  4');
    fprintf(fid1,'%s\n', '31, 6, 4');
    fprintf(fid1,'%s\n', '32, 11,  6');
    fprintf(fid1,'%s\n', '33,  9, 12');
    fprintf(fid1,'%s\n', '34,  3, 11');
    fprintf(fid1,'%s\n', '35, 11, 14');
    fprintf(fid1,'%s\n', '36, 12,  1');

    % Read the sets
    while ~feof(fid2)
        line = fgetl(fid2);  % Read a line from the input file
        if ischar(line)      % Check if the line was read successfully
            fprintf(fid1, '%s\n', line);  % Write the line to the output file
        end
    end

%%
    % Initialize a cell array to store locations for each unique material
    UniqueMaterials = unique(bigMaterialArray);
    
    
    if strcmp(model, '3DTruss')
        for i=1:nEle
            fprintf(fid1,'%s\n', ['** Section: Section-', num2str(i)]);
            fprintf(fid1,'%s\n', ['*Solid Section, elset=Set', num2str(i), ', material=Material-', num2str(bigMaterialArray(i))]);
            fprintf(fid1,'%s\n', [num2str((pi*radius^2)),',']);
        end
    elseif strcmp(model, '3DBeam')
        for i=1:nEle
            fprintf(fid1,'%s\n', ['** Section: Section-', num2str(i), '  Profile: Profile-1']);
            fprintf(fid1,'%s\n', ['*Beam Section, elset=Set', num2str(i), ', material=Material-', num2str(bigMaterialArray(i)), ', temperature=GRADIENTS, section=CIRC']);
            fprintf(fid1,'%s\n', [num2str(radius),',']);
            fprintf(fid1,'%s\n', '0.,0.,-1.');
        end
    end

    % load equations for applying priodicity

    while ~feof(fid3)
        line = fgetl(fid3);  % Read a line from the additional file
        if ischar(line)      % Check if the line was read successfully
            fprintf(fid1, '%s\n', line);  % Write the line to the output file
        end
    end

    fprintf(fid1,'%s\n', '** ');
    fprintf(fid1,'%s\n', '** MATERIALS');
    fprintf(fid1,'%s\n', '** ');

    %Create materials
    for i=1:numel(UniqueMaterials)
        fprintf(fid1,'%s\n', ['*Material, name=MATERIAL-',num2str(UniqueMaterials(i))]);
        fprintf(fid1,'%s\n', '*Density');
        fprintf(fid1,'%s\n', [num2str(density),',']);

        MasterCurveData = materials(UniqueMaterials(i),:);
        materialNumber = mod(UniqueMaterials(i), nmat);
        if materialNumber == 0
            materialNumber = nmat;
        end

        [ViscoelasticTable, Young]=TabularViscoelastic(MasterCurveData(:,1), complex(MasterCurveData(:,2), MasterCurveData(:,3)), poissonRatio, mat_inf(materialNumber,:));

        %make a file to save the material data for the ones that are used in the code
        fprintf(fid1,'%s\n', '*Elastic, moduli=LONG TERM');
        fprintf(fid1,'%s\n', [num2str(Young),', ',num2str(poissonRatio)]);
        fprintf(fid1,'%s\n', '*Viscoelastic, frequency=TABULAR');

        [numRows, numCols] = size(ViscoelasticTable);
        formatSpec = repmat('%e, ', 1, numCols); % Use '%e' for scientific notation
        formatSpec = [formatSpec(1:end-2), '\n']; % Remove the last comma and add a newline

        for rowNumber = 1:numRows
            fprintf(fid1, formatSpec, ViscoelasticTable(rowNumber, :));
        end

    end

    fprintf(fid1,'%s\n', '** ----------------------------------------------------------------');
    fprintf(fid1,'%s\n', '**');
    fprintf(fid1,'%s\n', '** STEP: Step-1');
    fprintf(fid1,'%s\n', '** ');
    fprintf(fid1,'%s\n', '*Step, name=Step-1, nlgeom=NO, perturbation');
    fprintf(fid1,'%s\n', '*Steady State Dynamics, direct, friction damping=NO');
    fprintf(fid1,'%s\n', [num2str(targetFrequency),', ', num2str(targetFrequency+1), ', 2,']);

    fprintf(fid1,'%s\n', '** ');
    fprintf(fid1,'%s\n', '** BOUNDARY CONDITIONS');
    fprintf(fid1,'%s\n', '** ');
    
    %loading with deformation gradient tensor
    u_masterx = (F_matrix - eye(3))*x_master;
    u_mastery = (F_matrix - eye(3))*y_master;
    u_masterz = (F_matrix - eye(3))*z_master;
    u_origin = (F_matrix - eye(3))*origin;

    BC_number = 0;
    BC_number = BC_number + 1;
    fprintf(fid1,'%s\n', ['** Name: BC-',num2str(BC_number),' Type: Displacement/Rotation']);
    fprintf(fid1,'%s\n', '*Boundary, real');
    for i = 1:length(u_masterx)
        fprintf(fid1, '%s\n', ['N7, ',num2str(i),', ', num2str(i),', ', num2str(u_masterx(i))]);
    end

    BC_number = BC_number + 1;
    fprintf(fid1,'%s\n', ['** Name: BC-',num2str(BC_number),' Type: Displacement/Rotation']);
    fprintf(fid1,'%s\n', '*Boundary, real');
    for i = 1:length(u_mastery)
        fprintf(fid1, '%s\n', ['N12, ',num2str(i),', ', num2str(i),', ', num2str(u_mastery(i))]);
    end

    BC_number = BC_number + 1;
    fprintf(fid1,'%s\n', ['** Name: BC-',num2str(BC_number),' Type: Displacement/Rotation']);
    fprintf(fid1,'%s\n', '*Boundary, real');
    for i = 1:length(u_masterz)
        fprintf(fid1, '%s\n', ['N1, ',num2str(i),', ', num2str(i),', ', num2str(u_masterz(i))]);
    end

    fprintf(fid1,'%s\n', '** ');
    fprintf(fid1,'%s\n', '** OUTPUT REQUESTS');
    fprintf(fid1,'%s\n', '** ');
    fprintf(fid1,'%s\n', '** ');
    fprintf(fid1,'%s\n', '** FIELD OUTPUT: F-Output-1');
    fprintf(fid1,'%s\n', '** ');
    fprintf(fid1,'%s\n', '*Output, field');
    fprintf(fid1,'%s\n', '*Node Output, variable=PRESELECT');
    fprintf(fid1,'%s\n', '*Element Output, directions=YES');
    fprintf(fid1,'%s\n', 'ELEDEN, ELEN, ENER, LE, S');
    fprintf(fid1,'%s\n', '** ');
    fprintf(fid1,'%s\n', '** HISTORY OUTPUT: H-Output-1');
    fprintf(fid1,'%s\n', '** ');
    fprintf(fid1,'%s\n', '*Output, history');
    fprintf(fid1,'%s\n', '*Energy Output, variable=ALL');
    fprintf(fid1,'%s\n', '*End Step');

    fclose(fid1);
    fclose(fid2);
    fclose(fid3);
end