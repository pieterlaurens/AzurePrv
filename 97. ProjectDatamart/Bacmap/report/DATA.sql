/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILEGROUP [DATA]
GO

ALTER DATABASE [$(DatabaseName)] 
ADD FILE 
(
    NAME = 'projectStaging_d1',
    FILENAME = '$(DefaultDataPath)$(DatabaseName)_d1.ndf',
    SIZE = 1000MB,
	MAXSIZE = UNLIMITED,
    FILEGROWTH = 500MB
), 
(
    NAME = 'projectStaging_d2',
    FILENAME = '$(DefaultDataPath)$(DatabaseName)_d2.ndf',
    SIZE = 1000MB,
	MAXSIZE = UNLIMITED,
    FILEGROWTH = 1500MB
), 
(
    NAME = 'projectStaging_d3',
    FILENAME = '$(DefaultDataPath)$(DatabaseName)_d3.ndf',
    SIZE = 1000MB,
	MAXSIZE = UNLIMITED,
    FILEGROWTH = 500MB
), 
(
    NAME = 'projectStaging_d4',
    FILENAME = '$(DefaultDataPath)$(DatabaseName)_d4.ndf',
    SIZE = 1000MB,
	MAXSIZE = UNLIMITED,
    FILEGROWTH = 500MB
), 
(
    NAME = 'projectStaging_d5',
    FILENAME = '$(DefaultDataPath)$(DatabaseName)_d5.ndf',
    SIZE = 1000MB,
	MAXSIZE = UNLIMITED,
    FILEGROWTH = 500MB
), 
(
    NAME = 'projectStaging_d6',
    FILENAME = '$(DefaultDataPath)$(DatabaseName)_d6.ndf',
    SIZE = 1000MB,
	MAXSIZE = UNLIMITED,
    FILEGROWTH = 500MB
), 
(
    NAME = 'projectStaging_d7',
    FILENAME = '$(DefaultDataPath)$(DatabaseName)_d7.ndf',
    SIZE = 1000MB,
	MAXSIZE = UNLIMITED,
    FILEGROWTH = 500MB
), 
(
    NAME = 'projectStaging_d8',
    FILENAME = '$(DefaultDataPath)$(DatabaseName)_d8.ndf',
    SIZE = 1000MB,
	MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
) TO FILEGROUP DATA;

