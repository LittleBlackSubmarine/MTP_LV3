%-- Ucitavanje podataka--
data=load('identData_7.txt');

Ts = 0.2;

T=data(:,1); %vektor uzrokovanja 
U=data(:,2); %vektor ulaza
Y=data(:,3); %vektor izlaza

%-- Graf ovisnosti izlaza o vremenu -- 
% figure(1);
% plot(T,Y);
% title("y(t)");
% ylabel("y");
% xlabel("t[s]");


%------------------------------- OUTLIER-I --------------------------------


%-- Detekcija outlier-a --

ol_idx1 = find(T==528.6); % Index outlier-a nastalih u nekom vremenskom 
ol_idx2 = find(T==564.6); % trenutku t
ol_idx3 = find(T==928);
outliers = [ol_idx1, ol_idx2, ol_idx3];

% --> Prikaz outlier-a na grafu
figure(2);
plot(T,Y);
title("Detektirani outlier - i");
ylabel("y");
xlabel("t[s]");
hold on;

scatter(T(ol_idx1),Y(ol_idx1),40,'d','r','filled');
scatter(T(ol_idx2),Y(ol_idx2),40,'d','r','filled');
scatter(T(ol_idx3),Y(ol_idx3),40,'d','r','filled');

ol_txt1 = strcat(" Indeks: ",num2str(ol_idx1));
ol_txt2 = strcat(" Indeks: ",num2str(ol_idx2));
ol_txt3 = strcat(" Indeks: ",num2str(ol_idx3));
 
text(T(ol_idx1),Y(ol_idx1),ol_txt1,'FontSize',10);
text(T(ol_idx2),Y(ol_idx2),ol_txt2,'FontSize',10);
text(T(ol_idx3),Y(ol_idx3),ol_txt3,'FontSize',10);



%-- Izbacivanje outliera-a --
Y(ol_idx1) = (Y(ol_idx1 - 1) + Y(ol_idx1 - 2) + Y(ol_idx1 + 1) + ...
              Y(ol_idx1 + 2))/4; 
          
Y(ol_idx2) = (Y(ol_idx2 - 1) + Y(ol_idx2 - 2) + Y(ol_idx2 + 1) + ...
              Y(ol_idx2 + 2))/4; 
          
Y(ol_idx3) = (Y(ol_idx3 - 1) + Y(ol_idx3 - 2) + Y(ol_idx3 + 1) + ...
              Y(ol_idx3 + 2))/4; 
          
          
          
%------------------------ Nedostajuci podatci -----------------------------



cntOut = 1; % Brojac izlaznih podataka koji nedostaju
cntInp = 1; % -||- ulaznih -||-
missingOutputData_idx = []; % Indeksi podataka koji nedostaju
missingInputData_idx = [];

%-- Nalazenje indeksa podataka koji nedostaju --
for i = 1:length(Y)
    
    if isnan(Y(i)) == 1
        
        missingOutputData_idx(cntOut) = i;
        cntOut = cntOut + 1;
        
    end    
    
     if isnan(U(i)) == 1
        
        missingInputData_idx(cntInp) = i;
        cntInp = cntInp + 1;
        
    end 
    
end


%-- Linearna interpolacija--

%--> Izlazni podatci
if isempty(missingOutputData_idx) == 0
    
    for i=1:length(missingOutputData_idx)
        z = missingOutputData_idx(i);  
    
        if z ~= length(Y) 
            x1=T(z-1); % Koordinate prethodne i sljedece tocke
            x2=T(z+1);
            y1=Y(z-1);
            y2=Y(z+1);
            t=T(z); % Vremenski trenutak podatka koji fali
            Y(z)=((y2-y1)/(x2-x1))*(t-x1)+y1; % Jednadzba pravca
        else 
            Y(z)=Y(z-1);
            
        end     
    end
end

%--> Ulazni podatci
if isempty(missingInputData_idx) == 0
    
    for i=1:length(missingInputData_idx)
        z = missingInputData_idx(i);  
    
        if z ~= length(Y) 
            x1=T(z-1);
            x2=T(z+1);
            y1=U(z-1);
            y2=U(z+1);
            t=T(z);
            U(z)= ((y2-y1)/(x2-x1))*(t-x1)+y1;
        else 
            U(z)=Y(z-1);
            
        end     
    end
end


