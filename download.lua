local file_path = "install.lua"
local file_url = "https://raw.githubusercontent.com/sqEquat/FissionReactorControlSystem/main/install.lua"

print("Downloading FRCS install script...")
shell.run("wget", file_url, file_path)
print("Script successfully downloaded.")
