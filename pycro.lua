VERSION = "0.0.1"

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")
local buffer = import("micro/buffer")


function init()
    config.MakeCommand("pyfmt", pyfmt, config.NoComplete)
    config.MakeCommand("black", pyfmt, config.NoComplete)
end

function onSave(bp)
    if bp.Buf:FileType() == "python" then
       pyfmt(bp)
    end
    return true
end

function pyfmt(bp)
    bp:Save()
    local _, err = shell.RunCommand("black " .. bp.Buf.Path)
    if err ~= nil then
        micro.InfoBar():Error(err)
        return
    end
    bp.Buf:ReOpen()
end
