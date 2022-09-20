
X = xlsread("D:\PHN-319\Input_Data_New_PHN-319.xlsx",'A2:BP232');
Y = xlsread("D:\PHN-319\Output_Data_New_PHN-319.xlsx",'A2:BM232');

X = X';
Y = Y';
X(1,:) = X(1,:)*1e12;
X(2,:) = X(2,:)*1e27;
X(3,:) = X(3,:)*1e12;

r = randperm(231);
X_new = X(:,r);
Y_new = Y(:,r);

% net = feedforwardnet([20 15 5]);
% net.layers{1}.transferFcn = 'logsig';
% net.layers{2}.transferFcn = 'logsig';
% net.layers{3}.transferFcn = 'logsig';
% net.layers{4}.transferFcn = 'logsig';
% net.trainFcn = 'traingdm';
% 
% net.divideParam.trainRatio = 0.9;
% net.divideParam.valRatio = 0.05;
% net.divideParam.testRatio = 0.05;
% 
% net.trainParam.max_fail = 10;
% net.trainParam.min_grad = 1e-10;
% net.trainParam.epochs = 1e5;
% 
% [net,tr] = train(net,X_new,Y_new);

rbfn = newrb(X_new,Y_new,1e-5,1.25);

Xtest = xlsread("D:\PHN-319\Input_Data_Test_PHN-319.xlsx",'A2:BP232');
Ytest = xlsread("D:\PHN-319\Output_Data_Test_PHN-319.xlsx",'A2:BM232');

Xtest = Xtest';
Ytest = Ytest';

Xtest(1,:) = Xtest(1,:)*1e12;
Xtest(2,:) = Xtest(2,:)*1e27;
Xtest(3,:) = Xtest(3,:)*1e12;


Ypred_test = rbfn(Xtest);

Y_diffmat = Ytest - Ypred_test;
test_err = 0;

for i = 1:size(Ytest,2)
   test_err = test_err + norm(Y_diffmat(:,i));
end

MSE_test = (1/size(Ytest,2))*test_err;
