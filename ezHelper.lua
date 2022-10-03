script_name('ezHelper')
script_author('CHAPPLE')
script_version("1.4.9")
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
local ffi = require 'ffi'
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local fa = require('fAwesome5')
local memory = require 'memory'
local bass = require "lib.bass"
local pie = require 'mimgui_piemenu'
local panic = getGameDirectory().."\\moonloader\\resource\\ezHelper\\panic.mp3"
local notification = getGameDirectory().."\\moonloader\\resource\\ezHelper\\notification.mp3"

local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local clock, gsub, gmatch, find, ceil, len = os.clock, string.gsub, string.gmatch, string.find, math.ceil, string.len
local renderWindow = new.bool(false)
local TimeWeatherWindow = new.bool(false)
local updatewindow = new.bool(false)
local hud = new.bool(true)
local obvodka = new.bool(false)
local widget = new.bool(true)
local sizeX, sizeY = getScreenResolution()
local font = renderCreateFont('segmdl2', 10, 5)
local bigfont = renderCreateFont('segmdl2', 14, 5)
local lasthp = 0
local razn = nil
local hp = 0
local actv = false
local vsprint = false
local vwater = false
local spawn = false
local fillcar = false

local pie_mode = new.bool(true)

local nowTime = os.date("%H:%M:%S", os.time())
local sesOnline = new.int(0)
local fps = 0

imgui.OnInitialize(function()
	apply_custom_style()

	local config = imgui.ImFontConfig()
    config.MergeMode = true
	config.GlyphOffset.y = 1.0
	config.GlyphOffset.x = -5.0
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
    mainfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 16.0, nil, glyph_ranges)
   	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 20.0, config, iconRanges)
	smallfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 14.0, nil, glyph_ranges)
	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 15.0, config, iconRanges)
	piefont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 15.0, nil, glyph_ranges)
	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 22.0, config, iconRanges)
	brandfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 15.0, nil, glyph_ranges) -- brands font
	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-brands-400.ttf', 20.0, config, iconRanges) --brands font
	hpfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 18.0, nil, glyph_ranges)
   	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 16.0, config, iconRanges)

 	wfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 24.0, nil, glyph_ranges)
	sfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 10.0, nil, glyph_ranges)

	imgui.GetIO().IniFilename = nil
end)


-------------------------------------ENCODING
local encoding = require 'encoding'
encoding.default = 'CP1251'         
local u8 = encoding.UTF8            
-------------------------------------ENCODING

function update()
    local raw = 'https://raw.githubusercontent.com/chapple01/ezHelper/main/version.json'
    local dlstatus = require('moonloader').download_status
    local requests = require('requests')
    local f = {}
    function f:getLastVersion()
        local response = requests.get(raw)
        if response.status_code == 200 then
            return decodeJson(response.text)['last']
        else
            return 'UNKNOWN'
        end
    end
    function f:download()
        local response = requests.get(raw)
        if response.status_code == 200 then
            downloadUrlToFile(decodeJson(response.text)['updateurl'], thisScript().path, function (id, status, p1, p2)
				if status == 57 then
					ezMessage('Начинаю загрузку скрипта...')
				end
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    ezMessage('Скрипт обновлен, перезагрузка...')
                end
            end)
        else
            ezMessage('Ошибка, невозможно установить обновление, код ошибки: '..response.status_code)
        end
    end
    return f
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
		fixarzdialogs = false
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
		antibreaklight = false,
		strobe = false,
		strobespeed = 250
	},
	hud =
	{
		huds = true,
		adrunk = true,
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
	},
	onDay = {
		today = os.date("%a"),
		online = 0
	}
}, directIni)

local cfg = {}
cfg.binds = {
    --{ name = "Название", text="текст", delay=555, hotkey= {1,2,3} }
}
local hcfg = {
	openscript = {},
	narko = {},
	aidkit = {},
	armor = {},
	beer = {},
	fllcar = {},
	repcar = {},
	hkstrobe = {},
	rcveh = {},
	surf = {},
	scate = {},
	domkrat = {},
	antifreeze = {},
	shar = {}
}

filename = getGameDirectory()..'\\moonloader\\config\\ezHelper\\binds.cfg'
ecfg.update(cfg, filename) -- загружает в переменную cfg значения из файла
ecfg.save(filename, cfg)

hkname = getGameDirectory()..'\\moonloader\\config\\ezHelper\\hotkeys.cfg'
ecfg.update(hcfg, hkname) -- загружает в переменную cfg значения из файла
ecfg.save(hkname, hcfg)

rhotkeys = {}
local tBlockKeys = {[vkeys.VK_RETURN] = true, [vkeys.VK_T] = true, [vkeys.VK_F6] = true, [vkeys.VK_F8] = true}
local tBlockChar = {[116] = true, [84] = true}
local tModKeys = {[vkeys.VK_MENU] = true, [vkeys.VK_CONTROL] = true}
local tBlockNextDown = {}

local tHotKeyData = {
    edit = nil,
	save = {},
   lastTick = os.clock(),
   tickState = false
}
local tKeys = {}

local openscript = {}
openscript.v = hcfg.openscript

local aidkit = {}
aidkit.v = hcfg.aidkit

local narko = {}
narko.v = hcfg.narko

local armor = {}
armor.v = hcfg.armor

local beer = {}
beer.v = hcfg.beer

local fllcar = {}
fllcar.v = hcfg.fllcar

local repcar = {}
repcar.v = hcfg.repcar

local hkstrobe = {}
hkstrobe.v = hcfg.hkstrobe

local rcveh = {}
rcveh.v = hcfg.rcveh

local surf = {}
surf.v = hcfg.surf

local scate = {}
scate.v = hcfg.scate

local domkrat = {}
domkrat.v = hcfg.domkrat

local antifreeze = {}
antifreeze.v = hcfg.antifreeze

local shar = {}
shar.v = hcfg.shar

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

--==[[ ВАНЯ, НЕ ЗАБУДЬ ЭТО ПОСЛЕ ОБНОВЛЕНИЯ УДАЛИТЬ, ТАК КАК МАКСИМ СКАЧАЕТ НОВЫЙ РЕНДЕР]]==--
if doesFileExist("moonloader/RenderFomikus.lua") then
	os.remove("moonloader/RenderFomikus.lua")
end
--==[[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]]==--

