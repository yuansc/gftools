REM gfinit.cmd 
REM 
REM Allow using .gfsettings file at the git repository root
REM to share git flow settings with team.
REM 
@ECHO off
SETLOCAL
SET GFSETTINGS=.gfsettings
FOR /f usebackq %%G IN (`git rev-parse --git-dir`) DO (
	ECHO %%G
	IF "%%G" EQU ".git" (
		ECHO "at the root"
		IF EXIST %GFSETTINGS% (
			ECHO "Shared git flow settings defined"
		)
	) ELSE (
		ECHO "Not at the root"
		FOR /F "delims=." %%p IN ("%%G") DO (
			SET GFSETTINGS=%%p.gfsettings
		)
	)
)
IF NOT EXIST %GFSETTINGS% (
	ECHO Failed to access file %GFSETTINGS%.  Batch aborted.	
) ELSE (
	ECHO Initializing git flow using %GFSETTINGS%
    REM git flow init -df
	FOR /F "eol=# tokens=1,2 delims==" %%p IN (%GFSETTINGS%) DO (
		FOR /F "delims=." %%z IN ("%%p") DO (
			IF %%z EQU gitflow (
				ECHO %%p %%q
			) ELSE (
				ECHO Skipping unrecognized property "%%p".
			)
 		)
	)
    REM git config --local -l
)
ENDLOCAL