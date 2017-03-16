a = [0,0] %test angles to be classified with a trained model

filename = 'training_data.csv' %csv of training data
[Z]=csvread(filename)
%X=X' %get stuff into the correct format
X=Z(:,1:2);
Y=Z(:,3);
TRAINEDMODEL1 = fitcsvm(X,Y) %train model

sv = TRAINEDMODEL1.SupportVectors; %highlight support vectors for plotting
figure
gscatter(X(:,1),X(:,2),Y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('b','g','Support Vector')
hold off
a = [0,0]
label = predict(TRAINEDMODEL1,a) %label = 'b' or 'g', for bad or good posture