local boolfixes = {
	fixdver = new.bool(inik.fixes.fixdver),
	fixgps = new.bool(inik.fixes.fixgps),
	fixspawn = new.bool(inik.fixes.fixspawn),
	fixvint = new.bool(inik.fixes.fixvint),
	fixarzdialogs = new.bool(inik.fixes.fixarzdialogs)
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
	adrunk = new.bool(inik.hud.adrunk),
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
	trunk = new.bool(inik.carfuncs.trunk),
	antibreaklight = new.bool(inik.carfuncs.antibreaklight),
	strobe = new.bool(inik.carfuncs.strobe)
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
	fisheye = imgui.new.int(inik.features.fov),
	strobespeed = imgui.new.int(inik.carfuncs.strobespeed)
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
local cursor = true
local cursortw = true
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
local stroboscope = false
local ffixarzdialogs = false


local ping =  0
local servonl = 0
local connectingTime = 0

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
				end

				setTime(slider.hours[0])
				setWeather(slider.weather[0])
			end
		end
	end)
	sampRegisterChatCommand('infoveh',function ()
        act = not act
    end)
	sampRegisterChatCommand('mdemo',function ()
        widget[0] = not widget[0]
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

	local lastver = update():getLastVersion()
    ezMessage('Скрипт загружен. Версия: '..lastver)
    if thisScript().version ~= lastver then
        ezMessage('Вышло обновление скрипта ('..thisScript().version..' -> '..lastver..')!')
		updatewindow[0] = true
    end
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
		

	
	if mainIni.onDay.today ~= os.date("%a") then 
		mainIni.onDay.today = os.date("%a")
		mainIni.onDay.online = 0
	end
----------------------------------------------SpawnFix
		if boolfixes.fixspawn[0] == true then
			memory.fill(0x4217F4, 0x90, 21, true)
			memory.fill(0x4218D8, 0x90, 17, true)
			memory.fill(0x5F80C0, 0x90, 10, true)
			memory.fill(0x5FBA47, 0x90, 10, true)
		end
------------------------------------------------------

		lua_thread.create(strobe)
		lua_thread.create(famhide)
		lua_thread.create(time)

    while true do
		wait(0)

--FISHEYE-----------------------------------------------------------
		if features.fisheye[0] == true then
			if isCurrentCharWeapon(PLAYER_PED, 34) and isKeyDown(VK_RBUTTON) or isCurrentCharWeapon(PLAYER_PED, 43) and isKeyDown(VK_RBUTTON) then
				
				if locked then 
					cameraSetLerpFov(slider.fisheye[0], slider.fisheye[0], 10, 1)
					locked = true
				end
			else
				cameraSetLerpFov(slider.fisheye[0], slider.fisheye[0], 10, 1)
				locked = false
			end
		end
--FISHEYE-----------------------------------------------------------

		----------------------------------
		---------------------------------
		if BIND_START then
			BIND_START = false
			bindplay = true
			--ezMessage('Чтобы остановить отыгровку, нажмите {FFD700}END')
			
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
				bindplay = false
			end)
		end

		if bindplay then
			renderFontDrawText(bigfont,'Чтобы остановить отыгровку, нажмите {FFD700}END',sizeX / 1.41, sizeY / 1.045,-1)	
		end
		--------------------------------
		--------------------------------
		hotkeyactivate()


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
			playVolume(panic, 0)
		end
		if isKeyJustPressed(VK_END) and not sampIsChatInputActive() and not sampIsDialogActive() then
			bindplay = false
		end
		--[[sampev.onDisplayGameText = function(style, time, text)
			sampAddChatMessage('Текст: '..text, -1)
		end]]
		
		if boolfixes.fixarzdialogs[0] then
			if isKeyJustPressed(VK_B) and not sampIsChatInputActive() and not sampIsDialogActive() then
				ffixarzdialogs = true
			elseif isKeyJustPressed(VK_ESCAPE) and not sampIsChatInputActive() and not sampIsDialogActive() then
				ffixarzdialogs = false
			elseif isKeyDown(VK_F5) then
				printStringNow("Fix ARZ_Windows: ~b~~g~ACTIVATE", 10)
			end
			
			if ffixarzdialogs == true then
				printStringNow("Fix ARZ_Windows: ~b~~g~ACTIVATE", 10)
			end
		end
		--famhide
		
		


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

