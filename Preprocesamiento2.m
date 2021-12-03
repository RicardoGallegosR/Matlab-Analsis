clear all
close all
clc
i = 4;
s(i) = strcat("Libro",int2str(i),".xlsx");
n = readcell(s(i),'Range','D2:D337');   % Nececidades
a = readmatrix(s(i),'Range','R2:S337'); % Cordenadas
%%
% Preprocesamiento de texto
documents = preprocessText(n);

% Devuelve el numero de enteros de documents
numDocuments = numel(documents);

%% Contador de frecuencia 
% Un modelo de bolsa de palabras 
% (también conocido como contador de frecuencia de términos) registra el 
% número de veces que aparecen palabras en cada documento de una colección.
bag = bagOfWords(documents);
% Elimina las palabras que no aparezcan más de dos veces en total. 
bag = removeInfrequentWords(bag,2);
% Elimine cualquier documento que no contenga palabras.
bag = removeEmptyDocuments(bag);

%% Calculo de la minima perplejidad 
% minPerplexity (bag,documents,20,length(bag.Counts));
% minPerplexity (bag,documents,20,101);
% minPerplexity (bag,documents,10,51);
validationPerplexity = minPerplexity (bag,documents,1,10);

%% Grafico de palabras 
[a,numTopics] = min(validationPerplexity);
% numTopics = 33
mdl = fitlda(bag,numTopics);   
figure
% gráfico de nube de palabras a partir de datos de texto
wordcloud(mdl,numTopics);
title("Topic: " + numTopics)

%% Funciones
function validationPerplexity = minPerplexity (bag,documents,jump,lim)
    numTopicsRange = 1:jump:lim;
    for i = 1:numel(numTopicsRange)
        numTopics = numTopicsRange(i);
        mdl = fitlda(bag,numTopics,'Solver','savb','Verbose',0);
       
        % devuelve la perplejidad calculada a partir de las probabilidades 
        % logarítmicas, devueltos como un escalar positivo.
        [~,validationPerplexity(i)] = logp(mdl,documents);
        timeElapsed(i) = mdl.FitInfo.History.TimeSinceStart(end);
    end
    figure
    yyaxis left
    plot(numTopicsRange,validationPerplexity,'*-','LineWidth',2,'Color','k')
    ylabel("Validation Perplexity","FontSize",20,"Interpreter","latex")
    set(gca,'FontSize',18,'FontName','Times New Roman')
    
    yyaxis right
    plot(numTopicsRange,timeElapsed,'o-','LineWidth',2,'Color','r')
    ylabel("Time Elapsed (s)","FontSize",20,"Interpreter","latex")
    grid on
    xlim([0 lim])
    
    legend(["Validation Perplexity" "Time Elapsed (s)"],'Location','northeastoutside')
    xlabel("Number of Topics","FontSize",20,"Interpreter","latex")
    
    frame_h = get(handle(gcf),'JavaFrame');
    set(frame_h,'Maximized',1);
end 

function documents = preprocessText(textData)
% Convierte los datos de texto a minúsculas. 
cleanTextData = lower(textData);

% Tokenizar el texto. 
documents = tokenizedDocument(cleanTextData);

% Borrar puntuación. 
documents = erasePunctuation(documents);

% Eliminar una lista de palabras vacías. 
documents = removeStopWords(documents);

% Elimina palabras con 2 o menos caracteres y palabras con 15 o 
% más caracteres.
documents = removeShortWords(documents,2);
documents = removeLongWords(documents,15);

documents = addPartOfSpeechDetails(documents);
documents = normalizeWords(documents,'Style','lemma');
end