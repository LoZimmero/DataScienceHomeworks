#
#       Autoencoder  (semi-supervised learning / anomaly detection)
#
#
#       Software is distributed without any warranty;
#       bugs should be reported to antonio.pecchia@unisannio.it
#


import numpy as np
import pandas as pd
import tensorflow as tf
import matplotlib as mpl
from keras.initializers import RandomNormal

mpl.use('TkAgg')
import matplotlib.pyplot as plt

from keras.models import Model
from keras.layers import Input, Dense, Activation
from keras import regularizers, initializers
from tensorflow.keras.optimizers import Adam

tf.random.set_seed(123)


class AutoEncoder():

    def __init__(self, input_dim):
        input_layer = Input(shape=(input_dim,))

        # Questo hidden layer deve ridurre le features in input
        hidden_layer = Dense(input_dim*0.8, activation='relu') (input_layer)
        hidden_layer = Dense(input_dim*0.2, activation='relu') (hidden_layer)    # Bottleneck
        hidden_layer = Dense(input_dim*0.8, activation='relu') (hidden_layer)
        output_layer = Dense(input_dim, activation='tanh') (hidden_layer)  # Qui in homework si possono fare varie prove (es. su activation)

        self.autoencoder = Model(inputs=input_layer, outputs=output_layer)

    def summary(self, ):
        self.autoencoder.summary()

    def train(self, x, y):

        # NB: nella scelta di questi parametri bisogna trovare un compromesso tra epochs e batch_size.
        epochs = 200
        batch_size = 64
        validation_split = 0.1  # Da 0.1 a 0.15

        # Qui per la funzione di loss non usiamo categorical_crossentropy perché m
        # non è adeguata al dominio. Usiamo invece minimun square difference perché si
        # avvicina a errore di distanza.
        self.autoencoder.compile(optimizer='adam', loss='mean_squared_error')

        history = self.autoencoder.fit(
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
        #           instructor-provided code             #
        # -----------------------------------------------#
        plt.plot(history.history['loss'])
        plt.plot(history.history['val_loss'])
        plt.title('model loss')
        plt.ylabel('loss')
        plt.xlabel('epoch')
        plt.legend(['training', 'validation'], loc='upper right')
        plt.show()

        #   Computation of the detection threshold with a percentage
        #       of the training set equal to 'validation_split'

        x_thSet = x[x.shape[0] - (int)(x.shape[0] * validation_split):x.shape[0] - 1, :]
        self.threshold = self.computeThreshold(x_thSet)
        print(f"Threshold: {self.threshold}")

        df_history = pd.DataFrame(history.history)
        return df_history

    def predict(self, x_evaluation):
        # obiettivo: Vedere se i dati sulla x superano la soglia.
        # 1. Fare ricostruzione di input
        reconstructions = self.autoencoder.predict(x_evaluation)  # Predizioni = ricostruzioni dell'input

        # 2. Calcoliamo RE distanze --> recostruction vs input
        RE = np.mean(np.power(x_evaluation - reconstructions, 2),axis=1)  # axis=1 per specificare la "direzione"

        # 3. Confronto tra RE e Trashold
        # In questo vettore i FALSE sono i DoS
        outcome = RE <= self.threshold  # True se i valori NON superano la soglia, False altrimenti
        return outcome

    # -----------------------------------------------#
    #           instructor-provided code             #
    # -----------------------------------------------#
    def computeThreshold(self, x_thSet):

        x_thSetPredictions = self.autoencoder.predict(x_thSet)
        mse = np.mean(np.power(x_thSet - x_thSetPredictions, 2), axis=1)
        threshold = np.percentile(mse, 95)

        return threshold

    # -----------------------------------------------#
    #           instructor-provided code             #
    # -----------------------------------------------#
    def plot_reconstruction_error(self, x_evaluation, evaluationLabels):

        predictions = self.autoencoder.predict(x_evaluation)
        mse = np.mean(np.power(x_evaluation - predictions, 2), axis=1)

        trueClass = evaluationLabels != 'BENIGN'

        errors = pd.DataFrame({'reconstruction_error': mse, 'true_class': trueClass})

        groups = errors.groupby('true_class')
        fig, ax = plt.subplots(figsize=(8, 5))
        right = 0
        for name, group in groups:
            if max(group.index) > right: right = max(group.index)

            ax.plot(group.index, group.reconstruction_error, marker='o', ms=5, linestyle='', markeredgecolor='black',
                    # alpha = 0.5,
                    label='Normal' if int(name) == 0 else 'Attack', color='green' if int(name) == 0 else 'red')

        ax.hlines(self.threshold, ax.get_xlim()[0], ax.get_xlim()[1], colors='red', zorder=100, label='Threshold',
                  linewidth=4, linestyles='dashed')
        ax.semilogy()
        ax.legend()
        plt.xlim(left=0, right=right)
        plt.title('Reconstruction error for different classes')
        plt.grid(True)
        plt.ylabel('Reconstruction error')
        plt.xlabel('Data point index')
        plt.show()
