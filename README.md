# Dash Docset for Pebble Smartwatch SDK

Dash is an amazing documentation viewer. Find out more at http://kapeli.com/dash.

The currently available docset is for Pebble's SDK Version 2.0.

Regenerate the docset with the supplied ruby script and sqlite. The script dumps out SQL commmands rather than opening the database directly, so this commandline should do ya:

``ruby generate-pebble-sdk-docset.rb | sqlite3 ./Pebble.docset/Contents/Resources/docSet.dsidx``

Enjoy!