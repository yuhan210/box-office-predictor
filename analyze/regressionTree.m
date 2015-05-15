clear;clf;
all_gt_y = [];
all_pred_y = [];
%% train bndn
bndn_traindata = importdata('bndn_train');
bndn_testdata = importdata('bndn_test');

bndn_train_x = bndn_traindata(:, 2:end);
bndn_train_y = bndn_traindata(:,1);

bndn_test_x = bndn_testdata(:, 2:end);
bndn_test_y = bndn_testdata(:,1);

%
bndy_traindata = importdata('bndy_train');
bndy_testdata = importdata('bndy_test');

bndy_train_x = bndy_traindata(:, 2:end);
bndy_train_y = bndy_traindata(:,1);

bndy_test_x = bndy_testdata(:, 2:end);
bndy_test_y = bndy_testdata(:,1);

%
bydy_traindata = importdata('bydy_train');
bydy_testdata = importdata('bydy_test');

bydy_train_x = bydy_traindata(:, 2:end);
bydy_train_y = bydy_traindata(:,1);

bydy_test_x = bydy_testdata(:, 2:end);
bydy_test_y = bydy_testdata(:,1);
%

bydn_traindata = importdata('bydn_train');
bydn_testdata = importdata('bydn_test');

bydn_train_x = bydn_traindata(:, 2:end);
bydn_train_y = bydn_traindata(:,1);

bydn_test_x = bydn_testdata(:, 2:end);
bydn_test_y = bydn_testdata(:,1);

%% bndn
total_theater = bndn_train_x(:, 1);
opening_theater_earnings = bndn_train_x(:, 2);
opening_theater = bndn_train_x(:, 3);
mpaa = bndn_train_x(:, 4);
genre = bndn_train_x(:, 5:9);

bndn_table = table(bndn_train_y, total_theater, opening_theater_earnings, opening_theater,mpaa, genre(:, 1),genre(:, 2),genre(:, 3),genre(:, 4),genre(:, 5));
bndn_table.mpaa = nominal(bndn_table.mpaa);
bndn_mdl = fitlm(bndn_table,'bndn_train_y~ opening_theater_earnings*mpaa+ total_theater^2 + opening_theater^2 + Var6+Var7+Var8+Var9+Var10');
bndn_mdl_step = stepwiselm(bndn_table,'bndn_train_y~ opening_theater_earnings*mpaa+ total_theater^2 + opening_theater^2 + Var6+Var7+Var8+Var9+Var10',  'PEnter',0.005);
%bndn_mdl = bndn_mdl_step;
disp(bndn_mdl)

disp(bndn_mdl_step)
figure()
plotResiduals(bndn_mdl,'probability')

% testing
total_theater = bndn_test_x(:, 1);
opening_theater_earnings = bndn_test_x(:, 2);
opening_theater = bndn_test_x(:, 3);
mpaa = bndn_test_x(:, 4);
genre = bndn_test_x(:, 5:9);


bndn_table = table(bndn_test_y, total_theater, opening_theater_earnings, opening_theater,mpaa, genre(:, 1),genre(:, 2),genre(:, 3),genre(:, 4),genre(:, 5));
bndn_table.Properties.VariableNames{1} = 'bndn_train_y';
bndn_table.mpaa = nominal(bndn_table.mpaa);

ypred = predict(bndn_mdl,bndn_table);
bndn_error = getTestError(bndn_test_y, ypred);
bndn_class_error = getClassifyError(bndn_test_y,ypred);
bndn_conf = getConfusionMat(bndn_test_y,ypred);
all_gt_y = [all_gt_y; bndn_test_y];
all_pred_y = [all_pred_y; ypred];

%% bndy

total_theater = bndy_train_x(:, 1);
opening_theater_earnings = bndy_train_x(:, 2);
opening_theater = bndy_train_x(:, 3);
mpaa = bndy_train_x(:, 4);
genre = bndy_train_x(:, 5:9);
dir_past_earnings = bndy_train_x(:, 10);

bndy_table = table(bndy_train_y, total_theater, opening_theater_earnings, opening_theater,mpaa,...
    genre(:, 1),genre(:, 2),genre(:, 3),genre(:, 4),genre(:, 5), dir_past_earnings);
bndy_table.mpaa = nominal(bndy_table.mpaa);
bndy_mdl = fitlm(bndy_table,'bndy_train_y~ opening_theater_earnings*mpaa+ total_theater^2 + opening_theater^2 + Var6+Var7+Var8+Var9+Var10 + dir_past_earnings');
bndy_mdl_step = stepwiselm(bndy_table,'bndy_train_y~ opening_theater_earnings*mpaa+ total_theater^2 + opening_theater^2 + Var6+Var7+Var8+Var9+Var10 + dir_past_earnings', 'PEnter',0.005);
%bndy_mdl = bndy_mdl_step;
disp(bndy_mdl)
figure()
plotResiduals(bndy_mdl,'probability')

% testing
total_theater = bndy_test_x(:, 1);
opening_theater_earnings = bndy_test_x(:, 2);
opening_theater = bndy_test_x(:, 3);
mpaa = bndy_test_x(:, 4);
genre = bndy_test_x(:, 5:9);
dir_past_earnings = bndy_test_x(:, 10);


