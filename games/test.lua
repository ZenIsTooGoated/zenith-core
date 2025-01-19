
local httpService = game:GetService("HttpService")
local scriptManager = {}
do
    scriptManager.Library = nil

end

function scriptManager:SetLibrary(library)
    self.Library = library
end

function scriptManager:BuildSection(tab)
    

    assert(self.Library, "set the library first")
    local library = self.Library
    
    local gameSection = tab:Section({
        Side = "Left"
    })

    

end

return scriptManager
