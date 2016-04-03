MOD_NAME = "Mod Character Rebalancing 2"
MOD_PREFIX = "MCR2"
MOD_ID = ""
MOD_VERSION = "1.0.0"

-- This library function allows us to use a file in a specified location.
-- Allows use to call global environment variables without initializing them in our files.
modimport("libs/env.lua")

-- Scripts Initialization.
use "data/scripts/init"

-- Actions Initialization.
use "data/actions/init"

-- Character Initialization.
use "data/characters/init"

-- Component Initialization.
use "data/components/init"

-- Screens Initialization.
use "data/screens/init"

-- Widgets Initialization.
use "data/widgets/controls"
