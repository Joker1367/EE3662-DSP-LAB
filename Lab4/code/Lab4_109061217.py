'''
Created on Mon Dec  7 22:40:09 2020

@author: wschien
'''

from glob import glob
import os
import itertools
from turtle import width
import librosa
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from librosa.feature import mfcc, rms, spectral_centroid, spectral_bandwidth, spectral_rolloff, zero_crossing_rate, delta
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.pipeline import make_pipeline
from sklearn.model_selection import KFold
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC, LinearSVC
from sklearn.metrics import confusion_matrix, accuracy_score, f1_score
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from Lab4_109061217_functions import plot_confusion_matrix

from imblearn.over_sampling import SMOTE, BorderlineSMOTE, ADASYN
from imblearn.under_sampling import EditedNearestNeighbours, TomekLinks
from imblearn.ensemble import BalancedBaggingClassifier
from imblearn.combine import SMOTEENN
from collections import Counter

#%%
RANDSEED = 0 # setup random seed
CVFOLD = 10   # number of folds of cross validation
classNames = ['Canonical', 'Crying', 'Junk', 'Laughing', 'Non-canonical']
DataPath = './data/Baby_Data'

y_dev_cv = []
y_predict_cv = []

Kf = KFold(n_splits=CVFOLD, shuffle=True, random_state=RANDSEED)
sc = StandardScaler()
mc = MinMaxScaler()
sm = SMOTE(random_state = 42, k_neighbors = 10)
bsm = BorderlineSMOTE(random_state = 42, kind = 'borderline-1')
enn = EditedNearestNeighbours()
tl = TomekLinks()
sme = SMOTEENN(random_state=42, smote = bsm)
ada = ADASYN(sampling_strategy='minority', random_state = 42, n_neighbors = 5)

#%% Functions
def MFCC_feat(file):
    signal_source, sr = librosa.load(file)
    MFCC = mfcc(y = signal_source, sr = sr, n_mfcc = 40, n_fft = 1024)    # extract the MFCC
    #print(MFCC.shape)
    MFCC_DELTA = []
    MFCC_DELTA2 = []
    if MFCC.shape[1] % 2 == 0:
        MFCC_DELTA = delta(MFCC, width = MFCC.shape[1] - 1)
        MFCC_DELTA2 = delta(MFCC, width = MFCC.shape[1] - 1, order =2 )
    else:
        MFCC_DELTA = delta(MFCC, width = MFCC.shape[1])
        MFCC_DELTA2 = delta(MFCC, width = MFCC.shape[1], order=2)
    #print(MFCC_DELTA.shape)
    ZC = np.mean(zero_crossing_rate(y = signal_source).flatten())
    RF = np.mean(spectral_rolloff(y = signal_source, sr = sr, n_fft = 1024))
    BW = np.mean(spectral_bandwidth(y = signal_source, sr = sr, n_fft = 1024))
    CT = np.mean(spectral_centroid(y = signal_source, sr = sr, n_fft = 1024))
    RMS = np.mean(rms(y = signal_source))
    MEAN = np.mean(MFCC[0:20, :], axis = 1)             # Find Mean along the time axis of the first nine MFCC
    DELTA = np.mean(MFCC_DELTA[0:20, :], axis = 1)
    DELTA2 = np.mean(MFCC_DELTA2[0:20, :], axis = 1)
    STD = np.std(MFCC, axis = 1)                        # Find Standard d\Deviation of MFCC along the time axis
    #return np.concatenate([[RMS, CT, BW, ZC, RF], STD, MEAN, DELTA, DELTA2], axis = 0)
    return np.concatenate([MEAN, STD], axis = 0)
    #return MEAN

def cross_val(C, train_data, train_target):
    clf = SVC(C = C, kernel = 'rbf', gamma = 'auto') 
    #clf = LinearSVC(C = C,  tol=1e-9, max_iter=1e9)
    #clf = LogisticRegression(C = C, random_state = 0, solver='lbfgs', max_iter = 500)
    #clf = DecisionTreeClassifier()
    #clf = KNeighborsClassifier(n_neighbors = C)                                           
    for cvIdx, (trainIdx, devIdx) in enumerate(Kf.split(range(len(train_data)))):
        TrainFeat, TestFeat = sc.fit_transform(train_data[trainIdx]), sc.fit_transform(train_data[devIdx])   # seperate into train set and validation set
        TrainLabel, TestLabel = train_target[trainIdx], train_target[devIdx]
        clf.fit(TrainFeat, TrainLabel)                                                                       # Train the model by train set
        prediction = clf.predict(TestFeat)                                                                   # Make prediction on validation set
        y_dev_cv.extend(TestLabel)
        y_predict_cv.extend(prediction)                                                                      # Make prediction on validation set
    return clf

#%% Loading training and test data
train_path = sorted(glob(os.path.join(DataPath, 'wav_train', 'train*.wav')))
test_path = sorted(glob(os.path.join(DataPath, 'wav_dev', 'dev*.wav')))

X_train = [MFCC_feat(path) for path in train_path]
test_data = [MFCC_feat(path) for path in test_path]

#%% Reading labels
labels = pd.read_csv(os.path.join(DataPath, 'labels.csv'))
name2label = dict((row['file_name'], row['label']) for idx, row in labels.iterrows())
y_train = [name2label[os.path.basename(path)] for path in train_path]
#X_train, X_test, y_train, y_test = train_test_split(X_train, y_train,
#                                                    stratify=y_train, 
#                                                   test_size=0.2)

#%% Training SVM model
#X_train, y_train = ada.fit_resample(X_train, y_train)
#X_train, y_train = tl.fit_resample(X_train, y_train)
X_train = np.vstack(X_train)
y_train = np.array(y_train)
C = Counter(y_train)
print('Train ', C)

'''
X_test = np.vstack(X_test)
y_test = np.array(y_test)
X_test = sc.fit_transform(X_test)
C = Counter(y_test)
print('Test ', C)
'''




for C in range(15, 16):
    print('C = ', C / 10)
    clf = cross_val(C, X_train, y_train)
    #accuracy = accuracy_score(y_dev_cv, y_predict_cv)                                      # Calculate the accuracy  
    FS = f1_score(y_dev_cv, y_predict_cv, average = None)
    #print('Total Test F1Score = ', FS)
    #print('Total Test F1Score = ', f1_score(y_dev_cv, y_predict_cv, average = 'weighted'))
    #cm = confusion_matrix(y_dev_cv, y_predict_cv, labels = classNames)                     # construct the confusion matrix
    #plot_confusion_matrix(cm , classNames)                                                 # plot the confusion maritrix
    #print('Train Set ACC = ',  accuracy) 
    
    '''
    y_pred = clf.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    FS = f1_score(y_test, y_pred, labels = classNames, average = None)
    print('Total Test F1Score = ', FS)
    print('Total Test F1Score = ', f1_score(y_test, y_pred, average = 'weighted'))
    #print('Train Set ACC = ',  accuracy)
    '''
    

X_test = np.vstack(test_data)
X_test = sc.fit_transform(X_test)
y_pred = clf.predict(X_test)

#%% Saving results into csv
results = pd.DataFrame({'file_name':[os.path.basename(f) for f in test_path], 'Predicted':y_pred})
results.to_csv('results.csv', index=False)
