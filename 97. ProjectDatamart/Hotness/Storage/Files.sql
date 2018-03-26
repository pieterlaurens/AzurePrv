/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [ch1],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_ch1.ndf',
		SIZE = 50MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	),(
		NAME = [ch2],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_ch12.ndf',
		SIZE = 50MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	),(
		NAME = [ch3],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_ch3.ndf',
		SIZE = 50MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	),(
		NAME = [ch4],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_ch4.ndf',
		SIZE = 50MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	),(
		NAME = [ch5],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_ch5.ndf',
		SIZE = 50MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	),(
		NAME = [ch6],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_ch6.ndf',
		SIZE = 50MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	),(
		NAME = [ch7],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_ch7.ndf',
		SIZE = 50MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	),(
		NAME = [ch8],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_ch8.ndf',
		SIZE = 50MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	) TO FILEGROUP DATA
	
