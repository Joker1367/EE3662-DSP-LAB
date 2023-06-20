#%%
import os
import itertools
from turtle import width
import librosa
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from glob import glob
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.model_selection import KFold
from sklearn.svm import SVC, LinearSVC
from sklearn.preprocessing import StandardScaler
from Lab3_109061217_functions import plot_confusion_matrix

RANDSEED = 0 # setup random seed
CVFOLD = 5 # number of folds of cross validation
classNames = ['Dog bark', 'Rain', 'Sea waves', 'Baby cry',
              'Clock tick', 'Person sneeze', 'Helicopter', 'Chainsaw',
              'Rooster', 'Fire crackling']
#%%
##### Load data & Calculate features MFCC
labels = pd.read_csv('../data/label.csv')
nameToLabel = dict((row['filename'], row['label']) for idx, row in labels.iterrows())
trainFiles = sorted(glob('../data/Train/*/*.ogg'))
testFiles = sorted(glob('../data/Test/*/*.ogg'))
trainLabel = np.array([nameToLabel[os.path.basename(p)] for p in trainFiles])
testLabel = np.array([nameToLabel[os.path.basename(p)] for p in testFiles])

def feat_extraction(path, beta):
    '''
    Input: path for a single file
    Output: 1D feature vector
    (1) Read file using librosa
    (2) Use librosa to calculate MFCC
    (3) Aggregate the 2D MFCC along time axis to 1D feature vector (ex: mean, std ...)
    '''
	######
	#CODE HERE
    signal_source, sr = librosa.load(path)
    MFCC = librosa.feature.mfcc(y = signal_source, sr = sr, n_mfcc = 64)    # extract the MFCC
    MEAN = np.mean(MFCC[0:9, :], axis = 1)                                  # Find Mean along the time axis of the first nine MFCC
    STD = np.std(MFCC, axis = 1)                                            # Find Standard d\Deviation of MFCC along the time axis
    #MED = np.median(MFCC, axis = 1)
	######
    #return beta * MEAN + (1 - beta) * STD
    #return MED
    return np.append(MEAN, STD)                                             # put them together to be the feature we used for train model and test

beta = 1
trainFeat = np.vstack([feat_extraction(p, beta) for p in trainFiles])       # train set and validation set
testFeat = np.vstack([feat_extraction(p, beta) for p in testFiles])         # tests et
##### Perform cross-validation
'''
(1) Use KFold to perform cross validation
(2) Normalize training set and testing set
(3) Collect result from each fold
(4) Calculate accuracy and confusion matrix
'''
        
X = trainFeat                                                                # Initialization
y = trainLabel
C = 0.75                                                                     # the variable for slack variable
Kf = KFold(n_splits=CVFOLD, shuffle=True, random_state=RANDSEED)
sc = StandardScaler()
y_dev_cv = []
y_predict_cv = []
clf = SVC(C = C, gamma = 'auto')                                             # the Support Vector Machine
#clf = LinearSVC(C = 1, max_iter = 5000)
#clf = tree.DecisionTreeClassifier()

######################################################### The K-fold Cross Validation #############################################################
for cvIdx, (trainIdx, devIdx) in enumerate(Kf.split(range(len(X)))):
    ######
    #CODE HERE
    TrainFeat, TestFeat = sc.fit_transform(X[trainIdx]), sc.fit_transform(X[devIdx])   # seperate into train set and validation set
    TrainLabel, TestLabel = y[trainIdx], y[devIdx]
    clf.fit(TrainFeat, TrainLabel)                                                     # Train the model by train set
    prediction = clf.predict(TestFeat)                                                 # Make prediction on validation set
    y_dev_cv.extend(TestLabel)
    y_predict_cv.extend(prediction)
    ######
            
accuracy = accuracy_score(y_dev_cv, y_predict_cv)                                      # Calculate the accuracy
cm = confusion_matrix(y_dev_cv, y_predict_cv, labels = classNames)                     # construct the confusion matrix
plot_confusion_matrix(cm , classNames)                                                 # plot the confusion maritrix
print('Train Set ACC = ',  accuracy)                                                   # print the accuracy
####################################################################################################################################################

##### #########################################################Predict on test set##################################################################
'''
(1) Train a model based on your best parameters
(2) Prediction on test set
(3) Calculate accuracy and confusion matrix
'''
X_test = testFeat
y_test = testLabel
######
#CODE HERE
TestFeat = sc.fit_transform(X_test)
prediction = clf.predict(TestFeat)                                                      # Make prediction on the test set due to the model that have been trained
######

accuracy = accuracy_score(y_test, prediction)                                           # Calculate the accuracy 
cm = confusion_matrix(y_test, prediction, labels = classNames)                          # construct the confusion matrix
plot_confusion_matrix(cm , classNames)                                                  # plot the confusion maritrix
print('C = ', C, ', Gamma = ', 'auto', ' Test set ACC = ',  accuracy) # print the accuracy and all the condition we used in the model
#######################################################################################################################################################
