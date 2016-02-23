# Clipboard.ninja

Online realtime clipboard for exchanging text between computers and mobile devices.

See the website [https://clipboard.ninja](https://clipboard.ninja).
Or download the [Android App in the Play Store](https://play.google.com/store/apps/details?id=nl.trafex.apps.clipboardninja)

## Features

 * It's realtime; you'll see the text immediately appear on the receiving device.
 * It's secure; the connection to the server is encrypted with SSL.
 * It's private; you first need to connect to the sender before you can send something, this way the data never has to be (temporarily) stored on the server.
 * You can connect multiple receivers to one sender.
 * No registration is needed, a 6 digit number is enough to connect the devices.

## Docker
Run the Docker container yourself (uses a selfsigned certificate)

    sudo docker run --name clipboard.ninja -p 80:80 -p 433:433 trafex/clipboard.ninja

Add this to your hosts file and go to https://clipboard.ninja:

    127.0.0.1 clipboard.ninja
