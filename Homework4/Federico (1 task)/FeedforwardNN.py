#
#       Feedforward neural network for binary classification -
#
#
#       Software is distributed without any warranty;
#       bugs should be reported to antonio.pecchia@unisannio.it
#
import keras.layers
import numpy as np
import pandas as pd
import matplotlib as mpl
import tensorflow as tf
from keras.initializers import RandomNormal
from custom_utils import ModelConfiguration

mpl.use('TkAgg')
import matplotlib.pyplot as plt
from keras.models import Model
from keras.layers import Input, Dense, Activation
from keras import regularizers, initializers
from keras.utils import plot_model
from keras.layers import Dropout
import pydot
import graphviz


class FeedforwardNN():
    classifier = None

    def __init__(self, input_dim):
        # Costruiamo il layer di input utilizzando il layer di Keras
        # Doc: keras.io/api/layers
        # shape = numero di neuroni. input_dim sarà quindi 81 (# features)
        input_layer = Input(shape=(input_dim,))

        # Costruiamo hidden layer
        hidden_layer = Dense(256,activation='tanh',kernel_initializer=RandomNormal())(input_layer)  # Con quesata sintassi sitamo dicendo che colleghiamo questo layer a input_layer
        hidden_layer = Dense(256,activation='tanh',kernel_initializer=RandomNormal())(hidden_layer)  # Con quesata sintassi sitamo dicendo che colleghiamo questo layer a input_layer
        hidden_layer = Dense(2,activation='relu',kernel_initializer=RandomNormal())(hidden_layer)  # Con quesata sintassi sitamo dicendo che colleghiamo questo layer a input_layer

        output_layer = Activation(activation='softmax')(hidden_layer)

        # Ora istanziamo il modello vero e proprio come parametro della classe
        # Qui sono tutti kwargs, quindi specifichiamo inputs e outputs
        self.classifier = Model(inputs=input_layer, outputs=output_layer)

    # Summary fornisce una descrizione sintetica del modello
    def summary(self, ):
        self.classifier.summary()

    def train(self, x, y):
        # Definiamo epoche e batch_size...
        epochs = 200
        batch_size = 512
        validation_split = 0.01  # Riserviamo il 0.1% del training set per validare(?)

        # Settaggio dell'ottimizzatore e della Loss function
        self.classifier.compile(
            optimizer='adam',  # RootMeanSquareProp è l'MSE. Volendo si può passare anche un optimizer fatto da noi ad hoc che contiene anche altre configurazioni (es. leraning rate)
            loss='categorical_crossentropy',  # Loss function vista nelle slides
        )

        # Facciamo training ora
        history = self.classifier.fit(
            x=x,
            y=y,
            epochs=epochs,  # Quante volte facciamo ripassare sul trainig set
            batch_size=batch_size,
            # Spacchetto in gruppi da 2048 record e faccio aggiornamento dei pesi una volta ogni 2048 records
            validation_split=validation_split,  #
            shuffle=True,
            # I dati non vengono presi in ordine, ma randomicamente per evitare un'eventuale polarizzazione
        )  # La funzione restituisce un dataframe contenente report dell'allenamento.

        # -----------------------------------------------#
        #           instructor-provided code            #
        # -----------------------------------------------#
        plt.plot(history.history['loss'])
        plt.plot(history.history['val_loss'])
        plt.title('model loss')
        plt.ylabel('loss')
        plt.xlabel('epoch')
        plt.legend(['training', 'validation'], loc='upper right')
        plt.show()

        df_history = pd.DataFrame(history.history)
        return df_history

    # Prende in ingresso un insieme di punti e calcola l'uscita.
    # Per vedere se il modello è buono, confrontiamo questa uscita con la Y vera e vediamo quanto si trova
    def predict(self, x_evaluation):
        predictions = self.classifier.predict(x_evaluation)
        # La seguente istruzione prende i casi in cui il modello ha predetto BENIGN=True, DoS=False
        outcome = predictions[:,0] > predictions[:,1]
        # print(predictions)
        # print(outcome)
        return outcome

    def plot(self, path):
        plot_model(self.classifier, to_file=path, show_shapes=True)
