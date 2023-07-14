#
#       Feedforward neural network for binary classification -
#
#
#       Software is distributed without any warranty;
#       bugs should be reported to antonio.pecchia@unisannio.it
#

import numpy as np
import pandas as pd
import matplotlib as mpl
import tensorflow as tf

mpl.use('TkAgg')
import matplotlib.pyplot as plt
from keras.models import Model
from keras.layers import Input, Dense, Activation
from keras import regularizers, initializers

tf.random.set_seed(123)


class FeedforwardNN():

    def __init__(self, input_dim):
        input_layer = Input(shape=(input_dim,))

        # Per aggiungere un altro layer nascosto, ricorda di modificare i collegamenti a fine riga
        # layer2 = Dense(6, activation='tanh', kernel_initializer=initializers.RandomNormal())(input_layer)

        layer = Dense(2, activation='tanh', kernel_initializer=initializers.RandomNormal())(input_layer)

        # È l'unico livello che non dobbiamo cambiare
        output_layer = Activation(activation='softmax')(layer)

        self.classifier = Model(inputs=input_layer, outputs=output_layer)

    def summary(self, ):
        self.classifier.summary()

    def train(self, x, y):
        epochs = 5
        batch_size = 2048
        validation_split = 0.1

        self.classifier.compile(optimizer='rmsprop', loss='categorical_crossentropy')
        history = self.classifier.fit(x, y, epochs=epochs, batch_size=batch_size, validation_split=validation_split,
                                      shuffle=True, verbose=2)

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

    def predict(self, x_evaluation):
        predictions = self.classifier.predict(x_evaluation)
        outcome = predictions[:, 0] > predictions[:, 1]
        return outcome
