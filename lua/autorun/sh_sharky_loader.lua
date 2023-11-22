do
	if CLIENT then
		local fol = 'sharky/'
		local files, folders = file.Find(fol .. '*', 'LUA')

		for _, fil in SortedPairs(files, true) do
			local config = string.sub(fil, 1, 3)
			if config == 'sh_' then
				include(fol .. fil)
				MsgC( Color(176,255,255), "[Sharky] '", Color(255,255,255), fol .. fil, Color(255,255,255), "'\n")
			end
		end

		for _, folder in SortedPairs(folders, true) do
		    for _, File in SortedPairs(file.Find(fol .. folder .. '/*.lua', 'LUA'), true) do
				local stringsub = string.sub(File, 1, 3)
		        if stringsub == 'cl_' || stringsub == 'sh_'  then
		            include(fol .. folder .. '/' .. File)
		        end
				MsgC( Color(176,255,255), "[Sharky] '", Color(255,255,255), fol .. folder .. "/" .. File, Color(255,255,255), "'\n")
		    end
		end
	elseif SERVER then
		local fol = 'sharky/'
		local files, folders = file.Find(fol .. '*', 'LUA')

		for _, fil in SortedPairs(files, true) do
			local config = string.sub(fil, 1, 3)
			if config == 'sh_' then
				AddCSLuaFile(fol .. fil)
				include(fol .. fil)
				MsgC( Color(176,255,255), "[Sharky] '", Color(255,255,255), fol .. fil, Color(255,255,255), "'\n")
			end
		end

		for _, folder in SortedPairs(folders, true) do
		    for _, File in SortedPairs(file.Find(fol .. folder .. '/*.lua', 'LUA'), true) do
				local stringsub = string.sub(File, 1, 3)
		        if stringsub == 'sv_' then
		            include(fol .. folder .. '/' .. File)
		        elseif stringsub == 'cl_' then
		            AddCSLuaFile(fol .. folder .. '/' .. File)
		        elseif stringsub == 'sh_' then
		            AddCSLuaFile(fol .. folder .. '/' .. File)
					include(fol .. folder .. '/' .. File)
		        end
		        MsgC( Color(176,255,255), "[Sharky] '", Color(255,255,255), fol .. folder .. "/" .. File, Color(255,255,255), "'\n")
		    end
		end
	end
end