bndy_table = table(bndy_test_y, total_theater, opening_theater_earnings, opening_theater,mpaa,...
genre(:, 1),genre(:, 2),genre(:, 3),genre(:, 4),genre(:, 5), dir_past_earnings);
bndy_table.Properties.VariableNames{1} = 'bndy_train_y';
bndy_table.mpaa = nominal(bndy_table.mpaa);

ypred = predict(bndy_mdl,bndy_table);
bndy_error = getTestError(bndy_test_y, ypred);
bndy_class_error = getClassifyError(bndy_test_y,ypred);
bndy_conf = getConfusionMat(bndy_test_y,ypred);
all_gt_y = [all_gt_y; bndy_test_y];
all_pred_y = [all_pred_y; ypred];

%% bynd
total_theater = bydn_train_x(:, 1);
opening_theater_earnings = bydn_train_x(:, 2);
opening_theater = bydn_train_x(:, 3);
mpaa = bydn_train_x(:, 4);
genre = bydn_train_x(:, 5:9);
budget = bydn_train_x(:, 10);

bydn_table = table(bydn_train_y, total_theater, opening_theater_earnings, opening_theater,mpaa, genre(:, 1),genre(:, 2),genre(:, 3),genre(:, 4),genre(:, 5), budget);
bydn_table.mpaa = nominal(bydn_table.mpaa);
bydn_mdl = fitlm(bydn_table,'bydn_train_y~ opening_theater_earnings*mpaa+ total_theater^2 + opening_theater^2 + Var6+Var7+Var8+Var9+Var10 + budget');
bydn_mdl_step = stepwiselm(bydn_table,'bydn_train_y~ opening_theater_earnings*mpaa+ total_theater^2 + opening_theater^2 + Var6+Var7+Var8+Var9+Var10 + budget', 'PEnter',0.005);
%bydn_mdl = bydn_mdl_step
disp(bydn_mdl)
figure()
plotResiduals(bydn_mdl,'probability')

% testing
total_theater = bydn_test_x(:, 1);
opening_theater_earnings = bydn_test_x(:, 2);
opening_theater = bydn_test_x(:, 3);
mpaa = bydn_test_x(:, 4);
genre = bydn_test_x(:, 5:9);
budget = bydn_test_x(:, 10);

bydn_table = table(bydn_test_y, total_theater, opening_theater_earnings, opening_theater,mpaa, genre(:, 1),genre(:, 2),genre(:, 3),genre(:, 4),genre(:, 5), budget);
bydn_table.Properties.VariableNames{1} = 'bydn_train_y';
bydn_table.mpaa = nominal(bydn_table.mpaa);

ypred = predict(bydn_mdl,bydn_table);
bydn_error = getTestError(bydn_test_y, ypred);
bydn_class_error = getClassifyError(bydn_test_y,ypred);
bydn_conf = getConfusionMat(bydn_test_y,ypred);
all_gt_y = [all_gt_y; bydn_test_y];
all_pred_y = [all_pred_y; ypred];
%% bydy
total_theater = bydy_train_x(:, 1);
opening_theater_earnings = bydy_train_x(:, 2);
opening_theater = bydy_train_x(:, 3);
mpaa = bydy_train_x(:, 4);
genre = bydy_train_x(:, 5:9);
dir_past_earnings = bydy_train_x(:, 10);
budget = bydy_train_x(:, 11);

bydy_table = table(bydy_train_y, total_theater, opening_theater_earnings, opening_theater,mpaa, genre(:, 1),genre(:, 2),genre(:, 3),genre(:, 4),genre(:, 5), dir_past_earnings, budget);
bydy_table.mpaa = nominal(bydy_table.mpaa);
bydy_mdl = fitlm(bydy_table,'bydy_train_y~ opening_theater_earnings*mpaa+ total_theater^2 + opening_theater^2 + Var6+Var7+Var8+Var9+Var10 + dir_past_earnings+budget');
%bydy_mdl_step = stepwiselm(bydy_table,'bydy_train_y~ opening_theater_earnings*mpaa+ total_theater^2 + opening_theater^2 + Var6+Var7+Var8+Var9+Var10 + dir_past_earnings+budget', 'PEnter',0.005);
%bydy_mdl = bydy_mdl_step
disp(bydy_mdl)
figure()
plotResiduals(bydy_mdl,'probability')

% testing
total_theater = bydy_test_x(:, 1);
opening_theater_earnings = bydy_test_x(:, 2);
opening_theater = bydy_test_x(:, 3);
mpaa = bydy_test_x(:, 4);
genre = bydy_test_x(:, 5:9);
dir_past_earnings = bydy_test_x(:, 10);
budget = bydy_test_x(:, 11);



bydy_table = table(bydy_test_y, total_theater, opening_theater_earnings, opening_theater,mpaa, genre(:, 1),genre(:, 2),genre(:, 3),genre(:, 4),genre(:, 5), dir_past_earnings,budget);
bydy_table.Properties.VariableNames{1} = 'bydy_train_y';
bydy_table.mpaa = nominal(bydy_table.mpaa);

ypred = predict(bydy_mdl,bydy_table);
bydy_error = getTestError(bydy_test_y, ypred);
bydy_class_error = getClassifyError(bydy_test_y,ypred);
bydy_conf = getConfusionMat(bydy_test_y,ypred);
all_gt_y = [all_gt_y; bydy_test_y];
all_pred_y = [all_pred_y; ypred];

all_error = getTestError(all_gt_y, all_pred_y);
all_class_error = getClassifyError(all_gt_y,all_pred_y);