function hotkeyactivate()
	if not sampIsDialogActive() and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and not sampIsScoreboardOpen() then
		if #openscript.v < 2 then
			if wasKeyPressed(openscript.v[1]) then
				rwindow.switch()
				renderWindow[0] = true
				if rwindow.state == true then
					menu = 1
				end
			end
		else
			if isKeyDown(openscript.v[1]) and wasKeyPressed(openscript.v[2]) then
				rwindow.switch()
				renderWindow[0] = true
				if rwindow.state == true then
					menu = 1
				end
			end
		end

		if #aidkit.v < 2 then
			if wasKeyPressed(aidkit.v[1]) then
				sampSendChat('/usemed')
			end
		else
			if isKeyDown(aidkit.v[1]) and wasKeyPressed(aidkit.v[2]) then
				sampSendChat('/usemed')
			end
		end

		if #narko.v < 2 then
			if wasKeyPressed(narko.v[1]) then
				sampSendChat('/usedrugs 3')
			end
		else
			if isKeyDown(narko.v[1]) and wasKeyPressed(narko.v[2]) then
				sampSendChat('/usedrugs 3')
			end
		end

		if #armor.v < 2 then
			if wasKeyPressed(armor.v[1]) then
				sampSendChat('/armour')
			end
		else
			if isKeyDown(armor.v[1]) and wasKeyPressed(armor.v[2]) then
				sampSendChat('/armour')
			end
		end

		if #beer.v < 2 then
			if wasKeyPressed(beer.v[1]) then
				sampSendChat('/beer')
			end
		else
			if isKeyDown(beer.v[1]) and wasKeyPressed(beer.v[2]) then
				sampSendChat('/beer')
			end
		end

		if #fllcar.v < 2 then
			if wasKeyPressed(fllcar.v[1]) then
				sampSendChat('/fillcar')
			end
		else
			if isKeyDown(fllcar.v[1]) and wasKeyPressed(fllcar.v[2]) then
				sampSendChat('/fillcar')
			end
		end

		if #repcar.v < 2 then
			if wasKeyPressed(repcar.v[1]) then
				sampSendChat('/repcar')
			end
		else
			if isKeyDown(repcar.v[1]) and wasKeyPressed(repcar.v[2]) then
				sampSendChat('/repcar')
			end
		end

		if isCharInAnyCar(PLAYER_PED) and not isCharInAnyBoat(PLAYER_PED) and not isCharInAnyHeli(PLAYER_PED) and not isCharInAnyPlane(PLAYER_PED) and not isCharOnAnyBike(PLAYER_PED) then
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			local driverPed = getDriverOfCar(car)
			if isCarLightsOn(car) then
				if #hkstrobe.v < 2 then
					if wasKeyPressed(hkstrobe.v[1]) and driverPed == PLAYER_PED then
						stroboscope = not stroboscope
					end
				else
					if isKeyDown(hkstrobe.v[1]) and wasKeyPressed(hkstrobe.v[2]) and driverPed == PLAYER_PED then
						stroboscope = not stroboscope
					end
				end
			else
				stroboscope = false
			end
		end

		if #rcveh.v < 2 then
			if wasKeyPressed(rcveh.v[1]) then
				sampSendChat('/rcveh')
			end
		else
			if isKeyDown(rcveh.v[1]) and wasKeyPressed(rcveh.v[2]) then
				sampSendChat('/rcveh')
			end
		end

		if #surf.v < 2 then
			if wasKeyPressed(surf.v[1]) then
				sampSendChat('/surf')
			end
		else
			if isKeyDown(surf.v[1]) and wasKeyPressed(surf.v[2]) then
				sampSendChat('/surf')
			end
		end

		if #scate.v < 2 then
			if wasKeyPressed(scate.v[1]) then
				sampSendChat('/skate')
			end
		else
			if isKeyDown(scate.v[1]) and wasKeyPressed(scate.v[2]) then
				sampSendChat('/skate')
			end
		end

		if #domkrat.v < 2 then
			if wasKeyPressed(domkrat.v[1]) then
				sampSendChat('/domkrat')
			end
		else
			if isKeyDown(domkrat.v[1]) and wasKeyPressed(domkrat.v[2]) then
				sampSendChat('/domkrat')
			end
		end

		if #antifreeze.v < 2 then
			if wasKeyPressed(antifreeze.v[1]) and not isCharInAnyCar(1) and not isCharInAnyHeli(1) and not isCharInAnyPlane(1) and not isCharInAnyBoat(1) and not isCharInAnyPoliceVehicle(1) then
				freezeCharPosition(PLAYER_PED, true)
				freezeCharPosition(PLAYER_PED, false)
				setPlayerControl(PLAYER_HANDLE, true)
				restoreCameraJumpcut()
				clearCharTasksImmediately(PLAYER_PED)
			end
		else
			if isKeyDown(antifreeze.v[1]) and wasKeyPressed(antifreeze.v[2]) and not isCharInAnyCar(1) and not isCharInAnyHeli(1) and not isCharInAnyPlane(1) and not isCharInAnyBoat(1) and not isCharInAnyPoliceVehicle(1) then
				freezeCharPosition(PLAYER_PED, true)
				freezeCharPosition(PLAYER_PED, false)
				setPlayerControl(PLAYER_HANDLE, true)
				restoreCameraJumpcut()
				clearCharTasksImmediately(PLAYER_PED)
			end
		end

		if #shar.v < 2 then
			if wasKeyPressed(shar.v[1]) then
				sampSendChat('/balloon')
			end
		else
			if isKeyDown(shar.v[1]) and wasKeyPressed(shar.v[2]) then
				sampSendChat('/balloon')
			end
		end
	end
end

local thridFrame = imgui.OnFrame(
	function() return obvodka[0] end,
	function(player)
	if not isPauseMenuActive() then
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 1.24, 0), imgui.Cond.Always)
        imgui.SetNextWindowSize(imgui.ImVec2(400, 400), imgui.Cond.FirstUseEver)
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.0, 0.0, 0.0, 0.01))
        imgui.Begin(' ', obvodka, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		player.HideCursor = true
		imgui.DisableInput = true
		imgui.SetCursorPos(imgui.ImVec2(2, 1));
		imgui.BeginChild(" ",imgui.ImVec2(366, 398), true)
		imgui.EndChild()
		imgui.PopStyleColor(1)
		imgui.End()
	end
end
)

local widgetFrame = imgui.OnFrame(
	function() return widget[0] end,
	function(w)
		imgui.DisableInput = false
		w.HideCursor = (pie_mode[0] and not imgui.IsMouseDown(2))

		if not isPauseMenuActive() then
			
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 5.4, 850), imgui.Cond.Always)
			imgui.SetNextWindowSize(imgui.ImVec2(200, 120), imgui.Cond.Always)
			imgui.Begin('  ', widget, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar)
			imgui.PushFont(wfont)
			imgui.CenterTextColoredRGB(nowTime)
			imgui.PopFont()
			imgui.SetCursorPosY(25)
            imgui.CenterTextColoredRGB(getStrDate(os.time()))
			imgui.Separator()
			imgui.PushFont(smallfont)
			imgui.SetCursorPos(imgui.ImVec2(12, 52.5))
			imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_USER) imgui.SameLine(26)
			imgui.TextColoredRGB(tostring(pid))
			imgui.SetCursorPos(imgui.ImVec2(56, 52.5))
			imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_WIFI) imgui.SameLine(72)
			imgui.TextColoredRGB(tostring(ping))
			imgui.SetCursorPos(imgui.ImVec2(102, 52.5))
			imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_USERS) imgui.SameLine(120)
			imgui.TextColoredRGB(tostring(servonl))
			imgui.SetCursorPos(imgui.ImVec2(151, 52.5))
			imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_IMAGES) imgui.SameLine(168)
			imgui.TextColoredRGB(tostring(fps))
			imgui.SetCursorPosY(75)
			imgui.Separator()
			if sampGetGamestate() ~= 3 then
				imgui.CenterTextColoredRGB("Подключение: "..get_clock(connectingTime))
			else
				imgui.CenterTextColoredRGB("Сессия: "..get_clock(sesOnline[0]))
				imgui.CenterTextColoredRGB("За день: "..get_clock(mainIni.onDay.online))
			end
			imgui.PopFont()
			
			if pie_mode[0] then
				if imgui.IsMouseClicked(2) then imgui.OpenPopup('PieMenu') end
					if pie.BeginPiePopup('PieMenu', 2) then
					imgui.PushFont(piefont)
					if pie.BeginPieMenu(fa.ICON_FA_CAR..u8'Транспорт') then
						if pie.PieMenuItem(fa.ICON_FA_SNOWPLOW..u8'Домкрат') then
							sampSendChat("/domkrat")
						end
						if pie.PieMenuItem(fa.ICON_FA_BOLT..u8'Зарядить') then
							sampSendChat("/chargecar")
						end
						if pie.PieMenuItem(fa.ICON_FA_GAS_PUMP..u8'Заправить') then
							sampSendChat("/fillcar")
						end
						if pie.PieMenuItem(fa.ICON_FA_TOOLS..u8'Починить') then
							sampSendChat("/repcar")
						end
						pie.EndPieMenu()
					end
					if pie.BeginPieMenu(fa.ICON_FA_TOOLBOX..u8'Предметы') then
						if pie.PieMenuItem(fa.ICON_FA_TOOLS..u8'Аптечка') then
							sampSendChat("/usemed")
						end
						if pie.PieMenuItem(fa.ICON_FA_CANNABIS..u8'Наркотики') then
							sampSendChat("/usedrugs 3")
						end
						if pie.PieMenuItem(fa.ICON_FA_SHIELD_ALT..u8'Бронежилет') then
							sampSendChat("/armour")
						end
						if pie.PieMenuItem(fa.ICON_FA_WINE_BOTTLE..u8'Пиво') then
							sampSendChat("/beer")
						end
						pie.EndPieMenu()
					end
					if pie.BeginPieMenu(fa.ICON_FA_STAR..u8'Аксессуары') then
						if pie.PieMenuItem(fa.ICON_FA_GAMEPAD..u8'ПУ') then
							sampSendChat("/rcveh")
						end
						if pie.PieMenuItem(fa.ICON_FA_SNOWBOARDING..u8'Сёрф') then
							sampSendChat("/surf")
						end
						if pie.PieMenuItem(fa.ICON_FA_SNOWBOARDING..u8'Скейт') then
							sampSendChat("/skate")
						end
						if pie.PieMenuItem(fa.ICON_FA_GLOBE..u8'Шар') then
							sampSendChat("/balloon")
						end
						pie.EndPieMenu()
					end
					pie.EndPiePopup()
					imgui.PopFont()
				end
			end
		end
	end
)

local secondFrame = imgui.OnFrame(
	function() return hud[0] end,
	function(huds)
		

		if wasKeyPressed(VK_Q) and isKeyDown(VK_LMENU) then
			cursor = not cursor
		end
		huds.HideCursor = cursor

		if boolhud.huds[0] == true then
			if spawn == true then
				invent = sampTextdrawIsExists(inv)
			end		
			
			if not isPauseMenuActive() and invent == false then
				
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 1.24, 0), imgui.Cond.FirstUseEver)
				imgui.SetNextWindowSize(imgui.ImVec2(400, 400), imgui.Cond.FirstUseEver)
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.0, 0.0, 0.0, 0.01))
				imgui.Begin('', hud, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove)
				imgui.PopStyleColor(1)
				imgui.DisableInput = true

					if spawn == true then
						if boolhud.huds[0] == true then
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
		else
			hud[0] = false
		end
	end
)

local updateFrame = imgui.OnFrame(
	function() return updatewindow[0] end,
	function(player)
	if not isPauseMenuActive() then
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(270, 180), imgui.Cond.FirstUseEver)
        imgui.Begin("UpdateWindow", updatewindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
		imgui.DisableInput = false
		imgui.PushFont(mainfont)
		imgui.CenterTextColoredRGB('Обновление ezHelper!')
		imgui.Separator()
		imgui.PopFont()
		imgui.PushFont(smallfont)
		--imgui.CenterTextColoredRGB('Хотите ли вы обновить скрипт?')
		imgui.PopFont()
		imgui.BeginChild("##UpdateChild",imgui.ImVec2(260, 95), true)
		imgui.PushFont(smallfont)
		imgui.CenterTextColoredRGB('Что нового?')
		imgui.WrappedTextRGB(u8'Встречайте, PieMenu!\n1. Изменил радус PieMenu.\n2. Добавил виджет, мелкие багфиксы.\n3. Изменил отображение текста об отмене отыгровки в биндере.\n4. Скругление фреймов mimgui')
		imgui.PopFont()
		imgui.EndChild()
		imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
		imgui.SetCursorPos(imgui.ImVec2(((imgui.GetWindowWidth() + imgui.GetStyle().ItemSpacing.x) / 6 + 5), 130))
		imgui.PushFont(mainfont)
		if imgui.AnimatedButton(u8"Да", imgui.ImVec2(80, 35)) then updatewindow[0] = false update():download() end
		imgui.SetCursorPos(imgui.ImVec2(((imgui.GetWindowWidth() + imgui.GetStyle().ItemSpacing.x) / 6) + 88 + 5, 130))
		if imgui.AnimatedButton(u8"Нет", imgui.ImVec2(80, 35)) then updatewindow[0] = false end
		imgui.PopFont()
		imgui.PopStyleVar()
		
		imgui.End()
	end
end
)

local TimeWeatherFrame = imgui.OnFrame(
	function() return TWWindow.alpha > 0.00 end, -- Указываем здесь данное условие, тем самым рендеря окно только в том случае, если его прозрачность больше нуля
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 1.15), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(258, 165), imgui.Cond.FirstUseEver)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, TWWindow.alpha)
        imgui.Begin("TimeWeather", TimeWeatherWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
		imgui.DisableInput = false
		if TimeWeatherWindow[0] == false then
			TWWindow.switch()
			TimeWeatherWindow[0] = true
		end
		if isKeyDown(VK_LSHIFT) then
			cursortw = true
		else
			cursortw = false
		end

		player.HideCursor = cursortw
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
		imgui.CenterTextColoredRGB('Зажмите SHIFT, чтобы крутить камерой')
		imgui.End()
		imgui.PopStyleVar(1)
	end
)

local newFrame = imgui.OnFrame(
	function() return rwindow.alpha > 0.00 end, -- Указываем здесь данное условие, тем самым рендеря окно только в том случае, если его прозрачность больше нуля
    function(player)
        player.HideCursor = not rwindow.state -- // Курсор будет убираться на моменте, когда окно начинает исчезать
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(650, 400), imgui.Cond.FirstUseEver)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, rwindow.alpha)
        imgui.Begin("ezHelper v"..thisScript().version, renderWindow, imgui.WindowFlags.NoResize)
		imgui.DisableInput = false
            imgui.BeginChild("child",imgui.ImVec2(180, 366), false)
				if renderWindow[0] == false then
					rwindow.switch()
					renderWindow[0] = true
				end
				
                imgui.SetCursorPos(imgui.ImVec2(5.000000,5.000000));
				imgui.PushFont(mainfont)
				if imgui.AnimatedButton(fa.ICON_FA_HOME .. u8"Главная", imgui.ImVec2(170, 55)) then menu = 1 end
				imgui.SetCursorPos(imgui.ImVec2(5.000000,70.000000));
				if imgui.AnimatedButton(fa.ICON_FA_COGS .. u8"Функции", imgui.ImVec2(170, 55)) then menu = 2 end
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
						menu = 'hotkey'
						popupwindow.switch()
						checkpopupwindow = true
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
					hud[0] = true
					imgui.PushFont(smallfont)
					imgui.SetCursorPos(imgui.ImVec2(382.00000,73.600000));
					imgui.Text(fa.ICON_FA_COG)
					imgui.PopFont()
					if imgui.IsItemClicked() then
						imgui.OpenPopup('##hud')
					end
					if imgui.BeginPopup('##hud', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
						imgui.BeginChild("hud+",imgui.ImVec2(200, 80), false)
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
					

					--АнтиТряска---------------------------------------------------------------------------------------------------------------------
									imgui.SetCursorPos(imgui.ImVec2(5.000000,47.000000));
									if imgui.Checkbox(u8'   ', boolhud.adrunk) then
										mainIni.hud.adrunk = boolhud.adrunk[0]
										inicfg.save(mainIni, directIni)
									end

									imgui.SetCursorPos(imgui.ImVec2(30.000000,50.000000));
									imgui.Text(u8"АнтиТряска")
									imgui.SetCursorPos(imgui.ImVec2(30.000000,50.000000));
									imgui.TextQuestion("		  	", u8"Убирает тряску на экране.\nПомогает при ДТП и ломке.")

					--Энергия---------------------------------------------------------------------------------------------------------------------
									imgui.SetCursorPos(imgui.ImVec2(110.000000,17.000000));
									if imgui.Checkbox(u8'   ', boolhud.energy) then
										mainIni.hud.energy = boolhud.energy[0]
										inicfg.save(mainIni, directIni)
									end

									imgui.SetCursorPos(imgui.ImVec2(136.000000,20.000000));
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
						imgui.SetCursorPos(imgui.ImVec2(110.000000,47.000000));
						if imgui.Checkbox(u8'     ', boolhud.oxygen) then
							mainIni.hud.oxygen = boolhud.oxygen[0]
							inicfg.save(mainIni, directIni)
						end
						imgui.SetCursorPos(imgui.ImVec2(136.000000,50.000000));
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
				else
					hud[0] = false
				end

				imgui.ezHint('{FF0000}ПОЛЕЗНО ДЛЯ КОПОВ\n'..
				'Если игрок зайдёт в интерьер или выйдет из игры во время /pursuit, то\n'..
				'автоматически пробивается его /id',
				hpfont, mainfont, 298.000000, 21.000000)

				imgui.ezHint('Автоматически переключает оружие, когда садишься в машину.\n'..
				'{808080}Помогает, если вы забыли переключить оружие.',
				hpfont, mainfont, 298.000000, 46.000000)
						
				imgui.ezHint('HUD+ это функция, которая улучшает худ Аризоны РП.\n'..
				'{808080}Если мерцает курсор в других скриптах, нажмите {DCDCDC}ALT + Q',
				hpfont, mainfont, 298.000000, 71.000000)

				imgui.EndChild()
			imgui.PopStyleVar(1)


			imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, 6.0)
				imgui.SetCursorPos(imgui.ImVec2(9.000000,150.000000));
				imgui.BeginChild("carfuncs",imgui.ImVec2(225, 140), true)

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
				imgui.ezHint('{FFFFFF}Возвращает старое взаимодействие с багажником через {FFD700}ALT.\n'..
				'{808080}Чтобы открыть багажник Barracks, нажмите {FFD700}ПКМ + ALT',
				hpfont, mainfont, 126.000000, 49.000000)

				imgui.SetCursorPos(imgui.ImVec2(140.000000,73.000000));
				if imgui.Checkbox(u8"AntiFine", carfuncs.antifine) then
					mainIni.carfuncs.antifine = carfuncs.antifine[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('{FFFFFF}Не зачисляет штраф, когда вы падаете на машине в воду.\n'..
				'{808080}Штраф начислится, если вы выйдите из машины.',
				hpfont, mainfont, 126.000000, 74.000000)

				imgui.SetCursorPos(imgui.ImVec2(30.000000,98.000000));
				if imgui.Checkbox(u8"Strobes", carfuncs.strobe) then
					mainIni.carfuncs.strobe = carfuncs.strobe[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('Позволяет включать стробоскопы на любом транспорте.\n'..
				'{808080}Настроить кнопку на включение можно в ХотКеях.',
				hpfont, mainfont, 14.000000, 99.000000)

				if carfuncs.strobe[0] == true then
					imgui.PushFont(smallfont)
					imgui.SetCursorPos(imgui.ImVec2(107.35,102.6));
					imgui.Text(fa.ICON_FA_COG)
					imgui.PopFont()
					if imgui.IsItemClicked() then
						imgui.OpenPopup('##strobespeed')
					end
					if imgui.BeginPopup('##strobespeed', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
						if imgui.SliderInt('##slider.speed', slider.strobespeed, 150, 400) then 
							inicfg.load(mainIni, directIni)
							mainIni.carfuncs.strobespeed = slider.strobespeed[0]
							inicfg.save(mainIni, directIni)
						end
						imgui.EndPopup()
					end
				else
					stroboscope = false
				end

				imgui.SetCursorPos(imgui.ImVec2(140.000000,98.000000));
				if imgui.Checkbox(u8"ABL", carfuncs.antibreaklight) then
					mainIni.carfuncs.antibreaklight = carfuncs.antibreaklight[0]
					inicfg.save(mainIni, directIni)
				end
				imgui.ezHint('ABL - AntiBreakLight, делает фары автомобиля неломаемыми.\n'..
				'Приятно ездить, когда у тебя целые фары.',
				hpfont, mainfont, 126.000000, 99.000000)

				imgui.EndChild()
			imgui.PopStyleVar(1)

			imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, 6.0)
				imgui.SetCursorPos(imgui.ImVec2(249.000000,150.000000));
				imgui.BeginChild("fixes",imgui.ImVec2(165, 140), true)
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
				imgui.SetCursorPos(imgui.ImVec2(30.000000,95.000000));
				if imgui.Checkbox(u8"Фикс WARZ", boolfixes.fixarzdialogs) then
					mainIni.fixes.fixarzdialogs = boolfixes.fixarzdialogs[0]
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

				imgui.ezHint('{FF0000}[NEW]{FFFFFF} Исправляет баг с новыми окнами от лаунчера Аризоны РП.\n'..
				'{808080}Небо заменялось на окно баттлпаса/доната, F5.',
				hpfont, mainfont, 14.000000, 96.000000)
				
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
			if menu == 'hotkey' then
				hotkeylist()
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
					'		{E6E6FA}/infoveh - показывает, открыта ли машина\n' ..
					'		{E6E6FA}/mdemo - убрать виджет (временная команда)')
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
				u8'10.07.2022 - 1.3.5 - добавил автообновление скрипта. Исправил команду /findibiz; теперь её нужно вызывать через /fbz. Подправил код скрипта.\n'..
				u8'11.07.2022 - 1.3.6 - исправил баг без отклика в настройках времени и погоды\n'..
				u8'11.07.2022 - 1.3.7 - Встречайте: Хоткеи!\n'..
				u8'12.07.2022 - 1.3.8 - изменил автообновление в скрипте\n'..
				u8'12.07.2022 - 1.3.9 - добавил новые ХотКеи\n'..
				u8'18.07.2022 - 1.4.0 - исправил некоторые баги в скрипте, добавил функцию ABL. Изменил систему взаимодействия с багажником у Barracks. Исправил баг с худом при перезаходе. Добавил стробоскопы.\n'..
				u8'01.08.2022 - 1.4.1 - незначительные багфиксы.\n'..
				u8'04.08.2022 - 1.4.2 - обновил HUD+, подправил код скрипта, добавил новый HotKey.\n'..
				u8'04.08.2022 - 1.4.3 - оптимизировал скрипт, спасибо за помощь')
				imgui.SameLine(); imgui.Link('https://t.me/DoubleTapInside','Double Tap Inside')
				imgui.WrappedTextRGB(u8'26.08.2022 - 1.4.4 - фикс бага новых окон лаунчера от АРЗ, новые хоткеи\n'..
				u8'08.09.2022 - 1.4.5 - фикс бага автозаправки, новая функция "АнтиТряска", убрал hphud, так как в нём нет необходимости.\n'..
				u8'20.09.2022 - 1.4.7 - новые хоткеи, фикс багов.\n'..
				u8'01.10.2022 - 1.4.8 - очередной фикс бага с автозаправкой электрокаров, изменил название команды /showdoor на /infoveh, фикс бага со шрифтом.\n'..
				u8'03.10.2022 - 1.4.9 - встречайте, PieMenu! Изменил радус PieMenu. Добавил виджет, мелкие багфиксы. Изменил отображение текста об отмене отыгровки в биндере. Скругление фреймов mimgui\n'..
				u8'xx.10.2022 - 1.5.0 - Coming Soon...')
				imgui.PopFont()
				imgui.EndChild()
				puX = imgui.GetWindowWidth()
				imgui.SetCursorPos(imgui.ImVec2(puX / 2 - 35,345))
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

function hotkeylist()
	imgui.SetCursorPos(imgui.ImVec2(200.000000,25.000000));
	imgui.BeginChild("hotkey",imgui.ImVec2(430, 366), false)
	imgui.PushFont(smallfont)
	imgui.CenterTextColoredRGB('{1E90FF}Меню хоткеев')
	imgui.Separator()

			imgui.BeginChild("other",imgui.ImVec2(220, 55), true)
			imgui.CenterTextColoredRGB('{1E90FF}Основное')

				imgui.SetCursorPos(imgui.ImVec2(5,25 + 3));
				imgui.TextColoredRGB('Открытие скрипта')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8'Открытие скрипта').x + 10, 25))
				if imgui.HotKey(u8'##open', openscript, 90) then
					hcfg.openscript = {unpack(openscript.v)}
					ecfg.save(hkname, hcfg)
				end
	
			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(230.000000,22.000000));
			imgui.BeginChild("heal",imgui.ImVec2(195, 130), true)
			imgui.CenterTextColoredRGB('{1E90FF}Предметы')

				imgui.SetCursorPos(imgui.ImVec2(10,25 + 3));
				imgui.TextColoredRGB('Аптечка')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Бронежилет')).x + 15, 25))
				if imgui.HotKey(u8'##aidkit', aidkit, 90) then
					hcfg.aidkit = {unpack(aidkit.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,50 + 3));
				imgui.TextColoredRGB('Наркотики')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Бронежилет')).x + 15, 50))
				if imgui.HotKey(u8'##narko', narko, 90) then
					hcfg.narko = {unpack(narko.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,75 + 3));
				imgui.TextColoredRGB('Бронежилет')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Бронежилет')).x + 15, 75))
				if imgui.HotKey(u8'##armor', armor, 90) then
					hcfg.armor = {unpack(armor.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,100 + 3));
				imgui.TextColoredRGB('Пиво')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Бронежилет')).x + 15, 100))
				if imgui.HotKey(u8'##beer', beer, 90) then
					hcfg.beer = {unpack(beer.v)}
					ecfg.save(hkname, hcfg)
				end

			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(0.000000,85.000000));	
			imgui.BeginChild("acs",imgui.ImVec2(220, 130), true)
			imgui.CenterTextColoredRGB('{1E90FF}Аксессуары')

				imgui.SetCursorPos(imgui.ImVec2(5,25 + 3));
				imgui.TextColoredRGB('Активация ПУ')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Открытие скрипта')).x + 10, 25))
				if imgui.HotKey(u8'##rcveh', rcveh, 90) then
					hcfg.rcveh = {unpack(rcveh.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(5,50 + 3));
				imgui.TextColoredRGB('Доска для сёрфа')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Открытие скрипта')).x + 10, 50))
				if imgui.HotKey(u8'##surf', surf, 90) then
					hcfg.surf = {unpack(surf.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(5,75 + 3));
				imgui.TextColoredRGB('Скейт')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Открытие скрипта')).x + 10, 75))
				if imgui.HotKey(u8'##scate', scate, 90) then
					hcfg.scate = {unpack(scate.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(5,100 + 3));
				imgui.TextColoredRGB('Шар')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Открытие скрипта')).x + 10, 100))
				if imgui.HotKey(u8'##shar', shar, 90) then
					hcfg.shar = {unpack(shar.v)}
					ecfg.save(hkname, hcfg)
				end
			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(230.000000,160.000000));
			imgui.BeginChild("car",imgui.ImVec2(195, 130), true)
			imgui.CenterTextColoredRGB('{1E90FF}Автомобиль')

				imgui.SetCursorPos(imgui.ImVec2(10,25 + 3));
				imgui.TextColoredRGB('Заправить')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Бронежилет')).x + 15, 25))
				if imgui.HotKey(u8'##fllcar', fllcar, 90) then
					hcfg.fllcar = {unpack(fllcar.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,50 + 3));
				imgui.TextColoredRGB('Починить')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Бронежилет')).x + 15, 50))
				if imgui.HotKey(u8'##repcar', repcar, 90) then
					hcfg.repcar = {unpack(repcar.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,75 + 3));
				imgui.TextColoredRGB('Домкрат')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Бронежилет')).x + 15, 75))
				if imgui.HotKey(u8'##domkrat', domkrat, 90) then
					hcfg.domkrat = {unpack(domkrat.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,100 + 3));
				imgui.TextColoredRGB('Стробы')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Бронежилет')).x + 15, 100))
				if imgui.HotKey(u8'##hkstrobe', hkstrobe, 90) then
					hcfg.hkstrobe = {unpack(hkstrobe.v)}
					ecfg.save(hkname, hcfg)
				end

			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(0.000000,223.000000));	
			imgui.BeginChild("CheatFuncs	",imgui.ImVec2(220, 55), true)
			imgui.CenterTextColoredRGB('{FF0000}Чит-Функции')

					imgui.SetCursorPos(imgui.ImVec2(5,25 + 3));
					imgui.TextColoredRGB('Анти-Фриз')
					imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('Открытие скрипта')).x + 10, 25))
					if imgui.HotKey(u8'##antfrz', antifreeze, 90) then
						hcfg.antifreeze = {unpack(antifreeze.v)}
						ecfg.save(hkname, hcfg)
					end

		imgui.EndChild()
		
	imgui.PopFont()
	imgui.EndChild()
			
end

function imgui.Link(link,name,myfunc)
    myfunc = type(name) == 'boolean' and name or myfunc or false
    name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##'..link..name, size)
    if resultBtn then
        if not myfunc then
            os.execute('explorer '..link)
        end
    end
    imgui.SetCursorPos(p2)
    if imgui.IsItemHovered() then
        imgui.TextColored(imgui.ImVec4(0, 0.5, 1, 1), name)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32Vec4(imgui.ImVec4(0, 0.5, 1, 1)))
    else
        imgui.TextColored(imgui.ImVec4(0, 0.4, 1, 1), name)
    end
    return resultBtn
end

function onScriptTerminate(script, quit)
	gameClockk = 0
	clock = 0
	afk = 0
	if script == thisScript() then 
		if inicfg.save(mainIni, directIni) then sampfuncsLog('Ваш онлайн сохранён!') end
	end
end

function playVolume(arg, state)
	if doesFileExist(arg) then
		local audio = loadAudioStream(arg)
		setAudioStreamState(audio, state)
		setAudioStreamVolume(audio, 0.5)
	end
end

function sampev.onServerMessage(color, text)
	if features.autoid[0] == true then
		if text:find('Вы успешно начали погоню за игроком .') then
			namePur = text:match('Вы успешно начали погоню за игроком (%w+_?%w+)')
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

function sampev.onSendCommand(cmd)
    if cmd == "/donate" and boolfixes.fixarzdialogs[0] then 
    	ffixarzdialogs = true
    end
end

function setTime(hours)
    memory.write(0xB70153, hours, 1, false)
end

function setWeather(weather)
	forceWeatherNow(weather)
end

local cost_id
local arrow_id
local fill_id
local prodaoilfill = false
function sampev.onShowTextDraw(id, data)
	if data.text == "…H‹EHЏAP’" or data.text == "INVENTORY" then
		inv = id
	end

	if carfuncs.autofill[0] == true then
		--print("ID: "..id)
		--print("DATA: "..data.text)	
		--print("POS_X: "..data.position.x)
		--print("POS_Y: "..data.position.y)
		if data.text == "ELECTRIC" then
			electofill = true
		end
		if data.text == "DIESEL" or data.text == "A92" or data.text == "A95" or data.text == "A98" then
			oilfill = true
		end
		if data.text == "$0" or data.text == "FREE" then
			cost_id = id
		end
		if data.text == "FILL" then
			fill_id = id
		end
		if data.text == "LD_BEAT:chit" and data.selectable == 1 then
			arrow_id = id
		end
		if electofill == true then
			atfll = lua_thread.create_suspended(function()
				wait(150)
				sampSendClickTextdraw(cost_id)
				wait(450)
				sampSendClickTextdraw(fill_id)
			end)
			atfll:run()
			electofill = false
		end
			if oilfill == true then
				atfll = lua_thread.create_suspended(function()
					wait(400)
					if prodaoilfill == true then
						sampSendClickTextdraw(cost_id)
						wait(250)
						sampSendClickTextdraw(fill_id)
					end
				end)
				atfll:run()
				oilfill = false
				prodaoilfill = false
				
			end

	end
end

function sampev.onDisplayGameText(style, time, text)

	if carfuncs.autofill[0] == true then
		if fillcar == true then
			atfll = lua_thread.create_suspended(function()
				if text:find("~w~This type of fuel ~r~ is not suitable~w~~n~ for your vehicles!") then
					sampSendClickTextdraw(arrow_id)
					prodaoilfill = false
				else
					prodaoilfill = true
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

	if text:find("~y~PAYDAY~n~Launcher.+") then
		return false
	end
	
end

function sampev.onSetPlayerHealth(health)
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
				cursor = true
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

function sampev.onSetPlayerDrunk(drunkLevel)
	if boolhud.adrunk[0] then
    	return {1}
	end
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    if text:find("{929290}Вы должны подтвердить свой PIN%-код к карточке.") then
		sampSendDialogResponse(id, 1, nil, mainIni.features.pincode)
	end
	if text:find('{ffffff}Администратор (.+) ответил вам%:') then
		playVolume(panic, 1)
	end
	if id == 15330 then
		countdialog = countdialog + 1
		if countdialog >= 2 then return false end
		
    end
	--if text:find('.+') then	print(id, style, title, text) end
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

function isCarLightsOn(car)
	return readMemory(getCarPointer(car) + 0x428, 1) > 62
end

function time()
	startTime = os.time()
    connectingTime = 0
    while true do
        wait(1000)
        nowTime = os.date("%H:%M:%S", os.time())
		fps = ("%.0f"):format(memory.getfloat(0xB7CB50, true))
		ping =  tostring(sampGetPlayerPing(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
		if sampGetGamestate() == 3 then
	        sesOnline[0] = sesOnline[0] + 1
			mainIni.onDay.online = mainIni.onDay.online + 1
			connectingTime = 0
			_, pid = sampGetPlayerIdByCharHandle(playerPed)
			servonl = tostring(sampGetPlayerCount())
	    else
			pid = 0
			servonl = 1
            connectingTime = connectingTime + 1
	    	startTime = startTime + 1
	    end

    end
end

function get_clock(time)
    local timezone_offset = 86400 - os.date('%H', 0) * 3600
    if tonumber(time) >= 86400 then onDay = true else onDay = false end
    return os.date((onDay and math.floor(time / 86400)..'д ' or '')..'%H:%M:%S', time + timezone_offset)
end

function getStrDate(unixTime)
    local tMonths = {'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'}
	local tWeekdays = {[0] = 'Воскресенье', [1] = 'Понедельник', [2] = 'Вторник', [3] = 'Среда', [4] = 'Четверг', [5] = 'Пятница', [6] = 'Суббота'}
    local day = tonumber(os.date('%d', unixTime))
    local month = tMonths[tonumber(os.date('%m', unixTime))]
    local weekday = tWeekdays[tonumber(os.date('%w', unixTime))]
    return string.format('%s, %s %s', weekday, day, month)
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
					if result and not sampIsDialogActive() and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() then
						local idcar = getCarModel(target)
						if idcar == 433 then
							if wasKeyPressed(VK_RBUTTON) then
								sampSendChat("/trunk " .. id)
							end
						else
						sampSendChat("/trunk " .. id)
						end
					end
				end
            end
        end
    end
end

function famhide()
	while true do 
		wait(20)
		if hidefam[0] == true then
			for i=0, 2048 do
				if sampIs3dTextDefined(i) then
					local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(i)
					if text:find("Family") or text:find("Empire") or text:find("Squad") or text:find("Dynasty") or text:find("Corporation") or text:find("Crew") or text:find("Brotherhood") or text:find("Club") then
					sampDestroy3dText(i)
					end
				end
			end
		end
	end
end

function strobe()
	while true do wait(0)
		if isCharInAnyCar(PLAYER_PED) and not isCharInAnyBoat(PLAYER_PED) and not isCharInAnyHeli(PLAYER_PED) and not isCharInAnyPlane(PLAYER_PED) and not isCharOnAnyBike(PLAYER_PED) then
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			local ped = getDriverOfCar(car)
			local res, driverid = sampGetPlayerIdByCharHandle(ped)
			if isCharInAnyCar(PLAYER_PED) then
				local ptr = getCarPointer(car) + 1440
				if carfuncs.antibreaklight[0] == true then	
					if carfuncs.strobe[0] == true then
						if stroboscope == true then
							wait(slider.strobespeed[0])
							callMethod(7086336, ptr, 2, 0, 0, 0)
							callMethod(7086336, ptr, 2, 0, 1, 1)
							wait(slider.strobespeed[0])
							callMethod(7086336, ptr, 2, 0, 0, 1)
							callMethod(7086336, ptr, 2, 0, 1, 0)
						end
					end
					if stroboscope == false and carfuncs.antibreaklight[0] == true then
						callMethod(7086336, ptr, 2, 0, 1, 0)
						callMethod(7086336, ptr, 2, 0, 0, 0)
					end
				else
					if carfuncs.strobe[0] == true then
						if stroboscope == true then
							wait(slider.strobespeed[0])
							callMethod(7086336, ptr, 2, 0, 0, 0)
							callMethod(7086336, ptr, 2, 0, 1, 1)
							wait(slider.strobespeed[0])
							callMethod(7086336, ptr, 2, 0, 0, 1)
							callMethod(7086336, ptr, 2, 0, 1, 0)
							zaderjka = true
						end
						if stroboscope == false and carfuncs.antibreaklight[0] == false then
							if zaderjka == true then
								callMethod(7086336, ptr, 2, 0, 1, 0)
								callMethod(7086336, ptr, 2, 0, 0, 0)
								wait(500)
								zaderjka = false
							end
						end
					end
				end
			end
		end
	end
end

function files_add()
	if not doesDirectoryExist("moonloader\\resource\\ezHelper") then createDirectory('moonloader\\resource\\ezHelper') end
	if not doesFileExist('moonloader\\resource\\ezHelper\\panic.mp3') then
		ezMessage("{FF0000}Ошибка!{FFFFFF} У вас отсутствуют нужные файлы для работы скрипта, начинаю скачивание.")
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/panic.mp3?raw=true", getWorkingDirectory().."/resource/ezHelper/panic.mp3", function(id, status, p1, p2)
		end)
	end
	if not doesFileExist('moonloader\\resource\\ezHelper\\notification.mp3') then
		ezMessage("{FF0000}Ошибка!{FFFFFF} У вас отсутствуют нужные файлы для работы скрипта, начинаю скачивание.")
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/notification.mp3?raw=true", getWorkingDirectory().."/resource/ezHelper/notification.mp3", function(id, status, p1, p2)
			if status == 58 then
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
	style.WindowRounding = 8
	style.ChildRounding = 6
	style.PopupRounding = 4
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.FrameRounding = 4
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
            local color = imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]
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
	if not sampIsDialogActive() and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and not sampIsScoreboardOpen() and not inputblock then
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
return (tModKeys[id] or false) or (tBlockChar[id] or false)
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
		
        if tHotKeyData.edit ~= nil and wparam == VK_ESCAPE or wparam == VK_BACK or wparam == VK_F8 then
            tHotKeyData.save = {tHotKeyData.edit, {}}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
        end
        local num = getKeyNumber(wparam)
        if num == -1 then
            tKeys[#tKeys + 1] = wparam
            if tHotKeyData.edit ~= nil then
                if not isKeyModified(wparam) and #tKeys ~= 3 and unpack(tKeys) ~= 117 and unpack(tKeys) ~= 84 and unpack(tKeys) ~= 118 and unpack(tKeys) ~= 9 and unpack(tKeys) ~= 13 then
					print(unpack(tKeys))
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
