# DropKoBox

To install simply run *build.sh* and copy the generated *KoboRoot.tgz* to the *.kobo* folder on your Kobo device. After unplugging, the device will reboot to install the required files.
The app will run each time the Wifi connection is enabled.

To generate your Dropbox token click on [this link](https://www.dropbox.com/1/oauth2/authorize?client_id=bzpzn9rahc4du3l&response_type=token&redirect_uri=https://www.mydropkoboxwebsite.com/dropkobox_token) and copy the returned token from the generated URL.
Then insert it in the *.kobo/dropkobox/dropkobox.cfg* file on your Kobo.
