# Metamask Integration 

I have to develop a flutter application which have the capability to connect with the Metamask wallet, fetch the address details and perform the transaction by the app.


## Features

I always think for the architecture of the app because it’s the backbone of the application. I have used riverpod state management in this app with MVVM design pattern to ensure the scalability and usability.

To build the connection between the flutter app and metamask wallet, I have used the walletconnect_flutter_v2 along with the url_launcher plugin to execute the deeplink and navigate to the metamask app for connection.

The transaction are handled with web3dart plugin which give the leverage to get account details and perform transaction between two addresses.

I have also implemented custom periodic task manager which helps to track transaction status using transaction receipt and refresh the balance of the connected account on time. Also it is connected to the life cycle of the app so it auto stop the processes when the app is terminated this helps to protect from memory leak.

