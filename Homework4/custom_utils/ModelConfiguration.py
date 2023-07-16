import keras


class ModelConfiguration:
    epochs: int = 10
    batch_size = 2048
    validation_split = 0.01  # Riserviamo il 0.1% del training set per validare
    classifier: keras.Model
    optimizer_function: str
    loss_function: str
    # Info on optimizers and loss functions that can be used: https://www.tutorialspoint.com/keras/keras_model_compilation.htm

    def __init__(self, epochs: int, batch_size: int, validation_split: float, classifier: keras.Model, optimizer_function: str = 'rmsprop',
                 loss_function: str = 'categorical_crossentropy'):
        self.epochs = epochs
        self.batch_size = batch_size
        self.validation_split = validation_split
        self.classifier = classifier
        self.optimizer_function = optimizer_function
        self.loss_function = loss_function
