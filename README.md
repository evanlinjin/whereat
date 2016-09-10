# Where AT?
A Public Transport App Written in Qt  
![Where AT?](https://raw.githubusercontent.com/evanlinjin/whereat/master/whereat/whereat.png)

## Introduction
Currently this app only supports the Ubuntu Touch Operating System, and only provides information from the Auckland Transport API. In the future, I plan to port it to Android, Ubuntu Desktop and Windows 10. More backends will also be supported in the future.

![Join the Where AT? Telegram Group Chat.](https://telegram.me/joinchat/B_ax-AqUnb6L8Nl742uFyw)

## Additional Files
In order to build, you need to provide your own `/whereat/keys.h` file.
This needs to be in the following format:
```
#ifndef KEYS_H
#define KEYS_H

#include <QString>

namespace Keys {
    const QString atApi = "XXXX"; // Auckland Transport API Key.
}

#endif // KEYS_H
```
## Authors
* Evan Chih-Yu Lin ([evan.linjin@gmail.com](evan.linjin@gmail.com))
