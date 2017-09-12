class Config(object):
    DEBUG = True
    SERVER_NAME = 'legit.nach.os'

class EvilConfig(Config):
	EVIL = True

class LegitConfig(Config):
    EVIL = False