%--> Prikaz grafova s novim podatcima

% Izlazni podatci
mOD_idx1 = missingOutputData_idx(1);  % Indeksi izlaznih podataka koji
mOD_idx2 = missingOutputData_idx(2); % nedostaju
mOD_idx3 = missingOutputData_idx(3);

figure(3);
plot(T,Y);
title("Nadopunjeni izlazni podatci");
ylabel("y");
xlabel("t[s]");
hold on;

scatter(T(mOD_idx1),Y(mOD_idx1),60,'d','g','filled');
scatter(T(mOD_idx2),Y(mOD_idx2),40,'d','g','filled');
scatter(T(mOD_idx3),Y(mOD_idx3),40,'d','g','filled');

mOD_txt1 = strcat(" Indeks: ",num2str(mOD_idx1));
mOD_txt2 = strcat(" Indeks: ",num2str(mOD_idx2));
mOD_txt3 = strcat(" Indeks: ",num2str(mOD_idx3));
 
text(T(mOD_idx1),Y(mOD_idx1)+ 0.05,mOD_txt1,'FontSize',10,'VerticalAlignment'...
                                ,'bottom', 'HorizontalAlignment', 'left');
text(T(mOD_idx2),Y(mOD_idx2),mOD_txt2,'FontSize',10,'VerticalAlignment'... 
                                ,'top', 'HorizontalAlignment', 'left');
text(T(mOD_idx3) + 0.05,Y(mOD_idx3),mOD_txt3,'FontSize',10,'VerticalAlignment'...
                                ,'bottom', 'HorizontalAlignment', 'left');
                            
                            
% Ulazni podatci / nema podataka koji fale
figure(4);
plot(T,U);
title("Nadopunjeni ulazni podatci");
ylabel("u");
xlabel("t[s]");



%-- Uklanjanje srednje vrijednosti --

Y_NoMean = detrend(Y,'constant');
U_NoMean = detrend(U,'constant');

figure(4);
plot(T,Y);
title("Y,Uklonjena srednja vrijednost");
ylabel("y");
xlabel("t[s]");
hold on;
plot(T,Y_NoMean);


figure(5);
plot(T,U);
title("U,Uklonjena srednja vrijednost");
ylabel("u");
xlabel("t[s]");
hold on;
plot(T,U_NoMean);

%-- Uklanjanje linearne aproksimacije --

Y_NoLin = detrend(Y,'linear');
U_NoLin = detrend(U,'linear');

figure(6);
plot(T,Y);
title("Y,Uklonjena linearna aproksimacija");
ylabel("y");
xlabel("t[s]");
hold on;
plot(T,Y_NoLin);


figure(7);
plot(T,U);
title("U,Uklonjena linearna aproksimacija");
ylabel("u");
xlabel("t[s]");
hold on;
plot(T,U_NoLin);


%------------------------ Podjela podataka---------------------------------

%-- Podjela na trening i test skup 80/20--

trainLim = round(length(Y)*0.6);
valLim = trainLim + 1; % Izbjegavanje istog podatka u oba skupa
testLim = round(length(Y)*0.8);  % -||-

Y_train = Y_NoMean(1:trainLim);
Y_val = Y_NoMean(valLim:testLim);
Y_test = Y_NoMean(testLim+1:length(Y));

U_train = U_NoMean(1:trainLim);
U_val = U_NoMean(valLim:testLim);
U_test = U_NoMean(testLim+1:length(U));




%--------------------- Priprema za SysIdTool ------------------------------

data_Train = iddata(Y_train, U_train, Ts);
data_Val = iddata(Y_val,U_val, Ts);
data_Test = iddata(Y_test, U_test,  Ts);


%------------------------- ARX Model --------------------------------------

NN = struc(1:5, 1:5, 1:5);
V = arxstruc(data_Train, data_Val, NN);
bestParams1 = selstruc(V,0);

% Best combination = [5 5 5]
modArx = arx(data_Train, bestParams1);

figure; compare(data_Train,modArx);
figure; compare(data_Val,modArx);
figure; compare(data_Test,modArx);


%----------------------- ARMAX Model --------------------------------------

bestFit = 0;

for na = 1:5
    
    for nb = 1:5
        
        for nc = 1:5
            
            for nk = 0:5
                
                modArmax = armax(data_Train, [na nb nc nk]);
                [y, fit, ic] = compare(data_Train, modArmax);
                
                if fit > bestFit
                    bestParams2 = [na nb nc nk];
                    bestFit = fit;
                    
                end
            end
                
        end
    end
    
