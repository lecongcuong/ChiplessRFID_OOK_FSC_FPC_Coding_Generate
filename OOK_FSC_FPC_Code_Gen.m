% Program inputs:

N = 5;          % Number of resonators
M = 3;          % Number of shifted frequencies
F_min = 6.2;    % Lower frequency limit (GHz)
F_max = 7.6;    % Upper frequency limit (GHz)

%%

clc
close all
rng default

fprintf('Code generation processing ...\n')

% On-Off Keying (OOK)
fileCodeOOK = 'OOK_Code_Gen.txt';
fileID = fopen(fileCodeOOK,'a+');
fprintf(fileID, '\n----------------OOK FREQUENCY CODE-----------------\n');
fprintf(fileID, 'Start time: ');
fprintf(fileID, string(datetime('now')));
fprintf(fileID, '\n---------------------------------\n');

Fi = linspace(F_min, F_max, N); 
fprintf(fileID, 'Predetermined set of resonant frequencies:\n Fi = ');
fprintf(fileID, mat2str(Fi,5));
fprintf(fileID, ' (GHz)');
fprintf(fileID, '\n---------------------------------\n');
fprintf(fileID, 'Frequency coding cases:\n');

CodeOOK = 2^N;
for k = 0 : N
    if k == 0
        fprintf(fileID, '[None]\n');
    else 
        Code = nchoosek(Fi,k);
        CodeStr =  mat2str(Code, 5);
        CodeStrList = strrep(CodeStr, ';', '] (GHz)\n[');
        fprintf(fileID, CodeStrList);
        fprintf(fileID, ' (GHz)\n');
    end
end
fprintf(fileID, '\n---------------------------------\n');
fprintf(fileID, 'Number of cases: ');
fprintf(fileID, string(CodeOOK));
fprintf(fileID, '\n---------------------------------\n');
fclose(fileID);

% Frequency-Shifed Coding (FSC)
fileCodeFSC = 'FSC_Code_Gen.txt';
fileID = fopen(fileCodeFSC, 'a+');
fprintf(fileID, '\n----------------FSC FREQUENCY CODE-----------------\n');
fprintf(fileID, 'Start time: ');
fprintf(fileID, string(datetime('now')));
fprintf(fileID, '\n---------------------------------\n');

Fij = linspace(F_min, F_max, N*M); 
fprintf(fileID, 'Resonance frequency of each resonator where zero is no resonance (without the resonator):\n');
Fij_FSC = zeros(N,M+1);
for i = 1 : N
    for j = 1 : (M+1)
        if j == 1
            Fij_FSC(i,j) = 0;
        else
            Fij_FSC(i,j) = Fij((i-1)*M + j-1);
        end
    end
end
CodeStr = mat2str(Fij_FSC,5);
CodeStrList = strrep(CodeStr, ';', '] (GHz)\n[');
fprintf(fileID,CodeStrList);
fprintf(fileID, ' (GHz)\n');
fprintf(fileID, '\n---------------------------------\n');
fprintf(fileID, 'Frequency coding cases:\n');

CodeFSC = (M+1)^N;
Code = combvec(Fij_FSC(1,:));
for j = 2 : N
    Code = combvec(Code, Fij_FSC(j,:));
end
Code = Code';

CodeStr = mat2str(Code, 5);
CodeStrList = strrep(CodeStr, ';', '] (GHz)\n[');
fprintf(fileID, CodeStrList);
fprintf(fileID, ' (GHz)\n');

fprintf(fileID, '\n---------------------------------\n');
fprintf(fileID, 'Number of cases: ');
fprintf(fileID,string(CodeFSC));
fprintf(fileID, '\n---------------------------------\n');
fclose(fileID);


% Frequency-Predetermined Coding (FPC)
fileCodeFPC = 'FPC_Code_Gen.txt';
fileID = fopen(fileCodeFPC, 'a+');
fprintf(fileID, '\n----------------FPC FREQUENCY CODE-----------------\n');
fprintf(fileID, 'Start time: ');
fprintf(fileID, string(datetime('now')));
fprintf(fileID, '\n---------------------------------\n');

Fij = linspace(F_min, F_max, N*M); 
fprintf(fileID, 'Predetermined set of resonant frequencies:\n Fij = ');
fprintf(fileID, mat2str(Fij, 5));
fprintf(fileID, ' (GHz)');
fprintf(fileID, '\n---------------------------------\n');
fprintf(fileID, 'Frequency coding cases:\n');

CodeFPC = 0;
for k = 0 : N
    CodeFPC = CodeFPC + nchoosek(N*M,k);
    if k == 0
        fprintf(fileID, '[None]\n');
    else 
        Code = nchoosek(Fij, k);
        CodeStr = mat2str(Code, 5);
        CodeStrList = strrep(CodeStr, ';', '] (GHz)\n[');
        fprintf(fileID, CodeStrList);
        fprintf(fileID, ' (GHz)\n');
    end
end
fprintf(fileID, '\n---------------------------------\n');
fprintf(fileID, 'Number of cases: ');
fprintf(fileID, string(CodeFPC));
fprintf(fileID, '\n---------------------------------\n');
fclose(fileID);

fprintf('Done! Please check the output files!\n')

