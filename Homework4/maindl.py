#
#       Main program to train / validate / test the models
#
#       Software is distributed without any warranty;
#       bugs should be reported to antonio.pecchia@unisannio.it
#
import os

from utils import transformData, evaluatePerformance
from FeedforwardNN import FeedforwardNN

from AutoEncoder import AutoEncoder

train = os.path.join(os.path.dirname(os.path.abspath(__file__)), "hw4Data\\TRAIN.csv")
train_ae = os.path.join(os.path.dirname(os.path.abspath(__file__)), "hw4Data\\TRAIN_AE.csv")
validation = os.path.join(os.path.dirname(os.path.abspath(__file__)), "hw4Data\\VALIDATION.csv")
test = os.path.join(os.path.dirname(os.path.abspath(__file__)), "hw4Data\\TEST.csv")

x_train, y_train, l_train, x_val, y_val, l_val, x_test, y_test, l_test = transformData(train_ae, validation, test)

print('x_train = ' + str(x_train.shape))
print('y_train = ' + str(y_train.shape))
print('x_val = ' + str(x_val.shape))
print('y_val = ' + str(y_val.shape))

input_dim = x_train.shape[1]

# ------------------------------------------#
#           SUPERVISED LEARNING             #
# ------------------------------------------#
# ffnn = FeedforwardNN(input_dim=input_dim)
# ffnn.summary()
# ffnn.train(x_train, y_train)
# outcome = ffnn.predict(x_val)
# evaluatePerformance(outcome, l_val)
# print('')
# print('\tTest Set')
# outcome = ffnn.predict(x_test)
# evaluatePerformance(outcome, l_test)

# -----------------------------------------------#
#           SEMI-SUPERVISED LEARNING             #
# -----------------------------------------------#
ae = AutoEncoder(input_dim=input_dim)
ae.summary()
ae.train(x_train, x_train)
outcome = ae.predict(x_val)
evaluatePerformance(outcome, l_val)
ae.plot_reconstruction_error(x_val, l_val)
