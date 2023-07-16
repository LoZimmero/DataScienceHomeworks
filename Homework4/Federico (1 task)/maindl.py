#
#       Main program to train / validate / test the models
#
#       Software is distributed without any warranty;
#       bugs should be reported to antonio.pecchia@unisannio.it
#
from AutoEncoder import AutoEncoder
from FeedforwardNN import FeedforwardNN
from utils import transformData, evaluatePerformance
#from FeedforwardNN import FeedforwardNN
#from AutoEncoder import AutoEncoder

def ffnn():


    train = 'hw4Data/TRAIN.csv'
    validation = 'hw4Data/VALIDATION.csv'
    test = 'hw4Data/TEST.csv'

    x_train, y_train, l_train, x_val, y_val, l_val, x_test, y_test, l_test = transformData(training=train, validation=validation, test=test)

    print(f'x_train: {x_train.shape}')  #(10000, 81)
    print(f'y_train: {y_train.shape}')  #(10000, 2)
    print(f'x_val: {x_val.shape}')
    print(f'y_val: {y_val.shape}')

    input_dim = x_train.shape[1] #81
    ffnn = FeedforwardNN(input_dim=input_dim)  #feed-forward NN
    # Per testare se la ffnn funziona:
    ffnn.summary()

    ffnn.train(x_train,y_train) #Training del modello

    outcome = ffnn.predict(x_val)
    evaluatePerformance(outcome, l_val)

    # Ora usiamo il test set
    outcome = ffnn.predict(x_test)
    evaluatePerformance(outcome, l_test)
    ffnn.plot(r".\visualizations\ffnn.png")

def autoencoder():
    train = 'hw4Data/TRAIN_AE.csv'
    validation = 'hw4Data/VALIDATION.csv'
    test = 'hw4Data/TEST.csv'

    x_train, y_train, l_train, x_val, y_val, l_val, x_test, y_test, l_test = transformData(training=train,
                                                                                           validation=validation,
                                                                                           test=test)

    print(f'x_train: {x_train.shape}')  # (10000, 81)
    print(f'y_train: {y_train.shape}')  # (10000, 2)
    print(f'x_val: {x_val.shape}')
    print(f'y_val: {y_val.shape}')

    input_dim = x_train.shape[1]  # 81
    ae = AutoEncoder(input_dim=input_dim)  # feed-forward NN
    # Per testare se la ffnn funziona:
    ae.summary()

    ae.train(x_train, x_train)  # Training del modello. NB: Qui mettiamo 2 volte x_train e x_train perché l'output atteso è proprio l'input

    # test with validation set
    outcome = ae.predict(x_val)
    evaluatePerformance(outcome, l_val)
    # PlotReconstructionError ci permette di visualizzare gli errori di predizione
    ae.plot_reconstruction_error(x_val, l_val)

    # Ora usiamo il test set
    outcome = ae.predict(x_test)
    evaluatePerformance(outcome, l_test)
    ae.plot_reconstruction_error(x_test, l_test)

#ffnn()
autoencoder()