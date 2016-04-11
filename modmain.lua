-- This library function allows us to use a file in a specified location.
-- Allows use to call global environment variables without initializing them in our files.
modimport("engine.lua")

-- Imports to keep the keyhandler from working while typing in chat.
Load "chatinputscreen"
Load "consolescreen"
Load "textedit"

MOD_NAME = "Mod Character Rebalancing 2"
MOD_AUTHOR = "DrSmugleaf"
MOD_PREFIX = "MCR2"
MOD_ID = ""
MOD_VERSION = "1.0.0"

-- Scripts Initialization.
Load "data/scripts/init"

-- Actions Initialization.
Load "data/actions/init"

-- Character Initialization.
Load "data/characters/init"

-- Component Initialization.
Load "data/components/init"

-- Screens Initialization.
Load "data/screens/init"

-- Widgets Initialization.
Load "data/widgets/init"
