-- Configuration: Replace these with your GitHub details
local username = "sqEquat"                      -- Your GitHub username
local repo = "FissionReactorControlSystem"      -- Your repository name
local branch = "main"                           -- The branch name (default: "main")
local base_api_url = string.format(
    "https://api.github.com/repos/%s/%s/contents/",
    username, repo
)

-- Local versioning file
local version_file = "./lib_versions.txt"

-- Function to fetch JSON data from a URL
local function fetch_json(url)
    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()
        return textutils.unserializeJSON(content)
    else
        error("Failed to fetch data from: " .. url)
    end
end

-- Load local version file
local function load_versions()
    if fs.exists(version_file) then
        local handle = fs.open(version_file, "r")
        local data = textutils.unserialize(handle.readAll())
        handle.close()
        return data or {}
    end
    return {}
end

-- Save versions to the local version file
local function save_versions(versions)
    local handle = fs.open(version_file, "w")
    handle.write(textutils.serialize(versions))
    handle.close()
end

-- Recursive function to process files and folders
local function process_folder(path, local_versions, updated_versions)
    print("Processing folder: " .. path)
    local url = base_api_url .. path .. "?ref=" .. branch
    local files = fetch_json(url)

    if type(files) ~= "table" then
        error("Unexpected response from GitHub API for path: " .. path)
    end

    for _, file in ipairs(files) do
        if file.type == "file" then
            local filename = file.name
            local sha = file.sha -- GitHub's unique hash for the file
            local file_url = file.download_url
            local relative_path = fs.combine(path, filename)

            updated_versions[relative_path] = sha

            -- Check if the file needs to be updated
            if local_versions[relative_path] ~= sha then
                print("Updating " .. relative_path .. "...")
                local success, err = pcall(function()
                    -- Ensure the folder exists before downloading
                    local folder_path = fs.getDir(relative_path)
                    if not fs.exists(folder_path) then
                        fs.makeDir(folder_path)
                    end
                    shell.run("wget", file_url, relative_path)
                end)

                if success then
                    print(relative_path .. " updated successfully!")
                else
                    print("Failed to update " .. relative_path .. ": " .. err)
                end
            else
                print(relative_path .. " is up to date.")
            end

        elseif file.type == "dir" then
            -- Recursively process subfolders
            process_folder(path .. "/" .. file.name, local_versions, updated_versions)
        end
    end
end

-- Update libs
local function update_libs(local_versions, updated_versions)
    -- Process the /lib folder recursively
    print("Starting update process for /lib...")
    process_folder("lib", local_versions, updated_versions)
    print("All libs processed.")
end

-- Update common scripts
local function update_base(local_versions, updated_versions)
        -- Process the /base folder recursively
        print("Starting update process for /base...")
        process_folder("base", local_versions, updated_versions)
        print("All base scripts processed.")
end

-- Update main scripts
local function update_module(local_versions, updated_versions)
    -- Process the /base folder recursively
    if arg[1] then
        local module = arg[1]
        print("Starting update process for module " .. module .. "...")

        if module:lower() == "watcher" then
            print("Updating FRCS Watcher module...")
            process_folder("watcher", local_versions, updated_versions)
        else
            print("No such module found: " .. module)
        end

        print("Module processed.")
    else
        print("No module specified, skip module update...")
    end
end

local function main()
    local local_versions = load_versions()
    local updated_versions = {}

    -- Process libs, update local verisions
    -- update_libs(local_versions, updated_versions)

    -- Process base scripts, update local versions
    update_base(local_versions, updated_versions)

    -- Process module
    update_module(local_versions, updated_versions)

    -- Save the updated versions of files 
    save_versions(updated_versions)
    print("All files processed.")
end

-- Run the updater
main()
