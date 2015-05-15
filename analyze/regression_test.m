clear;
%% load data

train_data = importdata('train');
test_data = importdata('test');

train_x = train_data(:, 3:33);
train_y = train_data(:,2);
train_id = train_data(:, 1);

test_x = test_data(:, 3:33);
test_y = test_data(:,2);
test_id = test_data(:, 1);

%% Linear regression fitting all features

tbl = table(train_y, train_x(:,1),train_x(:,2),train_x(:,3),train_x(:,4),...
    train_x(:,5),train_x(:,6),train_x(:,7),train_x(:,8),...
    train_x(:,9),train_x(:,10),train_x(:,11),train_x(:,12),...
    train_x(:,13),train_x(:,14),train_x(:,15),train_x(:,16),...
    train_x(:,17),train_x(:,18),train_x(:,19),train_x(:,20),...
    train_x(:,21),train_x(:,22),train_x(:,23),train_x(:,24),...
    train_x(:,25),train_x(:,26),train_x(:,27),train_x(:,28),...
    train_x(:,29),train_x(:,30),train_x(:,31),...
    'VariableNames',{'Gross','Total_theaters',...
    'Opening','Opening_theaters', ...
    'Runtime','MPAA_1','MPAA_2','MPAA_3','GENRE_1','GENRE_2','GENRE_3','GENRE_4','GENRE_5',...
    'GENRE_6','GENRE_7','GENRE_8','GENRE_9','GENRE_10','GENRE_11','GENRE_12','GENRE_13',...
    'GENRE_14','GENRE_15','GENRE_16','GENRE_17','GENRE_18','GENRE_19','GENRE_20','GENRE_21',...
    'GENRE_22','GENRE_23','GENRE_24'});

%{
mdl = fitlm(train_x,train_y,'linear', 'VarNames',{'Total_theaters',...
    'Opening','Opening_theaters', ...
    'Runtime','MPAA_1','MPAA_2','MPAA_3','GENRE_1','GENRE_2','GENRE_3','GENRE_4','GENRE_5',...
    'GENRE_6','GENRE_7','GENRE_8','GENRE_9','GENRE_10','GENRE_11','GENRE_12','GENRE_13',...
    'GENRE_14','GENRE_15','GENRE_16','GENRE_17','GENRE_18','GENRE_19','GENRE_20','GENRE_21',...
    'GENRE_22','GENRE_23','GENRE_24', 'Gross'});
%}
mdl = fitlm(train_x,train_y,'linear');
ypred = predict(mdl,test_x);

figure()
plotResiduals(mdl,'probability')
linear_reg_all = getTestError(test_y, ypred);
linear_reg_all_class_error = getClassifyError(test_y,ypred);

%% Scatterplots for numericalfeatures with low missing percentage 

figure();
xlabels = {'Total Theaters', 'Opening Earnings', 'Opening Theaters', 'Runtime'};
for i = 1: length(xlabels)
    subplot(2,2,i)
    scatter(train_x(:, i),train_y); hold on;
    mdl = fitlm(train_x(:, i),train_y, 'linear');
    strmin = ['R^2 = ',num2str(mdl.Rsquared.Ordinary)];
    h = text(max(train_x(:, i)) + 10 ,max(train_y),strmin,'HorizontalAlignment','right');h.FontSize = 15;
    %disp(mdl)
    plot(mdl)
    xlabel(xlabels(i))
    ylabel('Box-office Earnings')
end

%% Fitting quadratic terms with/without runtime

nl_x_train = train_data(:, 3:5);
nl_x_test = test_data(:, 3:5);
%modelfun = 'y ~ (b0 + b1*x1 + b2*x2 + b3*x3 + b4*x4)';
modelfun = 'y ~ (b0 + b1*x1 + b2*x1^2 + b3*x2 + b4*x3 + b5*x3^2)';
nl_mdl = fitnlm(nl_x_train,train_y,modelfun,[1,1,1,1,1,1]);
disp(nl_mdl)
figure()
plotResiduals(nl_mdl,'probability')
ypred = predict(nl_mdl,nl_x_test);
nl_error = getTestError(test_y,ypred);
nl_class_error = getClassifyError(test_y,ypred);

%% Fitting quadratic terms removing runtime

