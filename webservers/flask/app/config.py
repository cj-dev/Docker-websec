class Config(object):
    DEBUG = True

class EvilConfig(Config):
	EVIL = True

class LegitConfig(Config):
    EVIL = False
