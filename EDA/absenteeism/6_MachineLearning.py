#!/usr/bin/env python
# coding: utf-8

# # Absenteeism Excercise: Logistic Regression

# In[1]:


#lecture53
import numpy as np #sklearn
import pandas as pd #stats


# In[2]:


data_preprocessed = pd.read_csv('Absenteeism_preprocessed.csv')
data_preprocessed.head()


# In[3]:


#lecture54
absent_median = data_preprocessed['Absenteeism Time in Hours'].median()
targets = np.where(data_preprocessed['Absenteeism Time in Hours'] > absent_median, 1, 0)
#print(targets)
data_preprocessed['Excessive Absenteeism'] = targets


# In[4]:


print(targets.shape)
targets.sum()/targets.shape[0]


# In[5]:


data_targets = data_preprocessed.drop(['Date','Absenteeism Time in Hours'], axis=1)
data_targets.info()


# In[6]:


#lecture55: selecting inputs
data_targets.iloc[:,0:14].head(10)


# In[7]:


#same thing but efficient
unscaled_data = data_targets.iloc[:,:-1]
unscaled_data.info()


# ### Standardize the data

# In[8]:


#Standarize the data
#lecture56: statistical preprocessing
from sklearn.preprocessing import StandardScaler
#lecture61: correction
#absenteeism_scalar = StandardScaler() #standardized using z-score method


# In[9]:


#lecture61:
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.preprocessing import StandardScaler

class CustomScaler(BaseEstimator, TransformerMixin):

    def __init__(self, columns, copy=True, with_mean=True, with_std=True):
        self.scaler = StandardScaler(copy, with_mean, with_std)
        self.columns = columns
        self.mean_ = None
        self.var_ = None
        
    def fit(self, X, y = None):
        self.scaler.fit(X[self.columns], y)
        self.mean_ = np.mean(X=[self.columns])
        self.var_ = np.var(X[self.columns])
        return self
    
    def transform(self, X, y = None, copy = None):
        init_col_order = X.columns
        X_scaled = pd.DataFrame(self.scaler.transform(X[self.columns]), columns = self.columns)
        X_not_scaled = X.loc[:,~X.columns.isin(self.columns)]
        return pd.concat([X_not_scaled,X_scaled], axis = 1)[init_col_order]


# In[10]:


unscaled_data.columns.values


# In[11]:


columns_to_omit = ['Reason_1','Reason_2','Reason_3','Reason_4','Education']
columns_to_scale = [x for x in unscaled_data.columns.values if x not in columns_to_omit]


# In[12]:


absenteeism_scaler = StandardScaler(columns_to_scale)


# In[13]:


absenteeism_scaler.fit(unscaled_data)


# In[14]:


scaled_data = absenteeism_scaler.transform(unscaled_data)


# In[15]:


scaled_data


# In[16]:


#lecture57: train test split
from sklearn.model_selection import train_test_split
#random state works like set.seed


# In[17]:


train_test_split(scaled_data,targets)


# In[18]:


x_train, x_test, y_train, y_test = train_test_split(scaled_data, targets, train_size = 0.8, shuffle=True, random_state = 20)
#80% of data is used for training
print(x_train.shape, y_train.shape)
print(x_test.shape, y_test.shape)


# In[19]:


#lecture58
from sklearn.linear_model import LogisticRegression
from sklearn import metrics


# In[20]:


#training model
reg = LogisticRegression()


# In[21]:


reg.fit(x_train,y_train)


# In[22]:


#accuracy
reg.score(x_train,y_train)


# In[23]:


#manually check the accuracy
model_outputs = reg.predict(x_train)


# In[24]:


model_outputs


# In[25]:


y_train


# In[26]:


model_outputs == y_train


# In[27]:


sum(model_outputs == y_train)/y_train.shape[0]


# In[28]:


#lecture59
#intercept/bias
reg.intercept_


# In[29]:


#coefficients/weights
reg.coef_


# In[30]:


#scaled_data.columns.values #error
unscaled_data.columns.values


# In[31]:


feature_name = unscaled_data.columns.values
#feature_name
summary_table = pd.DataFrame(columns =['Feature name'], data = feature_name)
summary_table['Coefficient'] = np.transpose(reg.coef_)
summary_table


# In[32]:


summary_table.index = summary_table.index+1
summary_table.loc[0] = ['Intercept', reg.intercept_[0]]
summary_table = summary_table.sort_index()
summary_table


# In[33]:


summary_table['Odds_ratio'] = np.exp(summary_table.Coefficient)
summary_table


# In[34]:


summary_table.sort_values('Odds_ratio', ascending=False)


# ### Testing the model

# In[36]:


#lecture64
reg.score(x_test,y_test)


# In[39]:


predicted_prob = reg.predict_proba(x_test)
predicted_prob


# In[41]:


predicted_prob.shape


# In[42]:


predicted_prob[:,1]


# In[45]:


#save model
import pickle


# In[46]:


with open('model','wb') as file:
    pickle.dump(reg, file)


# In[48]:


with open('scaler','wb') as file:
    pickle.dump(absenteeism_scaler, file)


# In[ ]:




