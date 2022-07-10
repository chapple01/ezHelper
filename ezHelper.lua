script_name('ezHelper')
script_author('CHAPPLE')
script_version("1.3.5")
script_properties('work-in-pause')

local tag = "{fff000}[ezHelper]: {ffffff}"
require "lib.moonloader"
local vkeys = require "vkeys"
local rkeys = require "rkeys"
local sampev = require 'lib.samp.events'
local inicfg = require "inicfg"
local ecfg = require "ecfg"
local directIni = "ezHelper/ezHelper"
local imgui = require 'mimgui'
local new = imgui.new
local ffi = require 'ffi'
local fa = require('fAwesome5')
local memory = require 'memory'
local bass = require "lib.bass"
local radio = bass.BASS_StreamCreateFile(false, "moonloader/resource/ezHelper/02070.mp3", 0, 0, 0)

local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local clock, gsub, gmatch, find, ceil, len = os.clock, string.gsub, string.gmatch, string.find, math.ceil, string.len
local renderWindow = new.bool()
local TimeWeatherWindow = new.bool()
local hud = new.bool(true)
local obvodka = new.bool(false)
local sizeX, sizeY = getScreenResolution()
local font = renderCreateFont('segmdl2', 10, 5) --(пїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ)
local lasthp = 0
local razn = nil
local hp = 0
local actv = false
local vsprint = false
local vwater = false
local spawn = false
local fillcar = false

imgui.OnInitialize(function()
	apply_custom_style()

	local config = imgui.ImFontConfig()
    config.MergeMode = true
	config.GlyphOffset.y = 1.0
	config.GlyphOffset.x = -5.0
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
    mainfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 16.0, nil, glyph_ranges) --пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
   	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 20.0, config, iconRanges) --пїЅпїЅпїЅпїЅпїЅпїЅ
	smallfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 14.0, nil, glyph_ranges) --пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 15.0, config, iconRanges) --пїЅпїЅпїЅпїЅпїЅпїЅ
	brandfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 15.0, nil, glyph_ranges) -- brands font
	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-brands-400.ttf', 20.0, config, iconRanges) --brands font
	hpfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 18.0, nil, glyph_ranges) --пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
   	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 16.0, config, iconRanges) --пїЅпїЅпїЅпїЅпїЅпїЅ

	imgui.GetIO().IniFilename = nil
end)


-------------------------------------ENCODING
local encoding = require 'encoding'
encoding.default = 'CP1251'         
local u8 = encoding.UTF8            
-------------------------------------ENCODING

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.last;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;ezMessage(b..'Обнаружено обновление. Обновляюсь c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')ezMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then ezMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/chapple01/ezHelper/main/version.json?" .. tostring(os.clock())
            Update.url = "https://github.com/chapple01/ezHelper"
        end
    end
end


--INI FILE
local inicfg = require "inicfg"
if not doesDirectoryExist('moonloader/config/ezHelper') then
	createDirectory('moonloader/config/ezHelper')
end

local mainIni = inicfg.load({
	fixes =
	{
		fixdver = false,
		fixgps = false,
		fixspawn = false,
		fixvint = false,
	},
	fpsup =
	{
		hidefam = false,
	},
	features =
	{
		autoid = false,
		fisheye = false,
		autopin = false,
		panicarz = false,
		fov = 70,
		pincode = 0,
	},
	afkcontrol =
	{
		afkcontrol = false,
		afkexit = false,
		afklimit = 300,
		afkexittime = 10,
	},
	carfuncs = 
	{
		autoscroll = false,
		autotwinturbo = false,
		autofill = false,
		carlight = false,
		antifine = false,
		trunk = false,
	},
	hud =
	{
		huds = true,
		hphud = true,
		rhp = true,
		energy = true,
		oxygen = true,
	},
	hudpos =
	{
		rhpX = 1605,
		rhpY = 50,
		hpX = 1724,
		hpY = 88,
		energyX = 1770,
		energyY = 262,
		oxygenX = 1770,
		oxygenY = 277,
	},
	TimeWeather =
	{
		twtoggle = true,
		hours = 12,
		weather = 0,
		realtime = true,
	}
}, directIni)

local cfg = {}
cfg.binds = {
    --{ name = "Название", text="текст", delay=555, hotkey= {1,2,3} }
}

filename = getGameDirectory()..'\\moonloader\\config\\ezHelper\\hotkeys.cfg'
ecfg.update(cfg, filename) -- загружает в переменную cfg значения из файла
ecfg.save(filename, cfg)
rhotkeys = {}
local tBlockChar = {[116] = true, [84] = true}
local tModKeys = {[vkeys.VK_MENU] = true, [vkeys.VK_SHIFT] = true, [vkeys.VK_CONTROL] = true}
local tBlockNextDown = {}

local tHotKeyData = {
    edit = nil,
	save = {},
   lastTick = os.clock(),
   tickState = false
}
local tKeys = {}

---------------------------
---------------------------
function refresh_binds()
	for index, value in ipairs(rhotkeys) do
		rkeys.unRegisterHotKey(value)
	end
	
	rhotkeys = {}

	for index, item in ipairs(cfg.binds) do
		local id = rkeys.registerHotKey(item.hotkey, 1, false, function() play_bind(item) end)
		table.insert(rhotkeys, id)
	end
	
end

refresh_binds()

---------------------------
---------------------------

if not doesFileExist("moonloader/config/ezHelper/ezHelper.ini") then inicfg.save(mainIni, "ezHelper/ezHelper.ini") end
inik = inicfg.load(mainIni, 'ezHelper/ezHelper')

local boolfixes = {
	fixdver = new.bool(inik.fixes.fixdver),
	fixgps = new.bool(inik.fixes.fixgps),
	fixspawn = new.bool(inik.fixes.fixspawn),
	fixvint = new.bool(inik.fixes.fixvint),
}

local binder = {
	delay = imgui.new.float(5),
	btext = new.char[10000](),
	bname = new.char[50]()
}
local bhotkey = {}
bhotkey.v = {}


local boolhud = {
	huds = new.bool(inik.hud.huds),
	hphud = new.bool(inik.hud.hphud),
	rhp = new.bool(inik.hud.rhp),
	energy = new.bool(inik.hud.energy),
	oxygen = new.bool(inik.hud.oxygen)
}

local features = {
	fisheye = new.bool(inik.features.fisheye),
	autoid = new.bool(inik.features.autoid),
	autopin = new.bool(inik.features.autopin),
	pincode = new.char[20](u8:decode(inik.features.pincode)),
	panicarz = new.bool(inik.features.panicarz)
}

local ezafk = {
	afkcontrol = new.bool(inik.afkcontrol.afkcontrol),
	afkexit = new.bool(inik.afkcontrol.afkexit),
	afklimit = new.int(inik.afkcontrol.afklimit),
	afkexittime = new.int(inik.afkcontrol.afkexittime)
}

local carfuncs = {
	autoscroll = new.bool(inik.carfuncs.autoscroll),
	autotwinturbo = new.bool(inik.carfuncs.autotwinturbo),
	autofill = new.bool(inik.carfuncs.autofill),
	carlight = new.bool(inik.carfuncs.carlight),
	antifine = new.bool(inik.carfuncs.antifine),
	trunk = new.bool(inik.carfuncs.trunk)
}

local WeaponsList = {"M4A1", "Combat Shotgun", "AK-47", 'Shotgun'}
local combobox = {
	current_weapon = imgui.new.int(0),
	weapons = imgui.new['const char*'][#WeaponsList](WeaponsList)
}

local TimeWeather = {
	twtoggle = new.bool(inik.TimeWeather.twtoggle),
	realtime = new.bool(inik.TimeWeather.realtime)
}

local slider = {
    hours = imgui.new.int(inik.TimeWeather.hours),
    weather = imgui.new.int(inik.TimeWeather.weather),
	fisheye = imgui.new.int(inik.features.fov)
}

local ui_meta = {
    __index = function(self, v)
        if v == "switch" then
            local switch = function()
                if self.process and self.process:status() ~= "dead" then
                    return false -- // Предыдущая анимация ещё не завершилась!
                end
                self.timer = os.clock()
                self.state = not self.state

                self.process = lua_thread.create(function()
                    local bringFloatTo = function(from, to, start_time, duration)
                        local timer = os.clock() - start_time
                        if timer >= 0.00 and timer <= duration then
                            local count = timer / (duration / 100)
                            return count * ((to - from) / 100)
                        end
                        return (timer > duration) and to or from
                    end

                    while true do wait(0)
                        local a = bringFloatTo(0.00, 1.00, self.timer, self.duration)
                        self.alpha = self.state and a or 1.00 - a
                        if a == 1.00 then break end
                    end
                end)
                return true -- // Состояние окна изменено!
            end
            return switch
        end
 
        if v == "alpha" then
            return self.state and 1.00 or 0.00
        end
    end
}

local rwindow = { state = false, duration = 0.5 }	--Основное окно
setmetatable(rwindow, ui_meta)

local TWWindow = { state = false, duration = 0.5 }	--ВремяПогода окно
setmetatable(TWWindow, ui_meta)

local popupwindow = { state = false, duration = 0.4 }
setmetatable(popupwindow, ui_meta)

local namePur = 0
local hidefam = new.bool(inik.fpsup.hidefam)
local cursor = new.bool(false)
local rhpX, rhpY = mainIni.hudpos.rhpX, mainIni.hudpos.rhpY
local hpX, hpY = mainIni.hudpos.hpX, mainIni.hudpos.hpY
local energyX, energyY = mainIni.hudpos.energyX, mainIni.hudpos.energyY
local oxygenX, oxygenY = mainIni.hudpos.oxygenX, mainIni.hudpos.oxygenY
local clock = 0
local gameClockk = 0
local afk = 0
local afks = 0
local countdialog = 0
local inputblock = false
local checkpopupwindow = false


local fa_icon = {
	['ICON_FA_VK'] = "\xef\x86\x89",
	['ICON_FA_TELEGRAM_PLANE'] = "\xef\x8f\xbe",
	['ICON_FA_DISCORD'] = "\xef\x8e\x92",
}

--ENDINI-----------------
--\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\//\\//\/\/\/\/\/\\/\/\/\/--
--KEYSNAMES------------------
vkeys.key_names[vkeys.VK_LMENU]				= "LAlt"
vkeys.key_names[vkeys.VK_RMENU]				= "RAlt"
vkeys.key_names[vkeys.VK_LSHIFT] 			= 'LShift'
vkeys.key_names[vkeys.VK_RSHIFT] 			= 'RShift'
vkeys.key_names[vkeys.VK_LCONTROL] 			= 'LCtrl'
vkeys.key_names[vkeys.VK_RCONTROL] 			= 'RCtrl'
vkeys.key_names[vkeys.VK_NUMLOCK] 			= 'NumLock'
vkeys.key_names[vkeys.VK_NUMPAD0]			= 'Num 0'
vkeys.key_names[vkeys.VK_NUMPAD1] 			= 'Num 1'
vkeys.key_names[vkeys.VK_NUMPAD2]			= 'Num 2'
vkeys.key_names[vkeys.VK_NUMPAD3] 			= 'Num 3'
vkeys.key_names[vkeys.VK_NUMPAD4] 			= 'Num 4'
vkeys.key_names[vkeys.VK_NUMPAD5] 			= 'Num 5'
vkeys.key_names[vkeys.VK_NUMPAD6] 			= 'Num 6'
vkeys.key_names[vkeys.VK_NUMPAD7] 			= 'Num 7'
vkeys.key_names[vkeys.VK_NUMPAD8] 			= 'Num 8'
vkeys.key_names[vkeys.VK_NUMPAD9] 			= 'Num 9'
vkeys.key_names[vkeys.VK_MULTIPLY] 			= 'Num *'
vkeys.key_names[vkeys.VK_ADD] 				= 'Num +'
vkeys.key_names[vkeys.VK_DECIMAL] 			= 'Num .'
vkeys.key_names[vkeys.VK_DIVIDE] 			= 'Num /'
--ENDKEYSNAMES------------------
--\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\//\\//\/\/\/\/\/\\/\/\/\/--
--MAIN
function main() 
    while not isSampAvailable() do
        wait(100)
    end
	lua_thread.create(function()
		if TimeWeather.twtoggle[0] == true then
			while true do wait(0)
				h = tonumber(os.date('%H'))
				if TimeWeather.realtime[0] == true then
					mainIni.TimeWeather.hours = h
					slider.hours[0] = h
					inicfg.save(mainIni, directIni)
				end

				setTime(slider.hours[0])
				setWeather(slider.weather[0])
			end
		end
	end)
	sampRegisterChatCommand('showdoor',function ()
        act = not act
		sampSetCursorMode(0)
    end)
    lua_thread.create(carfunc)
	sampRegisterChatCommand("ezhelper", function()
		if spawn == true then
			rwindow.switch()
			renderWindow[0] = true
			menu = 1
		else
			ezMessage("Для использования скрипта необходимо авторизоваться.")
		end
	end)
	applySampfuncsPatch()
	repeat
		wait(0)
	 until sampIsLocalPlayerSpawned()
	 spawn = true
	 	ezMessage('SUCCESFULL LOADED!!! Используйте: /ezhelper')
		files_add()
		sampRegisterChatCommand("delltd", function()
			for a = 0, 2304	do --cycle trough all textdeaw id
				sampTextdrawDelete(a)
			end
		end)
		sampRegisterChatCommand("fh", function(id)
			if id == "" then
				ezMessage("Введите ID дома: /fh [ID].")
			else
				sampSendChat('/findihouse '..id..'')
			end
		end)
		sampRegisterChatCommand("fbz", function(id)
			if id == "" then
				ezMessage("Введите ID бизнеса: /fbz [ID].")
			else
				sampSendChat('/findibiz '..id..'')
			end
		end)
		sampRegisterChatCommand("jb", function(id)
			if id == "" then
				sampSendChat('/jobprogress '..id..'')
			end
		end)
		sampRegisterChatCommand("cjb", function(id)
			if id == "" then
				ezMessage("Введите ID сотрудника: /cjb [ID].")
			else
				sampSendChat('/checkjobprogress '..id..'')
			end
		end)
		sampRegisterChatCommand("mb", function()
			sampSendChat("/members")
		end)
		sampRegisterChatCommand("st", function(hours)
			if TimeWeather.twtoggle[0] == true then
				if hours == "" then
					ezMessage("Введи число: /st [0-23].")
				else 
					local hours = tonumber(hours)
					if hours < 0 or hours > 23 then ezMessage("Значение должно быть не меньше 0 и не больше 23") else
						if hours >= 0 and hours <= 23 then ezMessage("Значение времени установлено на {F7E937}" .. hours)
							slider.hours[0] = hours
							mainIni.TimeWeather.hours = hours
							inicfg.save(mainIni, directIni)
							setTime(hours)
						end
					end
				end
			end
		end)
		sampRegisterChatCommand("sw", function(weather)
			if twtoggle[0] == true then
				if weather == "" then
					ezMessage("Введи число: /sw [0-23].")
				else 
					local weather = tonumber(weather)
					if weather < 0 or weather > 45 then ezMessage("Значение должно быть не меньше 0 и не больше 45") else
						if weather >= 0 and weather <= 45 then ezMessage("Значение погоды установлено на {F7E937}" .. weather)
							slider.weather[0] = weather
							mainIni.TimeWeather.weather = weather
							inicfg.save(mainIni, directIni)
							setTime(weather)
						end
					end
				end
			end
		end)
		
----------------------------------------------SpawnFix
		if boolfixes.fixspawn[0] == true then
			memory.fill(0x4217F4, 0x90, 21, true)
			memory.fill(0x4218D8, 0x90, 17, true)
			memory.fill(0x5F80C0, 0x90, 10, true)
			memory.fill(0x5FBA47, 0x90, 10, true)
		end
------------------------------------------------------

	if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.url)
    end
    while true do
		wait(0)
--FISHEYE-----------------------------------------------------------
		if features.fisheye[0] == true then
			if isCurrentCharWeapon(PLAYER_PED, 34) and isKeyDown(2) then
				if not locked then 
					cameraSetLerpFov(70.0, 70.0, 1000, 1)
					locked = true
				end
			else
				cameraSetLerpFov(slider.fisheye[0], slider.fisheye[0], 1000, 1)
				locked = false
			end
		end
--FISHEYE-----------------------------------------------------------

		----------------------------------
		---------------------------------
		if BIND_START then
			BIND_START = false
			bindplay = true
			ezMessage('Чтобы остановить отыгровку, нажмите {FFD700}END')
			
			if BIND_THREAD then	
				BIND_THREAD:terminate()
			end
			
			BIND_THREAD = lua_thread.create(function()
				
				for bp in BIND_ITEM.text:gmatch('[^~]+') do
					if bindplay then
						
						sampProcessChatInput(tostring(bp))
						wait(BIND_ITEM.delay * 1000)

					end
					
				end
			end)
		end
		--------------------------------
		-------------------------------

--CARTWEAKS------------------------------------------------------------------------------------------
		if isKeyJustPressed(VK_L) and not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat("/lock")
		end
        if isKeyJustPressed(VK_O) and not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat("/olock")	
		end
        if isKeyJustPressed(VK_J) and not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat("/jlock")
		end
        if isKeyJustPressed(VK_K) and not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat("/key")
		end
		if isKeyJustPressed(VK_BACK) and not sampIsChatInputActive() and not sampIsDialogActive() then
			bass.BASS_ChannelStop(radio)
			
		end
		if isKeyJustPressed(VK_END) and not sampIsChatInputActive() and not sampIsDialogActive() then
			bindplay = false
		end
		--[[sampev.onDisplayGameText = function(style, time, text)
			sampAddChatMessage('Текст: '..text, -1)
		end]]

		--famhide
		for i=0, 2048 do
			if sampIs3dTextDefined(i) and hidefam[0] == true then
				local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(i)
				if text:find("Family") or text:find("Empire") or text:find("Squad") or text:find("Dynasty") or text:find("Corporation") or text:find("Crew") or text:find("Brotherhood") or text:find("Club") then
				sampDestroy3dText(i)
				end
			end
		end


------------------------------------------------------------------------------------------------------

--FIXES-----------------------------------------------------------------------------------------------
		


		if boolfixes.fixdver[0] == true then
			if isKeyJustPressed(VK_H) and not sampIsChatInputActive() and not sampIsDialogActive() then
				sampSendChat("/opengate")
			end
		end

		if boolfixes.fixvint[0] == true then
			memory.fill(0x6C5107, 0x90, 59, true)
		else
			memory.hex2bin("8B5424088B4C24108B461452518B4C24686AFD508B44246C83EC0C8BD489028B842480000000894A048BCE894208E816DD01008A4E36C0E9033ACB", 0x6C5107, 59)
		end

		if carfuncs.autoscroll[0] == true then
			_, pid = sampGetPlayerIdByCharHandle(playerPed)
			anim = sampGetPlayerAnimationId(pid)	
			weapon = getCurrentCharWeapon(playerPed)
			
			if combobox.current_weapon[0] == 0 then
				if anim == 1014 or anim == 1013 then
					setCurrentCharWeapon(playerPed, 31)
				end
			end
			if combobox.current_weapon[0] == 1 then
				if anim == 1014 or anim == 1013 then
					setCurrentCharWeapon(playerPed, 27)
				end
			end
			if combobox.current_weapon[0] == 2 then
				if anim == 1014 or anim == 1013 then
					setCurrentCharWeapon(playerPed, 30)
				end
			end
			if combobox.current_weapon[0] == 3 then
				if anim == 1014 or anim == 1013 then
					setCurrentCharWeapon(playerPed, 25)
				end
			end
		end
		if ezafk.afkcontrol[0] == true then
			clock = gameClock()
			if isPauseMenuActive() then
				afk = clock - gameClockk
				afks = ("%.0f"):format(afk)
			else
				gameClockk = gameClock()
				afk = 0
			end
			if ezafk.afkexit[0] == true then
				if tonumber(afks) == ezafk.afklimit[0] then
					ShowMessage('Значение афк уже достигло '..ezafk.afklimit[0]..' секунд.\nЧерез '..ezafk.afkexittime[0]..' секунд игра закроется.', 'ezHelper', 0x30)
				end
				if tonumber(afks) == ezafk.afklimit[0] + ezafk.afkexittime[0] then
					os.execute('taskkill /IM gta_sa.exe /F')
				end
			else
				if tonumber(afks) == ezafk.afklimit[0] then
					ShowMessage('Значение афк уже достигло '..ezafk.afklimit[0]..' секунд.', 'ezHelper', 0x30)
				end
			end
		end
-------------------------------------------------------------------------------------------------------
    end
end

local thridFrame = imgui.OnFrame(
	function() return obvodka[0] end,
	function(player)
	if not isPauseMenuActive() then
		imgui.SetNextWindowPos(imgui.ImVec2(1550, 0), imgui.Cond.Always)
        imgui.SetNextWindowSize(imgui.ImVec2(400, 400), imgui.Cond.FirstUseEver)
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.0, 0.0, 0.0, 0.01))
        imgui.Begin(' ', obvodka, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		if cursor then
			player.HideCursor = cursor
		end
		imgui.SetCursorPos(imgui.ImVec2(2, 1));
		imgui.BeginChild(" ",imgui.ImVec2(366, 398), true)
		imgui.EndChild()
		imgui.PopStyleColor(1)
		imgui.End()
	end
end
)

local TimeWeatherFrame = imgui.OnFrame(
	function() return TWWindow.alpha > 0.00 end, -- Указываем здесь данное условие, тем самым рендеря окно только в том случае, если его прозрачность больше нуля
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 1.15), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(258, 150), imgui.Cond.FirstUseEver)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, TWWindow.alpha)
		renderFontDrawText(font,'Нажмите ESC, чтобы вернуться назад',500,500, 0xFF00BFFF)
        imgui.Begin("TimeWeather", TimeWeatherWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
		imgui.BeginChild("Time&Weather",imgui.ImVec2(250, 120), true)
			imgui.PushFont(mainfont)
			imgui.CenterTextColoredRGB("{1E90FF}Время и погода:")
			imgui.PopFont()

			imgui.PushFont(smallfont)
			imgui.SetCursorPos(imgui.ImVec2(14.500000,36.000000));
			imgui.Text(fa.ICON_FA_CLOCK)
			imgui.SetCursorPos(imgui.ImVec2(34.000000,32.000000));
			imgui.PushItemWidth(200)
			if imgui.SliderInt('##slider.time', slider.hours, 0, 23) then 
				inicfg.load(mainIni, directIni)
				setTime(slider.hours[0])
				mainIni.TimeWeather.hours = slider.hours[0]
				inicfg.save(mainIni, directIni)
			end
			imgui.PopItemWidth()

			imgui.SetCursorPos(imgui.ImVec2(12.000000,66.000000));
			imgui.Text(fa.ICON_FA_CLOUD_SUN)
			imgui.SetCursorPos(imgui.ImVec2(34.000000,62.000000));
			imgui.PushItemWidth(200)
			if imgui.SliderInt('##slider.weather', slider.weather, 0, 45) then
				inicfg.load(mainIni, directIni)
				setWeather(slider.weather[0])
				mainIni.TimeWeather.weather = slider.weather[0]
				inicfg.save(mainIni, directIni)
			end
			imgui.PopItemWidth()
			imgui.SetCursorPos(imgui.ImVec2(34.000000,92.000000));
			if imgui.Checkbox(u8"Реальное время", TimeWeather.realtime) then
				mainIni.TimeWeather.realtime = TimeWeather.realtime[0]
				inicfg.save(mainIni, directIni)
			end
			imgui.PopFont()
			imgui.ezHint('Синхронизирует время на компьютере с игровым временем.',
			hpfont, mainfont, 14.000000, 92.500000)
		imgui.EndChild()
		imgui.CenterTextColoredRGB('Нажмите ESC, чтобы вернуться назад')
		imgui.End()
		imgui.PopStyleVar(1)
	end
)

            

local secondFrame = imgui.OnFrame(
	function() return hud[0] end,
	function(player)
		if boolhud.huds[0] == true then
		if spawn == true then
		invent = sampTextdrawIsExists(2106)
		txdraw = sampTextdrawIsExists(2064)
		end
		if not isPauseMenuActive() and invent == false and txdraw == false then
		imgui.SetNextWindowPos(imgui.ImVec2(1550, 0), imgui.Cond.Always)
        imgui.SetNextWindowSize(imgui.ImVec2(400, 400), imgui.Cond.FirstUseEver)
       	imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.0, 0.0, 0.0, 0.01))
        imgui.Begin('', hud, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		imgui.PopStyleColor(1)
		player.HideCursor = true
		imgui.DisableInput = true
		if spawn == true then
			if boolhud.huds[0] == true then
				_, pid = sampGetPlayerIdByCharHandle(playerPed)
				hp = sampGetPlayerHealth(pid)
				razn = hp - lasthp
				if actv == true and boolhud.rhp[0] == true then
					if razn >1 and razn ~= 0 and razn then
						if razn >=10 then
							imgui.PushFont(hpfont)
							imgui.SetCursorPos(imgui.ImVec2(rhpX + 8 - 1550, rhpY + 17));
							imgui.IconColoredRGB("{FF0000}+"..razn)
							imgui.SetCursorPos(imgui.ImVec2(rhpX + 42 - 1550, rhpY + 16.5));
							imgui.IconColoredRGB("{FF0000}"..fa.ICON_FA_HEART)
							imgui.PopFont()
						else
							imgui.PushFont(hpfont)
							imgui.SetCursorPos(imgui.ImVec2(rhpX + 15 - 1550, rhpY + 17));
							imgui.IconColoredRGB("{FF0000}+"..razn)
							imgui.SetCursorPos(imgui.ImVec2(rhpX + 42 - 1550, rhpY + 16.5));
							imgui.IconColoredRGB("{FF0000}"..fa.ICON_FA_HEART)
							imgui.PopFont()
						end
					end
				end
		
				if boolhud.hphud[0] == true then
					imgui.SetCursorPos(imgui.ImVec2(hpX - 1550, hpY - 20));
					imgui.PushFont(brandfont)
					imgui.TextColoredRGB("{FFFFFF}"..hp)
					imgui.PopFont()
				end

				if boolhud.oxygen[0] == true then
					ox = getCharOxygen()
					water = isCharInWater(playerPed)
					if isCharInAnyCar(playerPed) then
						carhandle = storeCarCharIsInNoSave(playerPed)
						carinwater = isCarInWater(carhandle)
						if water == true or carinwater == true then
							drawBar(oxygenX, oxygenY, 139.5, 9, 0xFF00BFFF, 0xFF0080ab, 0, font, ox)
						end
					else
						if water == true  then
							drawBar(oxygenX, oxygenY, 139.5, 9, 0xFF00BFFF, 0xFF0080ab, 0, font, ox)
						end
					end
				end

				if boolhud.energy[0] == true then
					sprint = getSprintLocalPlayer(playerPed)
					if sprint >=99 and vsprint == false then
					else
						drawBar(energyX, energyY, 139.5, 9, 0xFFFFD700, 0xFFb39700, 0, font, sprint)
					end
				end
			end
    	end
		imgui.End()
	end
end
end
)


local newFrame = imgui.OnFrame(
	function() return rwindow.alpha > 0.00 end, -- Указываем здесь данное условие, тем самым рендеря окно только в том случае, если его прозрачность больше нуля
    function(player)
        player.HideCursor = not rwindow.state -- // Курсор будет убираться на моменте, когда окно начинает исчезать
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(650, 400), imgui.Cond.FirstUseEver)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, rwindow.alpha)
        imgui.Begin("ezHelper v1.3.5", renderWindow, imgui.WindowFlags.NoResize)
		imgui.DisableInput = false
            imgui.BeginChild("child",imgui.ImVec2(180, 366), false)
				if renderWindow[0] == false then
					rwindow.switch()
					renderWindow[0] = true
				end

                imgui.SetCursorPos(imgui.ImVec2(5.000000,5.000000));
				imgui.PushFont(mainfont)
				if imgui.AnimatedButton(fa.ICON_FA_HOME .. u8"Главная", imgui.ImVec2(170, 55)) then menu = 1 end
				imgui.PopFont()
				imgui.PushFont(mainfont)
				imgui.SetCursorPos(imgui.ImVec2(5.000000,70.000000));
				if imgui.AnimatedButton(fa.ICON_FA_COGS .. u8"Функции", imgui.ImVec2(170, 55)) then menu = 2 end
				imgui.PopFont()
				imgui.PushFont(mainfont)
				imgui.SetCursorPos(imgui.ImVec2(5.000000,135.000000));
				if imgui.AnimatedButton(fa.ICON_FA_EDIT .. u8"Бинды", imgui.ImVec2(170, 55)) then imgui.OpenPopup('BinderOrHotkey') popupwindow.switch() end
				imgui.PopFont()
				imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, popupwindow.alpha)
				if imgui.BeginPopupModal('BinderOrHotkey', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
					imgui.BeginChild("##E1ditBinder", imgui.ImVec2(250, 90), false)
					imgui.PushFont(smallfont)
					imgui.CenterTextColoredRGB("Что вы хотите открыть?")
					imgui.PopFont()
					imgui.PushFont(mainfont)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
					imgui.SetCursorPos(imgui.ImVec2(3.000000,22.000000));
					if imgui.AnimatedButton(fa.ICON_FA_CLIPBOARD..u8'Биндер', imgui.ImVec2(120,50), 0.15) then
						menu = 'binder'
						popupwindow.switch()
						checkpopupwindow = true
					end
					imgui.SameLine()
					imgui.SetCursorPos(imgui.ImVec2(128.000000,22.000000));
					if imgui.AnimatedButton(fa.ICON_FA_KEYBOARD..u8'Хоткеи', imgui.ImVec2(120,50), 0.15) then
						ezMessage('Данная функция временно не доступна')
					end
					imgui.PopStyleVar()
					imgui.PopFont()
					if checkpopupwindow and popupwindow.alpha <= 0.09 then imgui.CloseCurrentPopup() checkpopupwindow = false end
					
					imgui.EndChild()
					imgui.EndPopup()
				end
				imgui.PopStyleVar()
				imgui.SetCursorPos(imgui.ImVec2(5.000000,300.000000));
				imgui.PushFont(mainfont)
				if imgui.AnimatedButton(fa.ICON_FA_INFO_CIRCLE .. u8"О скрипте", imgui.ImVec2(170, 55)) then menu = 3 end
				imgui.PopFont()

            imgui.EndChild()
			if menu == 1 then
				imgui.SetCursorPos(imgui.ImVec2(200.000000,25.000000));
				imgui.BeginChild("menu",imgui.ImVec2(430, 366), false)
				imgui.SetCursorPos(imgui.ImVec2(165.000000,25.000000));
				imgui.PushFont(mainfont)
				imgui.TextColoredRGB("{FFA500}Руководство.")
				imgui.PopFont()
				imgui.PushFont(smallfont)
				imgui.WrappedTextRGB(u8'{FFFAFA}Этот универсальный скрипт поможет вам при игре на сервере Arizonа RP.')
				imgui.Text(" ")
				imgui.TextColoredRGB("{1E90FF}Немного о его возомжностях:\n" ..
				"{ADD8E6}	- HUD+:\n" ..
				"{FFFAFA}		- Показывает в правом верхнем углу +HP\n" ..
				"{FFFAFA}		- Добавляет полоски кислорода и энергии.\n" ..
				"{FFFAFA}		- Легко настроить положение худа.\n" ..
				"{ADD8E6}	- Лёгкое управление транспортом:\n" ..
				"{FFFAFA}		- Легко открывать и закрывать транспорт по кнопке (L)\n" ..
				"{FFFAFA}		- Легко вытаскивать ключи из транспорта по кнопке (K)\n" ..
				"{FFFAFA}		- Легко закрывать организационный (O) и арендованный (J)\n" ..
				"{FFFAFA}          транспорт\n" ..
				"{FF0000}	-Фиксы:\n" ..
				"{FFFAFA}		-Двери, шлагбаумы, ворота открываются{FF4040} с первого раза\n" ..
				"{FFFAFA}		-Вы больше не спавнитесь с {FF4040}бутылкой{FFFAFA} / {FF4040}cигаретой{FFFAFA} в руках\n")
				

				imgui.PopFont()
				
				imgui.EndChild()
			end
			
			if menu == 2 then
				imgui.SetCursorPos(imgui.ImVec2(200.000000,25.000000));
				imgui.BeginChild("settings",imgui.ImVec2(430, 366), false)
				imgui.PushFont(mainfont)
				imgui.CenterTextColoredRGB("{1E90FF}Функции:")
				imgui.PopFont()
				imgui.Separator()
				
--////////////////////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------------CHECKBOX------------------------------------------------------------------
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\////////////////////////////////////////////////////////////////////--

			imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, 6.0)
				imgui.SetCursorPos(imgui.ImVec2(9.000000,25.000000));
				imgui.BeginChild("poleznoe",imgui.ImVec2(405, 110), true)

				imgui.PushFont(mainfont)
				imgui.CenterTextColoredRGB('{1E90FF}Полезное')
				imgui.PopFont()

				imgui.SetCursorPos(imgui.ImVec2(30.000000,20.000000));
				if imgui.Checkbox(u8"HideFamTag", hidefam) then
					mainIni.fpsup.hidefam = hidefam[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('Убирает над головой название фамы',
				hpfont, mainfont, 14.000000, 21.000000)
			
				imgui.SetCursorPos(imgui.ImVec2(30.000000,45.000000));
				if imgui.Checkbox(u8"АвтоPIN", features.autopin) then
					mainIni.features.autopin = features.autopin[0]
					inicfg.save(mainIni, directIni)
				end
				if features.autopin[0] == true then
					imgui.PushFont(smallfont)
					imgui.SetCursorPos(imgui.ImVec2(110.00000,48.600000));
					imgui.Text(fa.ICON_FA_COG)
					imgui.PopFont()
					if imgui.IsItemClicked() then
						imgui.OpenPopup('autopin')
					end
					if imgui.BeginPopup('autopin', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
						imgui.PushItemWidth(80)
						if imgui.InputText("##pincode", features.pincode, sizeof(features.pincode)) then
						mainIni.features.pincode = ffi.string(features.pincode) 
						inicfg.save(mainIni, directIni)
						end
						imgui.PopItemWidth()
						imgui.EndPopup()
					end
				end
				imgui.ezHint('Автоматически вводит PIN-код в банке.',
				hpfont, mainfont, 14.000000, 46.000000)

				imgui.SetCursorPos(imgui.ImVec2(30.000000,70.000000));
				if imgui.Checkbox(u8"FOV", features.fisheye) then
					mainIni.features.fisheye = features.fisheye[0]
					inicfg.save(mainIni, directIni)
				end
				if features.fisheye[0] == true then
					imgui.PushFont(smallfont)
					imgui.SetCursorPos(imgui.ImVec2(88.00000,73.600000));
					imgui.Text(fa.ICON_FA_COG)
					imgui.PopFont()
					if imgui.IsItemClicked() then
						imgui.OpenPopup('fisheye')
					end
					if imgui.BeginPopup('fisheye', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
						imgui.PushItemWidth(148.5)
						if imgui.SliderInt('##slider.fisheye', slider.fisheye, 50, 125) then
							inicfg.load(mainIni, directIni)
							mainIni.features.fov = slider.fisheye[0]
							inicfg.save(mainIni, directIni)
						end 
						imgui.PopItemWidth()
						imgui.EndPopup()
					end
				end
				imgui.ezHint('Можно изменять угол обзора камеры.\n'..
				'{808080}Так же убирает отдаление камеры в машине при большой скорости.',
				hpfont, mainfont, 14.000000, 71.000000)

				imgui.SetCursorPos(imgui.ImVec2(166.000000,21.000000));
				if imgui.Checkbox(u8"TimeWeather", TimeWeather.twtoggle) then
					mainIni.TimeWeather.twtoggle = TimeWeather.twtoggle[0]
					inicfg.save(mainIni, directIni)
				end
				if TimeWeather.twtoggle[0] == true then
					imgui.PushFont(smallfont)
					imgui.SetCursorPos(imgui.ImVec2(275.00000,24.600000));
					imgui.Text(fa.ICON_FA_COG)
					imgui.PopFont()
					if imgui.IsItemClicked() then	
						rwindow.switch()
						TWWindow.switch()
						sampSetChatDisplayMode(0)
					end
				end
				imgui.ezHint('Можно менять погоду на сервере\n'..
				'Есть возможность синхронизации времени с ПК.',
				hpfont, mainfont, 150.000000, 21.000000)

				imgui.SetCursorPos(imgui.ImVec2(166.000000,45.000000));
				if imgui.Checkbox(u8"AFK Control", ezafk.afkcontrol) then
					mainIni.afkcontrol.afkcontrol = ezafk.afkcontrol[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint(('Позволяет контролировать АФК.\n{808080}Полезно, если вы стоите на высоких должностях.'),
				hpfont, mainfont, 150.000000, 45.000000)

				if ezafk.afkcontrol[0] == true then
					imgui.PushFont(smallfont)
					imgui.SetCursorPos(imgui.ImVec2(268.00000,48.600000));
					imgui.Text(fa.ICON_FA_COG)
					imgui.PopFont()
					if imgui.IsItemClicked() then
						imgui.OpenPopup('afkcontrol')
					end
					if imgui.BeginPopup('afkcontrol', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
						local childsize = 60
						if ezafk.afkexit[0] then
							childsize = 80
						else
							childsize = 60
						end
						imgui.BeginChild("##afkcontrol",imgui.ImVec2(200, childsize), false)
						imgui.ezHint(('Лимит АФК, после которого вам выдаст предупреждение.'),
						hpfont, mainfont, 12.000000, 5.000000)
						imgui.SetCursorPos(imgui.ImVec2(27.00000,8.000000));
						imgui.Text(u8"Лимит АФК:")
						imgui.SetCursorPos(imgui.ImVec2(110.00000,5.000000));
						imgui.PushItemWidth(50)
						if imgui.InputInt(u8'сек##afklimit', ezafk.afklimit, 0, 1) then
							mainIni.afkcontrol.afklimit = ezafk.afklimit[0]
							inicfg.save(mainIni, directIni)
						end
						imgui.PopItemWidth()
						imgui.SetCursorPos(imgui.ImVec2(153.00000,8.000000));
						
						if ezafk.afkexit[0] == true then
							imgui.SetCursorPos(imgui.ImVec2(5.00000,55.000000));
							if imgui.Checkbox(u8"Выход при превышении", ezafk.afkexit) then
								mainIni.afkcontrol.afkexit = ezafk.afkexit[0]
								inicfg.save(mainIni, directIni)
							end
						else
							imgui.SetCursorPos(imgui.ImVec2(5.00000,30.000000));
							if imgui.Checkbox(u8"Выход при превышении", ezafk.afkexit) then
								mainIni.afkcontrol.afkexit = ezafk.afkexit[0]
								inicfg.save(mainIni, directIni)
							end
						end
						if ezafk.afkexit[0] == true then
							imgui.ezHint(('Выходит из игры, через '..ezafk.afkexittime[0]..' секунд.'),
							hpfont, mainfont, 12.000000, 30.000000)
							imgui.SetCursorPos(imgui.ImVec2(27.00000,33.000000));
							imgui.Text(u8"Выйти через:")
							imgui.SetCursorPos(imgui.ImVec2(110.00000,30.000000));
							imgui.PushItemWidth(50)
							if imgui.InputInt(u8'сек##afkexittime', ezafk.afkexittime, 0, 1) then
								mainIni.afkcontrol.afkexittime = ezafk.afkexittime[0]
								inicfg.save(mainIni, directIni)
							end
							imgui.PopItemWidth()
						end
						imgui.EndChild()
						imgui.EndPopup()
					end
				end

				imgui.SetCursorPos(imgui.ImVec2(166.000000,70.000000));
				if imgui.Checkbox(u8"PanicARZ", features.panicarz) then
					mainIni.features.panicarz = features.panicarz[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint(('Включает сирену, когда вам написали админы.\n{808080}Чтобы выключить сирену нажмите {DCDCDC}BACKSPACE.'),
				hpfont, mainfont, 150.000000, 70.000000)

				imgui.SetCursorPos(imgui.ImVec2(314.000000,20.000000));
				if imgui.Checkbox(u8"AutoID", features.autoid) then
					mainIni.features.autoid = features.autoid[0]
					inicfg.save(mainIni, directIni)
				end
				
				imgui.SetCursorPos(imgui.ImVec2(314.000000,45.000000));
				if imgui.Checkbox(u8"AScroll", carfuncs.autoscroll) then
					mainIni.carfuncs.autoscroll = carfuncs.autoscroll[0]
					inicfg.save(mainIni, directIni)
				end
				if carfuncs.autoscroll[0] == true then
					imgui.PushFont(smallfont)
					imgui.SetCursorPos(imgui.ImVec2(388.00000,49.600000));
					imgui.Text(fa.ICON_FA_COG)
					imgui.PopFont()
					if imgui.IsItemClicked() then
						imgui.OpenPopup('##autoscroll')
					end
					if imgui.BeginPopup('##autoscroll', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
						imgui.Combo("##weapon", combobox.current_weapon, combobox.weapons, #WeaponsList)
						imgui.EndPopup()
					end
				end

				imgui.SetCursorPos(imgui.ImVec2(314.000000,70.000000));
				if imgui.Checkbox(u8"HUD+", boolhud.huds) then
					mainIni.hud.huds = boolhud.huds[0]
					inicfg.save(mainIni, directIni)
				end
				if boolhud.huds[0] == true then
					imgui.PushFont(smallfont)
					imgui.SetCursorPos(imgui.ImVec2(380.00000,74.600000));
					imgui.Text(fa.ICON_FA_COG)
					imgui.PopFont()
					if imgui.IsItemClicked() then
						imgui.OpenPopup('##hud')
					end
					if imgui.BeginPopup('##hud', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
						imgui.BeginChild("hud+",imgui.ImVec2(165, 80), false)
					--HP+-----------------------------------------------------------------------------------------------------------------------
									imgui.SetCursorPos(imgui.ImVec2(5.000000,17.000000));
									if imgui.Checkbox(u8' ', boolhud.rhp) then
										mainIni.hud.rhp = boolhud.rhp[0]
										inicfg.save(mainIni, directIni)
									end
									imgui.SetCursorPos(imgui.ImVec2(30.000000,20.000000));
									imgui.Text(u8"HP+")
									if imgui.IsItemClicked() then
										lua_thread.create(function ()
											checkCursor = true
											actv = true
											sampSetCursorMode(4)
											ezMessage('Нажмите {0087FF}SPACE{FFFFFF} что-бы сохранить позицию')
											while checkCursor do
												obvodka[0] = true
												local cX, cY = getCursorPos()
												rhpX, rhpY = cX, cY
												if isKeyDown(32) then
													obvodka[0] = false
													sampSetCursorMode(0)
													mainIni.hudpos.rhpX, mainIni.hudpos.rhpY = rhpX, rhpY
													checkCursor = false
													actv = false
													if inicfg.save(mainIni, directIni) then ezMessage('Позиция сохранена!') end
												end
												wait(0)
											end
										end)
									end
									imgui.SetCursorPos(imgui.ImVec2(30.000000,20.000000));
									imgui.TextQuestion("	  ", u8'Убирает текст "+N.N HP". Выводит в место него сердечко с надписью возле худа.\nНажмите, чтобы изменить положение.')
					--HPHUD---------------------------------------------------------------------------------------------------------------------
									imgui.SetCursorPos(imgui.ImVec2(5.000000,47.000000));
									if imgui.Checkbox(u8'', boolhud.hphud) then
										mainIni.hud.hphud = boolhud.hphud[0]
										inicfg.save(mainIni, directIni)
									end
									imgui.SetCursorPos(imgui.ImVec2(32.000000,50.000000));
									imgui.Text(u8"HPHUD")
									if imgui.IsItemClicked() then
										lua_thread.create(function ()
											checkCursor = true
											sampSetCursorMode(4)
											ezMessage('Нажмите {0087FF}SPACE{FFFFFF} что-бы сохранить позицию')
											while checkCursor do
												local cX, cY = getCursorPos()
												obvodka[0] = true
												hpX, hpY = cX, cY
												if isKeyDown(32) then
													sampSetCursorMode(0)
													obvodka[0] = false
													mainIni.hudpos.hpX, mainIni.hudpos.hpY = hpX, hpY
													checkCursor = false
													if inicfg.save(mainIni, directIni) then ezMessage('Позиция сохранена!') end
												end
												wait(0)
											end
										end)
									end
									imgui.SetCursorPos(imgui.ImVec2(32.000000,50.000000));
									imgui.TextQuestion("		   ", u8"Самый обычный HPHUD. Показывает кол-во ХП.\nНажмите, чтобы изменить положение.")

									imgui.SetCursorPos(imgui.ImVec2(80.000000,17.000000));
									if imgui.Checkbox(u8'   ', boolhud.energy) then
										mainIni.hud.energy = boolhud.energy[0]
										inicfg.save(mainIni, directIni)
									end
					--Энергия---------------------------------------------------------------------------------------------------------------------
									imgui.SetCursorPos(imgui.ImVec2(106.000000,20.000000));
									imgui.Text(u8"Энергия")
									if imgui.IsItemClicked() then
										lua_thread.create(function ()
											checkCursor = true
											sampSetCursorMode(4)
											ezMessage('Нажмите {0087FF}SPACE{FFFFFF} что-бы сохранить позицию')
											while checkCursor do
												local cX, cY = getCursorPos()
												vsprint = true
												obvodka[0] = true
												energyX, energyY = cX, cY
												if isKeyDown(32) then
													sampSetCursorMode(0)
													mainIni.hudpos.energyX, mainIni.hudpos.energyY = energyX, energyY
													vsprint = false
													obvodka[0] = false
													checkCursor = false
													if inicfg.save(mainIni, directIni) then ezMessage('Позиция сохранена!') end
												end
												wait(0)
											end
										end)
									end
									imgui.SetCursorPos(imgui.ImVec2(106.000000,20.000000));
									imgui.TextQuestion("		  	", u8"Показывает полоску энергии.\nНажмите, чтобы изменить положение.")
					--Кислород---------------------------------------------------------------------------------------------------------------------
						imgui.SetCursorPos(imgui.ImVec2(80.000000,47.000000));
						if imgui.Checkbox(u8'     ', boolhud.oxygen) then
							mainIni.hud.oxygen = boolhud.oxygen[0]
							inicfg.save(mainIni, directIni)
						end
						imgui.SetCursorPos(imgui.ImVec2(106.000000,50.000000));
						imgui.Text(u8"Кислород")
						if imgui.IsItemClicked() then
							lua_thread.create(function ()
								checkCursor = true
								vwater = true
								obvodka[0] = true
								sampSetCursorMode(4)
								ezMessage('Нажмите {0087FF}SPACE{FFFFFF} что-бы сохранить позицию')
								while checkCursor do
									local cX, cY = getCursorPos()
									oxygenX, oxygenY = cX, cY
									if vwater == true then
										drawBar(oxygenX, oxygenY, 139.5, 9, 0xFF00BFFF, 0xFF0080ab, 0, font, ox)
									end
									if isKeyDown(32) then
										obvodka[0] = false
										sampSetCursorMode(0)
										mainIni.hudpos.oxygenX, mainIni.hudpos.oxygenY = oxygenX, oxygenY
										vwater = false
										checkCursor = false
										if inicfg.save(mainIni, directIni) then ezMessage('Позиция сохранена!') end
									end
									wait(0)
								end
							end)
						end
						imgui.SetCursorPos(imgui.ImVec2(106.000000,50.000000));
						imgui.TextQuestion("		  	", u8"Показывает полоску кислорода.\nНажмите, чтобы изменить положение.")
						
						imgui.EndChild()
						imgui.EndPopup()
					end
				end

				imgui.ezHint('{FF0000}ПОЛЕЗНО ДЛЯ КОПОВ\n'..
				'Если игрок зайдёт в интерьер или выйдет из игры во время /pursuit, то\n'..
				'автоматически пробивается его /id',
				hpfont, mainfont, 298.000000, 21.000000)

				imgui.ezHint('Автоматически переключает оружие, когда садишься в машину.\n'..
				'{808080}Помогает, если вы забыли переключить оружие.',
				hpfont, mainfont, 298.000000, 46.000000)
						
				imgui.ezHint('HUD+ это функция, которая улучшает худ Аризоны РП.',
				hpfont, mainfont, 298.000000, 71.000000)

				imgui.EndChild()
			imgui.PopStyleVar(1)


			imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, 6.0)
				imgui.SetCursorPos(imgui.ImVec2(9.000000,150.000000));
				imgui.BeginChild("carfuncs",imgui.ImVec2(225, 110), true)

				imgui.PushFont(mainfont)
				imgui.CenterTextColoredRGB('{1E90FF}CarFuncs')
				imgui.PopFont()

				imgui.SetCursorPos(imgui.ImVec2(30.000000,23.000000));
				if imgui.Checkbox(u8"AutoTT", carfuncs.autotwinturbo) then
					mainIni.carfuncs.autotwinturbo = carfuncs.autotwinturbo[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('{ffffff}Автоматически выбирает режим езды {ff0000}SPORT{ffffff}, когда вы в машине.',
				hpfont, mainfont, 14.000000, 24.000000)

				imgui.SetCursorPos(imgui.ImVec2(30.000000,48.000000));
				if imgui.Checkbox(u8"AutoFill", carfuncs.autofill) then
					mainIni.carfuncs.autofill = carfuncs.autofill[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('{FFFFFF}Автоматически выбирает топливо и заправялет траспорт.\n{FF0000}[NEW]{FFFFFF} Так же автоматически заряжает электрокары.',
				hpfont, mainfont, 14.000000, 51.000000)

				imgui.SetCursorPos(imgui.ImVec2(30.000000,73.000000));
				if imgui.Checkbox(u8"VintColl", boolfixes.fixvint) then
					mainIni.fixes.fixvint = boolfixes.fixvint[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('Если винты вертолёта не раскручиваются из-за столба, то эта функция\n'..
				'поможет вам раскрутить винты, не повреждая вертолёт.',
				hpfont, mainfont, 14.000000, 74.000000)

				imgui.SetCursorPos(imgui.ImVec2(140.000000,23.000000));
				if imgui.Checkbox(u8"CarLight", carfuncs.carlight) then
					mainIni.carfuncs.carlight = carfuncs.carlight[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('{FFFFFF}Возвращает включение фар на {FFD700}CTRL\n'..
				'{808080}Чтобы показать радиальное меню, нажмите {DCDCDC}CTRL + ALT.',
				hpfont, mainfont, 126.000000, 24.000000)

				imgui.SetCursorPos(imgui.ImVec2(140.000000,48.000000));
				if imgui.Checkbox(u8"OldTrunk", carfuncs.trunk) then
					mainIni.carfuncs.trunk = carfuncs.trunk[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('{FFFFFF}Возвращает старое взаимодействие с багажником через {FFD700}ALT.',
				hpfont, mainfont, 126.000000, 49.000000)

				imgui.SetCursorPos(imgui.ImVec2(140.000000,73.000000));
				if imgui.Checkbox(u8"AntiFine", carfuncs.antifine) then
					mainIni.carfuncs.antifine = carfuncs.antifine[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('{FFFFFF}Не зачисляет штраф, когда вы падаете на машине в воду.\n'..
				'{808080}Штраф начислится, если вы выйдите из машины.',
				hpfont, mainfont, 126.000000, 74.000000)



				imgui.EndChild()
			imgui.PopStyleVar(1)

			imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, 6.0)
				imgui.SetCursorPos(imgui.ImVec2(249.000000,150.000000));
				imgui.BeginChild("fixes",imgui.ImVec2(165, 110), true)
				imgui.PushFont(mainfont)
				imgui.CenterTextColoredRGB('{FF0000}Фиксы')
				imgui.PopFont()
				imgui.SetCursorPos(imgui.ImVec2(30.000000,20.000000));
				if imgui.Checkbox(u8"Фикс дверей", boolfixes.fixdver) then
					mainIni.fixes.fixdver = boolfixes.fixdver[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.SetCursorPos(imgui.ImVec2(30.000000,45.000000));
				if imgui.Checkbox(u8"Фикс GPS", boolfixes.fixgps) then
					mainIni.fixes.fixgps = boolfixes.fixgps[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.SetCursorPos(imgui.ImVec2(30.000000,70.000000));
				if imgui.Checkbox(u8"Фикс спавна", boolfixes.fixspawn) then
					mainIni.fixes.fixspawn = boolfixes.fixspawn[0]
					inicfg.save(mainIni, directIni)
				end

				imgui.ezHint('Позволяет открывать двери моментально.\n'..
				'{808080}Активация: {DCDCDC}H',
				hpfont, mainfont, 14.000000, 21.000000)

				imgui.ezHint('{FF0000}ПОЛЕЗНО ДЛЯ КОПОВ\n'..
				'Убирает надпись GPS:ON, что позволяет прописывать /time во время /pursuit',
				hpfont, mainfont, 14.000000, 46.000000)

				imgui.ezHint('{FFFFFF}Вы больше не спавнитесь с {FF4040}бутылкой{FFFAFA} / {FF4040}cигаретой{FFFFFF} в руках\n'..
				'{808080}Для применения, нужно перезайти.',
				hpfont, mainfont, 14.000000, 71.000000)
				
				imgui.EndChild()
			imgui.PopStyleVar(1)
				
			end

			if menu == 'binder' then
				imgui.SetCursorPos(imgui.ImVec2(200.000000,25.000000));
				imgui.BeginChild("binder",imgui.ImVec2(430, 366), false)
				imgui.PushFont(smallfont)
				imgui.CenterTextColoredRGB('{1E90FF}Меню настройки биндов')
				imgui.Separator()
				if #cfg.binds > 0 then
					for index, item in ipairs(cfg.binds) do
						imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
						if imgui.AnimatedButton(u8(item.name)..'##'..index, imgui.ImVec2(360, 30)) then
							EditBinder = true
							getpos = index
							bhotkey.v = {unpack(item.hotkey)} --скопировал список
							local wrappedtext = item.text:gsub('~', '\n')
							imgui.StrCopy(binder.btext, u8(wrappedtext))
							imgui.StrCopy(binder.bname, u8(item.name))
							binder.delay[0] = item.delay
							imgui.OpenPopup(u8'Биндер')
						end
						imgui.PopStyleVar(1)
						imgui.SameLine()
						imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.85, 0.5))
						if imgui.AnimatedButton(fa.ICON_FA_PLAY..'##'..index, imgui.ImVec2(30, 30)) then
							play_bind(item)
						end
						imgui.PopStyleVar(1)
						imgui.SameLine()
						imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.85, 0.5))
						if imgui.AnimatedButton(fa.ICON_FA_TRASH..'##'..index, imgui.ImVec2(30, 30)) then
							table.remove(cfg.binds, index)
							refresh_binds()
							ecfg.save(filename, cfg)
						end
						imgui.PopStyleVar(1)				
					end
					imgui.SetCursorPosX((imgui.GetWindowWidth() - 25) / 2)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
					imgui.Separator()
					if imgui.AnimatedButton(fa.ICON_FA_PLUS_CIRCLE..u8'Создать бинд', imgui.ImVec2(-1,30)) then
						imgui.StrCopy(binder.btext, '')
						imgui.StrCopy(binder.bname, '')
						binder.delay[0] = 1
						bhotkey.v = {}

						imgui.OpenPopup(u8'Биндер')
					end
					imgui.PopStyleVar()
					imgui.PopFont()
				else
					imgui.CenterTextColoredRGB('Здесь пока нету Ваших биндов.')
					imgui.CenterTextColoredRGB('Их можно создать!')
					imgui.SetCursorPosX((imgui.GetWindowWidth() - 25) / 2)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
					imgui.Separator()
					if imgui.AnimatedButton(fa.ICON_FA_PLUS_CIRCLE..u8'Создать бинд', imgui.ImVec2(-1,30)) then
						imgui.StrCopy(binder.btext, '')
						imgui.StrCopy(binder.bname, '')
						binder.delay[0] = 1
						bhotkey.v = {}
						
						imgui.OpenPopup(u8'Биндер')
					end
					imgui.PopStyleVar()
					imgui.PopFont()
				end
			end
			if imgui.BeginPopupModal(u8'Биндер', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
				inputblock = true
				imgui.BeginChild("##EditBinder", imgui.ImVec2(600, 337), false)
				imgui.PushItemWidth(95)
				imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.6, 0.5))
				imgui.InputFloat(u8"Задержка", binder.delay, 0.5, 1.0, "%.1f", imgui.CharsNoBlank); imgui.SameLine()
				if binder.delay[0] <= 0.5 then binder.delay[0] = 1.0 end
				if binder.delay[0] >= 15.5 then binder.delay[0] = 15.0 end
				imgui.PopStyleVar()
				imgui.PopItemWidth()
				imgui.SetCursorPosX(460)
				imgui.Text(u8"Хоткей"); imgui.SameLine()
				imgui.SetCursorPosX(505)
				imgui.HotKey('##name', bhotkey, 90)
				imgui.InputTextMultiline("##EditMultiline", binder.btext, ffi.sizeof(binder.btext), imgui.ImVec2(-1, 250))
				imgui.SetCursorPosY(287)
				imgui.Text(u8'Название бинда:') imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(110.000000,285.000000));
				imgui.PushItemWidth(200)
				imgui.InputText("##binder_name", binder.bname, ffi.sizeof(binder.bname))
				imgui.PopItemWidth()
				imgui.SameLine()
				if #ffi.string(binder.btext) > 0 and #ffi.string(binder.bname) > 0 then
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
					if imgui.Button(u8'Сохранить##bind1', imgui.ImVec2(140,20)) then
						if not EditBinder then
							refresh_text = ffi.string(binder.btext):gsub("\n", "~")
							local item = { name = u8:decode(ffi.string(binder.bname)), text=u8:decode(refresh_text), delay=binder.delay[0], hotkey={unpack(bhotkey.v)} }
							table.insert(cfg.binds, item)
							refresh_binds()
							inputblock = false
							ecfg.save(filename, cfg)
							imgui.CloseCurrentPopup()
						else
							refresh_text = ffi.string(binder.btext):gsub("\n", "~")
							cfg.binds[getpos].name = u8:decode(ffi.string(binder.bname))
							cfg.binds[getpos].text = u8:decode(refresh_text)
							cfg.binds[getpos].delay = binder.delay[0]
							cfg.binds[getpos].hotkey = {unpack(bhotkey.v)}
							refresh_binds()
							inputblock = false
							
							if ecfg.save(filename, cfg) then
								EditBinder = false
								imgui.CloseCurrentPopup()
							end
						end
					end
					imgui.PopStyleVar(1)
				else
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
					imgui.DisableButton(u8'Сохранить##bind2', imgui.ImVec2(140,20))
					imgui.PopStyleVar(1)
				end
				imgui.SameLine()
				imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
				if imgui.Button(u8'Закрыть', imgui.ImVec2(140,20)) then
					imgui.CloseCurrentPopup()
					imgui.StrCopy(binder.btext, '')
					imgui.StrCopy(binder.bname, '')
					binder.delay[0] = 1
					inputblock = false
					if tHotKeyData.edit ~= nil then
						tKeys = {}
						tHotKeyData.edit = nil
						consumeWindowMessage(true, true)
					end
				end
				imgui.PopStyleVar()
				imgui.EndChild()
				imgui.EndPopup()
			end

			if menu == 3 then
				imgui.SetCursorPos(imgui.ImVec2(200.000000,25.000000));
				imgui.BeginChild("info",imgui.ImVec2(430, 366), false)
				imgui.SetCursorPos(imgui.ImVec2(165.000000,25.000000));
				imgui.PushFont(mainfont)
				imgui.TextColoredRGB("{FFA500}Информация.")
				imgui.PopFont()
				imgui.PushFont(smallfont)
				imgui.TextColoredRGB("{E6E6FA} В этом разделе вы можете посмотреть список команд и узнать\n всё о скрипте. Так же в этом разделе можно найти ссылки на\n разработчика скрипта.")
				imgui.PopFont()
				imgui.PushFont(brandfont)

				imgui.SetCursorPos(imgui.ImVec2(10.000000,220.500000));
				imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
				if imgui.Button(u8"CMD", imgui.ImVec2(100, 40)) then imgui.OpenPopup(u8'Информация #1') list = 1 popupwindow.switch() end
				imgui.PopStyleVar(1)

				imgui.SetCursorPos(imgui.ImVec2(320.000000,220.500000));
				imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
				if imgui.Button(u8"LogVersion", imgui.ImVec2(100, 40)) then imgui.OpenPopup(u8'Логи') popupwindow.switch() end
				imgui.PopStyleVar(1)
				


				imgui.SetCursorPos(imgui.ImVec2(10.000000,285.500000));
				imgui.BeginChild("ideveloper",imgui.ImVec2(410, 75), false)
				imgui.Text(u8"Разработчик: CH4PPLE")
				primer_text = {'https://vk.com/chapple', 'https://t.me/CH4PPLE', 'CH4PPLE#2842', 'air.221203@gmail.com'} -- копитекст

				imgui.SetCursorPos(imgui.ImVec2(10.000000,26.000000));
				imgui.Text(fa_icon.ICON_FA_VK)
				imgui.SetCursorPos(imgui.ImVec2(32.000000,25.000000));
				imgui.TextQuestion("                                       ", u8"Нажмите, чтобы скопировать")
				imgui.SetCursorPos(imgui.ImVec2(32.000000,25.000000));
				imgui.Text(primer_text[1]) -- вывод копитекста
				if imgui.IsItemClicked() then
					imgui.LogToClipboard()
					imgui.LogText(primer_text[1]) -- копирование копитекста
					ezMessage("Успешно скопировано!")
					imgui.LogFinish()
				end

				imgui.SetCursorPos(imgui.ImVec2(12.500000,48.000000));
				imgui.Text(fa_icon.ICON_FA_TELEGRAM_PLANE)
				imgui.SetCursorPos(imgui.ImVec2(32.000000,47.000000));
				imgui.TextQuestion("                                     ", u8"Нажмите, чтобы скопировать")
				imgui.SetCursorPos(imgui.ImVec2(32.000000,47.000000));
				imgui.Text(primer_text[2]) -- вывод копитекста
				if imgui.IsItemClicked() then
					imgui.LogToClipboard()
					imgui.LogText(primer_text[2]) -- копирование копитекста
					ezMessage("Успешно скопировано!")
					imgui.LogFinish()
				end

				imgui.SetCursorPos(imgui.ImVec2(200.000000,26.000000));
				imgui.Text(fa_icon.ICON_FA_DISCORD)
				imgui.SetCursorPos(imgui.ImVec2(222.000000,25.000000));
				imgui.TextQuestion("                          ", u8"Нажмите, чтобы скопировать")
				imgui.SetCursorPos(imgui.ImVec2(222.000000,25.000000));
				imgui.Text(primer_text[3])
				if imgui.IsItemClicked() then
					imgui.LogToClipboard()
					imgui.LogText(primer_text[3]) 
					ezMessage("Успешно скопировано!")
					imgui.LogFinish()
				end
				imgui.PopFont()
				imgui.PushFont(mainfont)
				imgui.SetCursorPos(imgui.ImVec2(202.500000,48.000000));
				imgui.Text(fa.ICON_FA_AT)
				imgui.SetCursorPos(imgui.ImVec2(222.000000,47.000000));
				imgui.TextQuestion("                                       ", u8"Нажмите, чтобы скопировать")
				imgui.SetCursorPos(imgui.ImVec2(222.000000,47.000000));
				imgui.Text(primer_text[4]) 
				if imgui.IsItemClicked() then
					imgui.LogToClipboard()
					imgui.LogText(primer_text[4]) 
					ezMessage("Успешно скопировано!")
					imgui.LogFinish()
				end
				imgui.PopFont()
				imgui.EndChild()

			end
			imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, popupwindow.alpha)
			if imgui.BeginPopupModal(u8'Информация #1', false,  imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
				if list == 1 then
					imgui.BeginChild("fastcmd",imgui.ImVec2(625, 200), true)
					imgui.PushFont(mainfont)
					imgui.TextColoredRGB("{FFA500}Быстрые команды.")
					imgui.PopFont()
					imgui.PushFont(smallfont)
					imgui.TextColoredRGB("{E6E6FA}Это укрощённые стандартные команды. Подойдут, если Вам срочно что-то нужно сделать.\n" .. 
					'{E6E6FA}	Например: {7FFFD4}найти дом, бизнес, посмотреть /members\n' ..
					'{00BFFF}		Обычные:\n' ..
					'{E6E6FA}			/fh {FFD700}[ID]{E6E6FA} - поиск дома\n' ..
					'{E6E6FA}			/fbz {FFD700}[ID]{E6E6FA} - поиск бизнеса\n' ..
					'{00BFFF}		Организационные:\n' ..
					'{E6E6FA}			/jb - посмотреть свою успеваемость {808080}(/jobprogress)\n' ..
					'{E6E6FA}			/cjb {FFD700}[ID]{E6E6FA} - проверка успеваемости сотрудника {808080}(/checkjobprogress) {FF0000}9+ rank{E6E6FA}\n' ..
					'{E6E6FA}			/mb - проверить онлайн организации {808080}(/members)')
					imgui.PopFont()
					imgui.EndChild()
					
					imgui.SetCursorPos(imgui.ImVec2(280.000000,250.000000));
					imgui.PushFont(mainfont)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.662, 0.55))
					if imgui.Button(fa.ICON_FA_TIMES, imgui.ImVec2(50, 50)) then 
						popupwindow.switch()
						checkpopupwindow = true
					end
					if checkpopupwindow and popupwindow.alpha <= 0.09 then imgui.CloseCurrentPopup() checkpopupwindow = false end
					imgui.PopStyleVar(1)
					imgui.PopFont()

					imgui.SetCursorPos(imgui.ImVec2(380.000000,250.000000));
					imgui.PushFont(mainfont)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.745, 0.55))
					if imgui.Button(fa.ICON_FA_ANGLE_DOUBLE_RIGHT, imgui.ImVec2(50, 50)) then
						list = 2
					end
					imgui.PopStyleVar(1)
					imgui.PopFont()
					imgui.EndPopup()
				end

				if list == 2 then
					imgui.BeginChild("newcmd",imgui.ImVec2(625, 200), true)
					imgui.PushFont(mainfont)
					imgui.TextColoredRGB("{FFA500}Новые команды.")
					imgui.PopFont()
					imgui.PushFont(smallfont)
					imgui.TextColoredRGB("{E6E6FA}Это новые команды. Тут вы можете с ними ознакомиться.\n" .. 
					'	{00BFFF}Время / погода:\n' ..
					'		{E6E6FA}/st {FFD700}[0-23]{E6E6FA} - изменить время\n' ..
					'		{E6E6FA}/sw {FFD700}[0-45]{E6E6FA} - изменить погоду\n' ..
					'	{00BFFF}Прочее:\n' ..
					'		{E6E6FA}/delltd - удаление всех текстдравов на экране\n' ..
					'		{E6E6FA}/showdoor - показывает, открыта ли машина')
					imgui.PopFont()
					imgui.EndChild()

					imgui.SetCursorPos(imgui.ImVec2(280.000000,250.000000));
					imgui.PushFont(mainfont)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.662, 0.55))
					if imgui.Button(fa.ICON_FA_TIMES, imgui.ImVec2(50, 50)) then 
						popupwindow.switch()
						checkpopupwindow = true
					end
					if checkpopupwindow and popupwindow.alpha <= 0.09 then imgui.CloseCurrentPopup() checkpopupwindow = false end
					imgui.PopStyleVar(1)
					imgui.PopFont()

					imgui.SetCursorPos(imgui.ImVec2(180.000000,250.000000));
					imgui.PushFont(mainfont)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.665, 0.55))
					if imgui.Button(fa.ICON_FA_ANGLE_DOUBLE_LEFT, imgui.ImVec2(50, 50)) then 
						list = 1
					end
					imgui.PopStyleVar(1)
					imgui.PopFont()
					imgui.EndPopup()
				end	

			end
			imgui.PopStyleVar()
			imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, popupwindow.alpha)
			if imgui.BeginPopupModal(u8'Логи', false,  imgui.WindowFlags.NoResize) then
				imgui.SetWindowSizeVec2(imgui.ImVec2(650, 400))
				imgui.BeginChild("logscript",imgui.ImVec2(650, 316), false)
				imgui.PushFont(smallfont)
				imgui.WrappedTextRGB(u8'01.07.2022 - 1.2.0 - исправил небольшой баг с биндером\n'..
				u8'02.07.2022 - 1.2.1 - изменил /showdoor, убрал таймер\n'..
				u8'02.07.2022 - 1.2.2 - вернул старую систему включения фар, открытие багажника\n'..
				u8'02.07.2022 - 1.2.3 - фиксанул показ диалога об обновлении (закрывается с первого раза)\n'..
				u8'05.07.2022 - 1.2.5 - изменил опиcание скрипта, изменил систему включения фар, открытия багажника\n'..
				u8'05.07.2022 - 1.2.6 - добавил новую категорию функций в скрипте "CarFuncs"\n'..
				u8'06.07.2022 - 1.2.7 - исправил баг с AutoFill. добавил AutoFill для электрокаров\n'..
				u8"06.07.2022 - 1.3.0 - исправил баг худа с новыми анимациями на аризоне. Сделал анимацию popup'a\n"..
				u8'07.07.2022 - 1.3.1 - исправил мелкие баги с темой имгуи\n'..
				u8'07.07.2022 - 1.3.2 - исправил баги с косметикой скрипта\n'..
				u8'10.07.2022 - 1.3.5 - Добавил автообновление скрипта. Исправил команду /findibiz? теперь её нужно вызывать через /fbz. Подправил код скрипта.\n'..
				u8'10.07.2022 - 1.3.5 - версия скрипта в данный момент')
				imgui.PopFont()
				imgui.EndChild()
				imgui.SetCursorPosX(300)
				imgui.PushFont(mainfont)
				imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.662, 0.55))
				if imgui.Button(fa.ICON_FA_TIMES, imgui.ImVec2(50, 50)) then
					popupwindow.switch()
					checkpopupwindow = true
				end
				if checkpopupwindow and popupwindow.alpha <= 0.09 then imgui.CloseCurrentPopup() checkpopupwindow = false end
				imgui.PopFont()
				imgui.PopStyleVar(1)
				imgui.EndPopup()
			end
			imgui.PopStyleVar()
        imgui.End()
		imgui.PopStyleVar()
    end
)

function onScriptTerminate(script, quit)
	gameClockk = 0
	clock = 0
	afk = 0
end

function sampev.onServerMessage(color, text)
	if features.autoid[0] == true then
		if text:find('Вы успешно начали погоню за игроком .') then
			namePur = text:match('Вы успешно начали погоню за игроком (%w+_?%w+)')
			print(namePur)
		end
		if text:find('Игрок ушел от погони! Последнее местоположение') then
			pursuit = lua_thread.create(function()
				wait(800)
				sampSendChat("/id " .. namePur)
				pursuit = 0
			end)
		end
	end
	if text:find('Изменить стиль езды можно только если у вас установлены технические модификации или на полицейских авто!') then
		ezMessage('На это транспорте нет TwinTurbo.')
		return false
	end
	if text:find('%[Информация%] %{FFFFFF%}Используйте курсор чтобы выбрать тип топлива и его кол%-%во') then
		fillcar = true
	end
	if carfuncs.autofill[0] == true then
		if text:find('Ваш транспорт заправлен.+') then
			fillcar = false
		elseif text:find('Ваш транспорт был заряжен.+') then
			electofill = false
		end
	end
end

function setTime(hours)
    memory.write(0xB70153, hours, 1, false)
end

function setWeather(weather)
	forceWeatherNow(weather)
end

function sampev.onShowTextDraw(id, data)
	electro = sampTextdrawGetString(2063)
	if electro == "ELECTRIC" then
		electofill = true
	end
	if electofill == true then
		atfll = lua_thread.create_suspended(function()
			sampSendClickTextdraw(2064)
			wait(300)
			sampSendClickTextdraw(238)
		end)
		atfll:run()
		electofill = false
	end
end

function sampev.onDisplayGameText(style, time, text)
	if carfuncs.autofill[0] == true then
		if fillcar == true then
			atfll = lua_thread.create_suspended(function()
				if text:find("~w~This type of fuel ~r~ is not suitable~w~~n~ for your vehicles!") then
					sampSendClickTextdraw(106)
					wait(250)
				else
					sampSendClickTextdraw(2064)
					sampSendClickTextdraw(120)
				end
			end)
			atfll:run()
		end
	end
	if carfuncs.autotwinturbo[0] then
		if isCharInAnyCar(playerPed) then
			if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
				ezMessage("AutoTT: TwinTurbo включён.")
				sampSendChat('/style')
			end
		end
	end
	--if text:find('.+') then print(text) end
		
	if boolfixes.fixgps[0] == true then
		if text:find("GPS: ON") then
			return false
		end
	end

	if text:find(".+ HP") then
		return false
	end
end

function sampev.onSetPlayerHealth(health)
	_, pid = sampGetPlayerIdByCharHandle(playerPed)
	lasthp = sampGetPlayerHealth(pid)
	lua_thread.create(function()
		while true do wait(0)
			actv = true
			wait(1600)
			actv = false
			break
		end
	end)
end

function getCharOxygen()
	return memory.getfloat(0xB7CDE0) / 39.97000244
end

function sampev.onSendVehicleSync(data)
	if carfuncs.carlight[0] == true then
		if bit.band(data.keysData, 0x01) == 0x01 and bit.band(data.keysData, 0x04) ~= 0x04 then
			if isKeyJustPressed(VK_CONTROL) and not sampIsDialogActive() and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() then sampSendChat("/lights") end
			data.keysData = bit.bxor(data.keysData, 0x01)
		end

		return data
	end
end

function sampev.onSendVehicleDestroyed(vehicleId)
	if carfuncs.antifine[0] == true then
		local result, car = sampGetCarHandleBySampVehicleId(vehicleId)
		if result and isCarInWater(car) and getDriverOfCar(car) == PLAYER_PED then
			return false
		end
	end
end

function applySampfuncsPatch()
    local memory = memory or require 'memory'
    local module = getModuleHandle("SAMPFUNCS.asi")
    if module ~= 0 and memory.compare(module + 0xBABD, memory.strptr('\x8B\x43\x04\x8B\x5C\x24\x20\x8B\x48\x34\x83\xE1'), 12) then
        memory.setuint16(module + 0x83349, 0x01ac, true)
        memory.setuint16(module + 0x8343c, 0x01b0, true)
        memory.setuint16(module + 0x866dd, 0x00f4, true)
        memory.setuint16(module + 0x866e9, 0x0306, true)
        memory.setuint8(module + 0x8e754, 0x40, true)
    end
end

function imgui.TextQuestion(label, description)
    imgui.TextDisabled(label)

    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
                imgui.TextUnformatted(description)
            imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function drawBar(posX, posY, sizeX, sizeY, color1, color2, borderThickness, font, value)
	renderDrawBoxWithBorder(posX, posY, sizeX, sizeY, color2, borderThickness, 0xFF000000)
	renderDrawBox(posX + borderThickness, posY + borderThickness, sizeX / 100 * value - (borderThickness * 2), sizeY - (2 * borderThickness), color1)
end

function onWindowMessage(msg, wparam, lparam)
    if msg == 0x100 or msg == 0x101 then
        if (wparam == VK_ESCAPE and rwindow.state) and not isPauseMenuActive() and not inputblock then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
				rwindow.switch()
				if popupwindow.alpha == 1 then
					popupwindow.switch()
				end
            end
        end
		if (wparam == VK_ESCAPE and TWWindow.state) and not isPauseMenuActive() then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
				rwindow.switch()
				TWWindow.switch()
				sampSetChatDisplayMode(2)
            end
        end
    end
end

function getSprintLocalPlayer() -- Original: https://blast.hk/threads/13380/post-192584
	local float = memory.getfloat(0xB7CDB4)
	if float > 0 then
		return math.floor(float/31.47000244)
	else
		return 0
	end
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    if text:find("{929290}Вы должны подтвердить свой PIN%-код к карточке.") then
		sampSendDialogResponse(id, 1, nil, mainIni.features.pincode)
	end
	if text:find('{ffffff}Администратор (.+) ответил вам%:') then
		bass.BASS_ChannelSetAttribute(radio, BASS_ATTRIB_VOL, 1) -- громкость
		bass.BASS_ChannelPlay(radio, false) -- воспроизвести
	end
	if id == 15330 then
		countdialog = countdialog + 1
		if countdialog == 2 then return false end
		
    end
	--[[if text:find('.+') then
		print(id, style, title, text)
	end]]
end

function ShowMessage(text, title, style)
    ffi.cdef [[
        int MessageBoxA(
            void* hWnd,
            const char* lpText,
            const char* lpCaption,
            unsigned int uType
        );
    ]]
    local hwnd = ffi.cast('void*', readMemory(0x00C8CF88, 4, false))
    ffi.C.MessageBoxA(hwnd, text,  title, style and (style + 0x50000) or 0x50000)
end

function carfunc()
    while true do wait(0)
        if not isPauseMenuActive() then
            if sampGetGamestate() == 3 then
				local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
				local target, min_dist
				for i, v in ipairs(getAllVehicles()) do
					local model = getCarModel(v)
					local carbool, carid = sampGetVehicleIdByCarHandle(v)
					local DoorsStats = getCarDoorLockStatus(v)
					local hpcar = getCarHealth(v)
					local statusstr = ''
					if DoorsStats == 0 then
						statusstr = '{00FF00}Открыто'
					elseif DoorsStats == 2 then
						statusstr = '{FF0000}Закрыто'
					end
					local a1, a2, a3, b1, b2, b3 = getModelDimensions(model)
					local aX, aY, aZ = getOffsetFromCarInWorldCoords(v, a1, a2, a3)
					local bX, bY, bZ = getOffsetFromCarInWorldCoords(v, b1, a2, b3)
					local cX, cY, cZ = (aX + bX) / 2, (aY + bY) / 2, (aZ + bZ) / 2
					local disttrunk = getDistanceBetweenCoords3d(pX, pY, pZ, cX, cY, cZ)
					if (min_dist == nil or disttrunk < min_dist) and disttrunk <= math.abs(a1) then
						target, min_dist = v, disttrunk
					end
					if act then
						local x,y,z = getCarCoordinates(v)
						local dist = getDistanceBetweenCoords3d(pX, pY, pZ,x,y,z)
						local wposX, wposY = convert3DCoordsToScreen(x,y,z)
						if isPointOnScreen(x,y,z,0) and dist < 5 then
							renderFontDrawText(font,'HP: '..hpcar,wposX-30,wposY -5,0xFF00BFFF)	
							renderFontDrawText(font,statusstr,wposX-30,wposY + 10,-255878787)					
						end
					end
				end
				if target ~= nil and wasKeyPressed(0x12) and carfuncs.trunk[0] == true then
					local result, id = sampGetVehicleIdByCarHandle(target)
					if result and not sampIsDialogActive() and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() then sampSendChat("/trunk " .. id) end
				end
            end
        end
    end
end

function files_add()
	if not doesDirectoryExist("moonloader\\resource\\ezHelper") then createDirectory('moonloader\\resource\\ezHelper') end
		if not doesFileExist('moonloader\\resource\\ezHelper\\02070.mp3') then
			ezMessage("{FF0000}Ошибка!{FFFFFF} У вас отсутствуют нужные файлы для работы скрипта, начинаю скачивание.")
		downloadUrlToFile("https://drive.google.com/u/0/uc?id=1nBBQfy8LQlCDoRXgZZ_v3iZ10d3Cmo0_&export=download", getWorkingDirectory().."/resource/ezHelper/02070.mp3", function(id, status, p1, p2)
			if status == 57 then
				ezMessage('Начинаю загрузку звуков...')
			elseif status == 58 then
				ezMessage('Загрузка звуков {00FF00}успешно завершена.')
			end
		end)
	end
end

function ezMessage(arg)
	sampAddChatMessage("{fff000}[ezHelper]: {ffffff}"..arg, 0xfff000)
end

function apply_custom_style()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	style.WindowRounding = 6
	style.ChildRounding = 1.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.FrameRounding = 1.0
	style.ItemSpacing = imgui.ImVec2(4.0, 4.0)
	style.ScrollbarSize = 11.5
	style.ScrollbarRounding = 6
	style.GrabMinSize = 8.0
	style.GrabRounding = 10.0
	style.WindowBorderSize = 0.0
	style.WindowPadding = imgui.ImVec2(4.0, 4.0)
	style.FramePadding = imgui.ImVec2(2.5, 3.5)
	style.ButtonTextAlign = imgui.ImVec2(0.2, 0.5)
	style.WindowMinSize = imgui.ImVec2(200, 140)

	colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]         = ImVec4(0.77, 0.77, 0.77, 1.00)
	colors[clr.WindowBg]             = ImVec4(0.10, 0.10, 0.10, 1.00)
	colors[clr.ChildBg]              = ImVec4(0.30, 0.30, 0.30, 0.20)
	colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border]               = ImVec4(0.50, 0.50, 0.50, 1.0)
	colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]              = ImVec4(0.43, 0.43, 0.43, 0.54)
	colors[clr.FrameBgHovered]       = ImVec4(1.00, 1.00, 1.00, 0.40)
	colors[clr.FrameBgActive]        = ImVec4(0.25, 0.25, 0.25, 1.00)
	colors[clr.TitleBg]              = ImVec4(0.00, 0.00, 0.00, 1.00)
	colors[clr.TitleBgActive]        = ImVec4(0.00, 0.00, 0.00, 1.00)
	colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.00, 0.00, 1.00)
	colors[clr.MenuBarBg]            = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]        = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]  = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]            = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.SliderGrab]           = ImVec4(0.69, 0.69, 0.69, 1.00)
	colors[clr.SliderGrabActive]     = ImVec4(0.91, 0.91, 0.91, 1.00)
	colors[clr.Button]               = ImVec4(0.27, 0.27, 0.27, 1.00)
	colors[clr.ButtonHovered]        = ImVec4(0.69, 0.69, 0.69, 0.65)
	colors[clr.ButtonActive]         = ImVec4(0.20, 0.20, 0.20, 0.50)
	colors[clr.Header]               = ImVec4(1.00, 1.00, 1.00, 0.54)
	colors[clr.HeaderHovered]        = ImVec4(1.00, 1.00, 1.00, 0.65)
	colors[clr.HeaderActive]         = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.Separator]            = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.SeparatorHovered]     = ImVec4(0.71, 0.39, 0.39, 0.54)
	colors[clr.SeparatorActive]      = ImVec4(0.71, 0.39, 0.39, 0.54)
	colors[clr.ResizeGrip]           = ImVec4(0.71, 0.39, 0.39, 0.54)
	colors[clr.ResizeGripHovered]    = ImVec4(0.84, 0.66, 0.66, 0.66)
	colors[clr.ResizeGripActive]     = ImVec4(0.84, 0.66, 0.66, 0.66)
	colors[clr.PlotLines]            = ImVec4(1.00, 0.00, 0.00, 1.00)
	colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]       = ImVec4(0.26, 0.59, 0.98, 0.35)
end

function imgui.CenterTextColoredRGB(text)
	local width = imgui.GetWindowWidth()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	local explode_argb = function(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
	end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImVec4(r/255, g/255, b/255, a/255)
    end

	local render_text = function(text_)
	for w in text_:gmatch('[^\r\n]+') do
	local textsize = w:gsub('{.-}', '')
	local text_width = imgui.CalcTextSize(u8(textsize))
	imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
	local text, colors_, m = {}, {}, 1
	w = w:gsub('{(......)}', '{%1FF}')
	while w:find('{........}') do
	local n, k = w:find('{........}')
	local color = getcolor(w:sub(n + 1, k - 1))
	if color then
	text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
	colors_[#colors_ + 1] = color
	m = n
	end
	w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
	end
	if text[0] then
	for i = 0, #text do
	imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
	imgui.SameLine(nil, 0)
	end
	imgui.NewLine()
	else
	imgui.Text(u8(w))
	end
	end
	end
	render_text(text)
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImVec4(r/255, g/255, b/255, a/255)
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.TextWrapped(u8(w)) end
        end
    end

    render_text(text)
end

function split(str, delim, plain)
    local tokens, pos, plain = {}, 1, not (plain == false)
    repeat
        local npos, epos = string.find(str, delim, pos, plain)
        table.insert(tokens, string.sub(str, pos, npos and npos - 1))
        pos = epos and epos + 1
    until not pos
    return tokens
end

function imgui_text_wrapped(clr, text)
    if clr then imgui.PushStyleColor(ffi.C.ImGuiCol_Text, clr) end

    text = ffi.new('char[?]', #text + 1, text)
    local text_end = text + ffi.sizeof(text) - 1
    local pFont = imgui.GetFont()

    local scale = 1.0
    local endPrevLine = pFont:CalcWordWrapPositionA(scale, text, text_end, imgui.GetContentRegionAvail().x)
    imgui.TextUnformatted(text, endPrevLine)

    while endPrevLine < text_end do
        text = endPrevLine
        if text[0] == 32 then text = text + 1 end
        endPrevLine = pFont:CalcWordWrapPositionA(scale, text, text_end, imgui.GetContentRegionAvail().x)
        if text == endPrevLine then
            endPrevLine = endPrevLine + 1
        end
        imgui.TextUnformatted(text, endPrevLine)
    end

    if clr then imgui.PopStyleColor() end
end

function imgui.WrappedTextRGB(text)
    text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')
	local style = imgui.GetStyle()
	local colors = style.Colors
    local render_func = imgui_text_wrapped or function(clr, text)
        if clr then imgui.PushStyleColor(ffi.C.ImGuiCol_Text, clr) end
        imgui.TextUnformatted(text)
        if clr then imgui.PopStyleColor() end
    end


    local color = colors[ffi.C.ImGuiCol_Text]
    for _, w in ipairs(split(text, '\n')) do
        local start = 1
        local a, b = w:find('{........}', start)
        while a do
            local t = w:sub(start, a - 1)
            if #t > 0 then
                render_func(color, t)
                imgui.SameLine(nil, 0)
            end

            local clr = w:sub(a + 1, b - 1)
            if clr:upper() == 'STANDART' then color = colors[ffi.C.ImGuiCol_Text]
            else
                clr = tonumber(clr, 16)
                if clr then
                    local r = bit.band(bit.rshift(clr, 24), 0xFF)
                    local g = bit.band(bit.rshift(clr, 16), 0xFF)
                    local b = bit.band(bit.rshift(clr, 8), 0xFF)
                    local a = bit.band(clr, 0xFF)
                    color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
                end
            end

            start = b + 1
            a, b = w:find('{........}', start)
        end
        imgui.NewLine()
        if #w > start - 1 then
            imgui.SameLine(nil, 0)
            render_func(color, w:sub(start))
        end
    end
end

function imgui.IconColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImVec4(r/255, g/255, b/255, a/255)
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], (text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end

    render_text(text)
end

function imgui.Hint(text, delay)
	if imgui.IsItemHovered() then
		if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
		local alpha = (os.clock() - go_hint) * 5 -- скорость появления
		if os.clock() >= go_hint then
			imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
			imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
			imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(700)
			imgui.IconColoredRGB('{1E90FF} '..fa.ICON_FA_INFO_CIRCLE..u8'Подсказка:')
			imgui.TextColoredRGB(text)
			if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
			imgui.PopStyleColor()
			imgui.PopStyleVar(2)
		end
	end
end

function imgui.DisableButton(text, size)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.0, 0.0, 0.0, 0.2))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.0, 0.0, 0.0, 0.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.0, 0.0, 0.0, 0.2))
	local button = imgui.Button(text, size)
	imgui.PopStyleColor(3)

	return button
end

function imgui.AnimatedButton(label, size, speed, rounded)
    local size = size or imgui.ImVec2(0, 0)
    local bool = false
    local text = label:gsub('##.+$', '')
    local ts = imgui.CalcTextSize(text)
    speed = speed and speed or 0.4
    if not AnimatedButtons then AnimatedButtons = {} end
    if not AnimatedButtons[label] then
        local color = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
        AnimatedButtons[label] = {circles = {}, hovered = false, state = false, time = os.clock(), color = imgui.ImVec4(color.x, color.y, color.z, 0.2)}
    end
    local button = AnimatedButtons[label]
    local dl = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    local c = imgui.GetCursorPos()
    local CalcItemSize = function(size, width, height)
        local region = imgui.GetContentRegionMax()
        if (size.x == 0) then
            size.x = width
        elseif (size.x < 0) then
            size.x = math.max(4.0, region.x - c.x + size.x);
        end
        if (size.y == 0) then
            size.y = height;
        elseif (size.y < 0) then
            size.y = math.max(4.0, region.y - c.y + size.y);
        end
        return size
    end
    size = CalcItemSize(size, ts.x+imgui.GetStyle().FramePadding.x*2, ts.y+imgui.GetStyle().FramePadding.y*2)
    local ImSaturate = function(f) return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f) end
    if #button.circles > 0 then
        local PathInvertedRect = function(a, b, col)
            local rounding = rounded and imgui.GetStyle().FrameRounding or 0
            if rounding <= 0 or not rounded then return end
            local dl = imgui.GetWindowDrawList()
            dl:PathLineTo(a)
            dl:PathArcTo(imgui.ImVec2(a.x + rounding, a.y + rounding), rounding, -3.0, -1.5)
            dl:PathFillConvex(col)

            dl:PathLineTo(imgui.ImVec2(b.x, a.y))
            dl:PathArcTo(imgui.ImVec2(b.x - rounding, a.y + rounding), rounding, -1.5, -0.205)
            dl:PathFillConvex(col)

            dl:PathLineTo(imgui.ImVec2(b.x, b.y))
            dl:PathArcTo(imgui.ImVec2(b.x - rounding, b.y - rounding), rounding, 1.5, 0.205)
            dl:PathFillConvex(col)

            dl:PathLineTo(imgui.ImVec2(a.x, b.y))
            dl:PathArcTo(imgui.ImVec2(a.x + rounding, b.y - rounding), rounding, 3.0, 1.5)
            dl:PathFillConvex(col)
        end
        for i, circle in ipairs(button.circles) do
            local time = os.clock() - circle.time
            local t = ImSaturate(time / speed)
            local color = imgui.GetStyle().Colors[imgui.Col.TitleBg]
            local color = imgui.GetColorU32Vec4(imgui.ImVec4(color.x, color.y, color.z, (circle.reverse and (255-255*t) or (255*t))/255))
            local radius = math.max(size.x, size.y) * (circle.reverse and 1.5 or t)
            imgui.PushClipRect(p, imgui.ImVec2(p.x+size.x, p.y+size.y), true)
            dl:AddCircleFilled(circle.clickpos, radius, color, radius/2)
            PathInvertedRect(p, imgui.ImVec2(p.x+size.x, p.y+size.y), imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.WindowBg]))
            imgui.PopClipRect()
            if t == 1 then
                if not circle.reverse then
                    circle.reverse = true
                    circle.time = os.clock()
                else
                    table.remove(button.circles, i)
                end
            end
        end
    end
    local t = ImSaturate((os.clock()-button.time) / speed)
    button.color.w = button.color.w + (button.hovered and 0.8 or -0.8)*t
    button.color.w = button.color.w < 0.2 and 0.2 or (button.color.w > 1 and 1 or button.color.w)
    color = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
    color = imgui.GetColorU32Vec4(imgui.ImVec4(color.x, color.y, color.z, 0.2))
    dl:AddRectFilled(p, imgui.ImVec2(p.x+size.x, p.y+size.y), color, rounded and imgui.GetStyle().FrameRounding or 0)
    dl:AddRect(p, imgui.ImVec2(p.x+size.x, p.y+size.y), imgui.GetColorU32Vec4(button.color), rounded and imgui.GetStyle().FrameRounding or 0)
    local align = imgui.GetStyle().ButtonTextAlign
    imgui.SetCursorPos(imgui.ImVec2(c.x+(size.x-ts.x)*align.x, c.y+(size.y-ts.y)*align.y))
    imgui.Text(text)
    imgui.SetCursorPos(c)
    if imgui.InvisibleButton(label, size) then
        bool = true
        table.insert(button.circles, {animate = true, reverse = false, time = os.clock(), clickpos = imgui.ImVec2(getCursorPos())})
    end
    button.hovered = imgui.IsItemHovered()
    if button.hovered ~= button.state then
        button.state = button.hovered
        button.time = os.clock()
    end
    return bool
end

function imgui.ezHint(text, iconfont, textfont, posX, posY)
	imgui.PushFont(iconfont)
	imgui.SetCursorPos(imgui.ImVec2(posX,posY));
	imgui.TextDisabled(fa.ICON_FA_QUESTION_CIRCLE)
	imgui.SetCursorPos(imgui.ImVec2(posX - 9,posY));
	imgui.Text('	 ')
	imgui.PopFont()
	imgui.PushFont(textfont)
	imgui.Hint(text)
	imgui.PopFont()
end

function play_bind(item)
	if not sampIsDialogActive() and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and not inputblock then
		BIND_ITEM = item
		BIND_START = true
	end
end





---/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\---
---------------------------------------------------IMGUI_HOTKEY---------------------------------------------------
---\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/---

function getKeysName(keys)
    if type(keys) ~= "table" then
       return false
    else
       local tKeysName = {}
       for k, v in ipairs(keys) do
          tKeysName[k] = vkeys.id_to_name(v)
       end
       return tKeysName
    end
 end

function imgui.HotKey(name, keys, width)
    local width = width or 90
    local name = tostring(name)
    local keys, bool = keys or {}, false
    local thisEdit = false

    local sKeys = table.concat(getKeysName(keys.v), " + ")

    if #tHotKeyData.save > 0 and tostring(tHotKeyData.save[1]) == name then
        keys.v = tHotKeyData.save[2]
        sKeys = table.concat(getKeysName(keys.v), " + ")
        tHotKeyData.save = {}
        bool = true
    elseif tHotKeyData.edit ~= nil and tostring(tHotKeyData.edit) == name then
        thisEdit = true
		if #tKeys == 0 then
			if os.clock() - tHotKeyData.lastTick > 0.5 then
            tHotKeyData.lastTick = os.clock()
            tHotKeyData.tickState = not tHotKeyData.tickState
         	end
         	sKeys = tHotKeyData.tickState and "No" or " "
        else
            sKeys = table.concat(getKeysName(tKeys), " + ")
        end
    end
    imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.5, 0.5))
    if imgui.Button((tostring(sKeys):len() == 0 and u8"Свободно" or sKeys) .. name, imgui.ImVec2(width, 0)) then
        tHotKeyData.edit = name
    end
    imgui.PopStyleVar()
    return bool
end

function getKeyNumber(id)
   for k, v in ipairs(tKeys) do
      if v == id then
         return k
      end
   end
   return -1
end

function reloadKeysList()
    local tNewKeys = {}
    for k, v in pairs(tKeys) do
       tNewKeys[#tNewKeys + 1] = v
    end
    tKeys = tNewKeys
    return true
 end

function isKeyModified(id)
if type(id) ~= "number" then
   return false
end
return (tModKeys[id] or false)
end


local wm = require 'lib.windows.message'
addEventHandler("onWindowMessage", function (msg, wparam, lparam)
    if tHotKeyData.edit ~= nil and msg == wm.WM_CHAR then
        if tBlockChar[wparam] then
            consumeWindowMessage(true, true)
        end
    end
    if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
        if tHotKeyData.edit ~= nil and wparam == vkeys.VK_ESCAPE then
            tKeys = {}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
        end
        if tHotKeyData.edit ~= nil and wparam == vkeys.VK_BACK then
            tHotKeyData.save = {tHotKeyData.edit, {}}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
        end
        local num = getKeyNumber(wparam)
        if num == -1 then
            tKeys[#tKeys + 1] = wparam
            if tHotKeyData.edit ~= nil then
                if not isKeyModified(wparam) then
                    tHotKeyData.save = {tHotKeyData.edit, tKeys}
                    tHotKeyData.edit = nil
                    tKeys = {}
                    consumeWindowMessage(true, true)
                end
            end
        end
        reloadKeysList()
        if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
        end
    elseif msg == wm.WM_KEYUP or msg == wm.WM_SYSKEYUP then
        local num = getKeyNumber(wparam)
        if num > -1 then
            tKeys[num] = nil
        end
        reloadKeysList()
        if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
        end
    end
end)
