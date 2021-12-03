clear all 
close all
clc
%% Lectura de todos los archivos
% for i = 1:10
%     s(i) = strcat("Libro",int2str(i),".xlsx");
%     a{i,1} = readtable(s(i),'PreserveVariableNames',true);
% end

%% Analisis de los archivos
% 
% * Lecturas de electrocardiogramas 
% * Sistema Estadistico del Sector Afianzador
% * Empresas
% * Centros de acopio
% * Daños y derrumbes
% * Centros de acopio
% * Albergues 
% * Daños
% * Reportes 911
% * Derrumbes
% 

%% Centros de acopio
i = 4;
s(i) = strcat("Libro",int2str(i),".xlsx");
n = readcell(s(i),'Range','D2:D337');   % Nececidades
a = readmatrix(s(i),'Range','R2:S337'); % Cordenadas
%%

r = replace(n,',',' ');
r = lower(r);
r = replace(r,' de ',' ');
r = replace(r,' para ',' ');
r = replace(r,' en ',' ');
g = preprocessText (r);             % Pre procesa el texto
documentos = tokenizedDocument (r); % Crea colecciones de palabras en celdas
bag = bagOfWords (documentos)       % contador de frecuencia de términos
numTopics = 3;

mdl = fitlda(bag,numTopics);
% figure
% for topicIdx = 1:numTopics
%     figure(topicIdx)
%     wordcloud(mdl,topicIdx);
%     title("Topic: " + topicIdx)
% end



