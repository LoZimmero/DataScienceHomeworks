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

mpl.use('TkAgg')
import matplotlib.pyplot as plt

from keras.models import Model
from keras.layers import Input, Dense, Activation
from keras import regularizers, initializers

tf.random.set_seed(123)


class AutoEncoder():

    def __init__(self, input_dim):
        input_layer = Input(shape=(input_dim,))
        # layer_a = Dense(16, activation='relu', kernel_initializer=initializers.RandomNormal())(input_layer)
        layer = Dense(8, activation='relu', kernel_initializer=initializers.RandomNormal())(input_layer)
        # layer_b = Dense(16, activation='relu', kernel_initializer=initializers.RandomNormal())(layer)
        output_layer = Dense(input_dim, activation='tanh', kernel_initializer=initializers.RandomNormal())(layer)

        self.autoencoder = Model(inputs=input_layer, outputs=output_layer)

    def summary(self, ):
        self.autoencoder.summary()

    def train(self, x, y):

        epochs = 15
        batch_size = 2048
        validation_split = 0.1

        self.autoencoder.compile(optimizer='rmsprop', loss='mean_squared_error')
        history = self.autoencoder.fit(x, y, epochs=epochs, batch_size=batch_size, validation_split=validation_split,
                                       shuffle=True, verbose=2)

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

        print('THRESHOLD = ' + str(self.threshold))

        df_history = pd.DataFrame(history.history)
        return df_history

    def predict(self, x_evaluation):

        # 1.    obtain reconstructions
        reconstructions = self.autoencoder.predict(x_evaluation)

        # 2.    compute RE input VS reconstructions
        RE = np.mean(np.power(x_evaluation - reconstructions, 2), axis=1)

        # 3.    confronto RE - threshold
        outcome = RE <= self.threshold

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
