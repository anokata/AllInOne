FOR /F "tokens=* USEBACKQ" %%F IN (`date /T`) DO (
SET var=%%F
)
ECHO %var%