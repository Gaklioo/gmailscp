gMail = {}
gMail.BaseDir = "gmailscp/"

function gMail.Log(...)
    local args = {...}
    print(table.concat(args, " "))
end

function gMail.LoadShared(f)
    gMail.Log("Loading File Shared " .. f)
    if SERVER then
        AddCSLuaFile(f)
        include(f)
    else
        include(f)
    end
end

function gMail.LoadServer(f)
    gMail.Log("Loading File Server " .. f)
    if SERVER then
        include(f)
    end
end

function gMail.LoadClient(f)
    gMail.Log("Loading File Client " .. f)
    if SERVER then
        AddCSLuaFile(f)
    else
        include(f)
    end
end

function gMail.LoadEverything(basePath)
    local files, directories = file.Find(basePath .. "*", "LUA")

    for k, v in pairs(files) do
        local path = basePath .. v
      
        if string.find(path, "sh_") then
            gMail.LoadShared(path)
        elseif string.find(path, "sv_") then
            gMail.LoadServer(path)
        elseif string.find(path, "cl_") then
            gMail.LoadClient(path)      
        end
    end

    for _, dir in ipairs(directories) do
        gMail.LoadEverything(basePath .. dir .. "/")
    end
end

gMail.LoadEverything(gMail.BaseDir)