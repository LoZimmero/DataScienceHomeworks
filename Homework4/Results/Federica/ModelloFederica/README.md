# Configurazione
## Machine #Lenovo: 
- Lenovo Ideapad 330S
- Windows 11 Home 22H2
- Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz 1.8 GHz
- keras 2.13.1 / tensorflow 2.13

# Risultati

## Autoencoder

### Parametri utilizzati

- Epochs: 50
- batch_size: 2048
- validation_split: 0.1
- optimizer: rmsprop
- loss: mean_squared_error
- Modello: In immagine AutoEncoderModello.png

Risultati: In immagine AutoEncoderResults.png


## FFNN
### Parametri utilizzati

- Epochs: 100
- batch_size: 256
- validation_split: 0.1
- optimizer: adam
- loss: categorical_crossentropy
- Modello: In immagine FFNNModel-Federica.png.png

Risultati: In immagine FFNNResults-Federica.png.png