MBFontPickerTableViewController
===============================

UITableViewController subclassed which can be used to select a UIFont. This class displays the user-friendly name of the font.

Font names include all fonts available on iOS 6.1



How To
======

See [Demo project](https://github.com/mattbauch/MBFontPickerDemo) to see how it's used. Should be self-explanatory. 


Version History
===============

0.1 initial version  
0.2 selected font is highlighted. moved into its own repository  
0.2.1 License changed to WTFPL  
0.2.2 FIX: Use self.contentSizeForViewInPopover for sub font picker that is pushed with the accessory button  
0.3.0 Allow to set dictionaries for our custom fonts  
0.3.1 FIX: Only scroll to selected font when this was explicitly requested.  
0.3.2 Feature: We can now get the display name through a class method when supplying a custom font list  

TODO
====

- add display names and default fonts for custom fonts




License
=======

Copyright (c) 2013 Matthias Bauch <dev@matthiasbauch.com>  
This work is free. You can redistribute it and/or modify it under the  
terms of the Do What The Fuck You Want To Public License, Version 2,  
as published by Sam Hocevar. See the COPYING file for more details.  