end

% Best combination = [5 2 4 3]
modArmax = armax(data_Train, bestParams2);

figure; compare(data_Train,modArmax);
figure; compare(data_Val,modArmax);
figure; compare(data_Test,modArmax);


%-------------------------- BJ Model --------------------------------------

bestFit = 0;

for nb = 1:5
    
    for nc = 1:5
        
        for nd = 1:5
            
            for nf = 1:5
                
                for nk = 0:5
                
                    modBJ = bj(data_Train, [nb nc nd nf nk]);
                    [y, fit, ic] = compare(data_Train, modBJ);

                    if fit > bestFit
                        bestParams3 = [nb nc nd nf nk];
                        bestFit = fit;

                    end

                end
            end
                
        end
    end
    
end

% Best combination = [5 5 3 4 5]
modBJ = bj(data_Train, bestParams3);

figure; compare(data_Train,modBJ);
figure; compare(data_Val,modBJ);
figure; compare(data_Test,modBJ);


% Compare linear models
figure; compare(data_Test,modArx,modArmax,modBJ);



% %------------------------ NARX Model---------------------------------------
% 
% % -- WaveNet--
% 
% modNARX_WN = nlarx(data_Train,modArx);
% 
% figure; compare(data_Train,modNARX_WN);
% figure; compare(data_Val,modNARX_WN);
% figure; compare(data_Test,modNARX_WN);
% 
% bestFit = 0;
% 
% for NoU = 1:20
%     modNARX_WN2 = nlarx(data_Train,modArx,wavenet('NumberofUnits',NoU));
%     [y, fit, ic] = compare(data_Train, modNARX_WN2);
%     if fit > bestFit
%         bestFit = fit;
%         bestNoU = NoU; 
%     end
% end
% 
% % disp(bestNoU);
% % --> Best NoU is 4
% 
%  modNARX_WN2 = nlarx(data_Train,modArx,wavenet('NumberofUnits',bestNoU));
% 
% figure; compare(data_Train,modNARX_WN2);
% figure; compare(data_Val,modNARX_WN2);
% figure; compare(data_Test,modNARX_WN2);
% 
% figure; compare(data_Test,modNARX_WN,modNARX_WN2);
% 
% 
% 
% % --Sigmoidnet--
% 
% modNARX_SN = nlarx(data_Train,modArx,sigmoidnet);
% 
% figure; compare(data_Train,modNARX_SN);
% figure; compare(data_Val,modNARX_SN);
% figure; compare(data_Test,modNARX_SN);
% 
% 
% 
% % --Neural network--
% N1 = 5; N2 = 2;
% ff_bestStruct = [N1, N2];
% ff_Tfcn = {'radbas','logsig','softmax','tansig'};
% ff_bestTfcn = 'radbas';
% bestFit = 0;
% 
% 
% for N2 = 2:10
%     for fcn_no = 1:length(ff_Tfcn)
%         
%         ff = feedforwardnet([N1 N2]);
%         ff.layers{2}.transferFcn = ff_Tfcn{fcn_no};
%         ff.trainParam.epochs = 50;
%         modNARX_NN = nlarx(data_Train,modArx,neuralnet(ff));
%         [y, fit, ic] = compare(data_Train, modNARX_NN);
% 
%         if fit > bestFit
%             bestFit = fit;
%             ff_bestStruct = [N1 N2];
%             ff_bestTfcn = ff_Tfcn{fcn_no};
%         end
%     end
% end
% 
% % Best combination: [5 8] tansig
% disp(ff_bestStruct); disp(ff_bestTfcn);
% ff = feedforwardnet(ff_bestStruct);
% ff.layers{2}.transferFcn = ff_bestTfcn;
% ff.trainParam.epochs = 50;
% 
% modNARX_NN = nlarx(data_Train,modArx,neuralnet(ff));
% 
% figure; compare(data_Train,modNARX_NN);
% figure; compare(data_Val,modNARX_NN);
% figure; compare(data_Test,modNARX_NN);
% 
% 
% % Compare nonlinear models
% figure; compare(data_Test, modNARX_WN, modNARX_WN2, modNARX_SN, modNARX_NN);





