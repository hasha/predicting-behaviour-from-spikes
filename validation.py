

from sklearn.ensemble import RandomForestClassifier
import scipy.io as sio
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import GridSearchCV
import numpy as np


# In[2]:

num_sessions = 47
accuracy_both = []
accuracy_fr = []
accuracy_r = []

#f1_score = make_scorer(f1_score)

clf = RandomForestClassifier

param_grid = {"criterion"         : ["entropy"],
           "max_depth"         : [10, 20, 30, 40],
           "min_samples_split" : [2, 4, 6] }


def tune_parameters(features,labels,param_grid):
    clf = RandomForestClassifier()
    clf_tuned = GridSearchCV(clf, param_grid, scoring='precision',verbose=2,n_jobs=5)
    clf_tuned.fit(features,labels)
    clf_tuned = clf_tuned.best_estimator_
    return clf_tuned

for s in range(num_sessions):
    all_trials = sio.loadmat(str(s+1) + ".mat")
    all_matrix = np.append(all_trials['fr1'],all_trials['fr2'],axis=1)
    all_matrix = np.append(all_matrix,np.absolute(all_trials['r']),axis=1)
    all_matrix = np.append(all_matrix,all_trials['b'],axis=1)
    
    clf = tune_parameters(all_matrix[:,0:3], all_matrix[:,-1],param_grid)
                                            
    scores_both = cross_val_score(clf, all_matrix[:,0:3], all_matrix[:,-1], cv=60,scoring='precision')
    scores_fr = cross_val_score(clf, all_matrix[:,0:2], all_matrix[:,-1], cv=60,scoring='precision')
    scores_r = cross_val_score(clf, all_matrix[:,2:3], all_matrix[:,-1], cv=60,scoring='precision')
    
    accuracy_both.append(np.sum(scores_both)/60)
    accuracy_fr.append(np.sum(scores_fr)/60)
    accuracy_r.append(np.sum(scores_r)/60)