modelfun = 'y ~ (b0 + b1*x1  + b2*x2 + b3*x3 )';
nl_linear_mdl = fitnlm(nl_x_train,train_y,modelfun,[1,1,1,1]);
disp(nl_mdl)
ypred = predict(nl_linear_mdl,nl_x_test);
nl_linear_error = getTestError(test_y,ypred)
nl_linear_class_error = getClassifyError(test_y,ypred);


%% MPAA categorical features with OE

mpaa_x_train = importdata('train_mpaa');
mpaa_x_test = importdata('test_mpaa');
figure();
gscatter(train_x(:, 2),train_y, mpaa_x_train,'bgrk','x.o')
hold on;
ratings = table(train_y,train_x(:, 2),mpaa_x_train);
ratings.mpaa_x_train = nominal(ratings.mpaa_x_train);
fit = fitlm(ratings,'train_y~Var2*mpaa_x_train');
disp(fit)
w = linspace(min(train_x(:, 2)),max(train_x(:, 2)));
line(w,feval(fit,w,'0'),'Color','b','LineWidth',2)
line(w,feval(fit,w,'1'),'Color','g','LineWidth',2)
line(w,feval(fit,w,'2'),'Color','r','LineWidth',2)
line(w,feval(fit,w,'3'),'Color','k','LineWidth',2)
title('Total Earnings vs. Opening Earnings, Gouped by MPAA rating')
anova(fit)

%% fitting with interactions and quadratic terms

% training
ratings = table(train_y,train_x(:, 1), train_x(:, 2), train_x(:, 3),mpaa_x_train);
ratings.mpaa_x_train = nominal(ratings.mpaa_x_train);
cl_fit_all_mdl = fitlm(ratings,'train_y~Var3*mpaa_x_train + Var2^2 + Var4^2');
disp(cl_fit_all_mdl)
figure()
plotResiduals(cl_fit_all_mdl,'probability')

% testing
ratings_test = table(test_y,test_x(:, 1), test_x(:, 2), test_x(:, 3),mpaa_x_test);
ratings_test.Properties.VariableNames{5} = 'mpaa_x_train';
ratings_test.Properties.VariableNames{1} = 'train_y';
ratings_test.mpaa_x_train = nominal(ratings_test.mpaa_x_train);

ypred = predict(cl_fit_all_mdl,ratings_test);
mpaa_error = getTestError(test_y,ypred)
mpaa_class_error = getClassifyError(test_y,ypred);


%% fitting with pca genres
train_genrepca_x = importdata('train_genre_pca');
test_genrepca_x = importdata('test_genre_pca');

cl_genre_table = table(train_y,train_x(:, 1), train_x(:, 2), train_x(:, 3),mpaa_x_train, train_genrepca_x(:, 1),train_genrepca_x(:, 2),train_genrepca_x(:, 3),train_genrepca_x(:, 4),train_genrepca_x(:, 5));
cl_genre_table.mpaa_x_train = nominal(cl_genre_table.mpaa_x_train);
cl_genre_fit_all_mdl = fitlm(cl_genre_table,'train_y~Var3*mpaa_x_train + Var2^2 + Var4^2 + Var6+Var7+Var8+Var9+Var10');
disp(cl_genre_fit_all_mdl)
figure()
plotResiduals(cl_genre_fit_all_mdl,'probability')

% testing
genres_test_table = table(test_y,test_x(:, 1), test_x(:, 2), test_x(:, 3),mpaa_x_test, test_genrepca_x(:,1), test_genrepca_x(:,2),test_genrepca_x(:,3),test_genrepca_x(:,4),test_genrepca_x(:,5));
genres_test_table.Properties.VariableNames{5} = 'mpaa_x_train';
genres_test_table.Properties.VariableNames{1} = 'train_y';
genres_test_table.mpaa_x_train = nominal(genres_test_table.mpaa_x_train);

ypred = predict(cl_genre_fit_all_mdl,genres_test_table);
genre_error = getTestError(test_y,ypred);
genre_class_error = getClassifyError(test_y,ypred);
figure()


