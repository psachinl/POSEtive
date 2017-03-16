filename = 'ADAMTRAININGDATA.csv' %csv of training data
[Z]=csvread(filename)

X=Z(:,1:2);
Y=Z(:,3);

svmStruct = svmtrain(X,Y,'kernel_function','quadratic','ShowPlot',true);
a = [-0.4,0]
label = svmclassify(svmStruct,a)
