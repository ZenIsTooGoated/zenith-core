local httpService = game:GetService("HttpService")

local InterfaceManager = {} do



    function InterfaceManager:SetLibrary(library)
		self.Library = library
	end

  

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set Library")
		local Library = self.Library
       
        local leftSect = tab:Section({
            Side = "Left"
        })

        leftSect:Button({
            Name = "example button",
            Callback = function()
                print("something ig")
            end
        })
        
        
    end
end

return InterfaceManager