%{
figure(1);
mdl_tanktemp = fitlm(tanktemp,hydro,'linear');
subplot(2,2,1)
plot(tanktemp, zscore(mdl_tanktemp.Residuals.Raw), 'o');
xlabel('Tank Temp')
ylabel('Standarized residuals')
subplot(2,2,2)
mdl_gastemp = fitlm(gastemp,hydro,'linear');
plot(gastemp, zscore(mdl_gastemp.Residuals.Raw), 'o');
xlabel('Gas Temp')
ylabel('Standarized residuals')
subplot(2,2,3)
mdl_tankvapor = fitlm(tankvapor,hydro,'linear');
plot(tankvapor, zscore(mdl_tankvapor.Residuals.Raw), 'o');
xlabel('Tank Vapor')
ylabel('Standarized residuals')
subplot(2,2,4)
mdl_gasvapor = fitlm(gasvapor,hydro,'linear');
plot(gasvapor, zscore(mdl_gasvapor.Residuals.Raw), 'o');
xlabel('Gas Vapor')
ylabel('Standarized residuals')

figure(2)
subplot(2,2,1)

plotResiduals(mdl_tanktemp,'probability')
xlabel('Tank Temp')
subplot(2,2,2)

plotResiduals(mdl_gastemp,'probability')
xlabel('Gas Temp')
subplot(2,2,3)

plotResiduals(mdl_tankvapor,'probability')
xlabel('Tank Vapor')
subplot(2,2,4)

plotResiduals(mdl_gasvapor,'probability')

xlabel('Gas Vapor')

figure(3)
subplot(2,2,1)
scatter(tanktemp, hydro)
xlabel('Tank Temp')
ylabel('Hydrocarbons')
lsline
subplot(2,2,2)
scatter(gastemp, hydro)
xlabel('Gas Temp')
ylabel('Hydrocarbons')

lsline
subplot(2,2,3)
scatter(tankvapor, hydro)
lsline
xlabel('Tank Vapor')
ylabel('Hydrocarbons')
subplot(2,2,4)
scatter(gasvapor, hydro)
lsline
xlabel('Gas Vapor')
ylabel('Hydrocarbons')


%%
figure(5)
beta0 = [1, 1, 1, 1, 1];
modelfun = 'y ~ (b0 + b1*x1 + b2*x2 + b3*x3 + b4*x4)';
mdl = fitnlm([tanktemp, gastemp, tankvapor, gasvapor],hydro,modelfun,beta0)

plotResiduals(mdl,'probability')
ypred = predict(mdl,[test_tanktemp, test_gastemp, test_tankvapor, test_gasvapor]);
sqrt(sum((test_hydro - ypred).^2)/40)

scatter(ypred,test_hydro)
xlabel('Predicted Hydrocarbons')
ylabel('Observed Hydrocarbons')
figure(6)
subplot(2,2,1)
scatter(test_tanktemp, test_hydro - ypred);
xlabel('Tank temp')
ylabel('Error')

subplot(2,2,2)
scatter(test_gastemp, test_hydro - ypred);
xlabel('Gas temp')
ylabel('Error')
subplot(2,2,3)
scatter(test_tankvapor, test_hydro - ypred);
xlabel('Tank Vapor')
ylabel('Error')
subplot(2,2,4)
scatter(test_gasvapor, test_hydro - ypred);
xlabel('Gas Vapor')
ylabel('Error')

beta0 = [1, 1, 1, 1];
modelfun = 'y ~ (b0 + b1*x1 + b2*x2 + b3*x3)';
mdl = fitnlm([tanktemp, gastemp gasvapor],hydro,modelfun,beta0);
figure(7)
plotResiduals(mdl,'probability')
ypred = predict(mdl,[test_tanktemp, test_gastemp, test_gasvapor]);
sqrt(sum((test_hydro - ypred).^2)/40)


scatter(ypred,test_hydro)
xlabel('Predicted Hydrocarbons')
ylabel('Observed Hydrocarbons')
figure(8)
subplot(2,2,1)
scatter(test_tanktemp, test_hydro - ypred);
xlabel('Tank temp')
ylabel('Error')

subplot(2,2,2)
scatter(test_gastemp, test_hydro - ypred);
xlabel('Gas temp')
ylabel('Error')
subplot(2,2,3)
scatter(test_tankvapor, test_hydro - ypred);
xlabel('Tank Vapor')
ylabel('Error')
subplot(2,2,4)
scatter(test_gasvapor, test_hydro - ypred);
xlabel('Gas Vapor')
ylabel('Error')
%}