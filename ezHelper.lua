script_name('ezHelper')
script_author('CHAPPLE')
script_version("1.5.4")
script_properties('work-in-pause')

local tag = "{fff000}[ezHelper]: {ffffff}"
require "lib.moonloader"

	----===[[REQUIREMENTS]]===----
local vkeys = require 'vkeys'
local rkeys = require 'rkeys'
local sampev = require 'lib.samp.events'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local ecfg = require 'ecfg'
local imgui = require 'mimgui'
local ffi = require 'ffi'
local fa = require'fAwesome5'
local memory = require 'memory'
local bass = require 'lib.bass'
local pie = require 'mimgui_piemenu'
local requests = require 'requests'
local wm = require 'lib.windows.message'
local addons = require "ADDONS"

	-----===[[VARIABLES]]===-----
		-----==[[INT]]==-----
local lasthp = 0
local namePur = 0
local clock = 0
local gameClockk = 0
local afk = 0
local afks = 0
local countdialog = 0
local connectingcount = 0
local fps = 0
local ping = 0
local servonl = 0
local connectingTime = 0
local cost_id = 0
local arrow_id = 0
local fill_id = 0

	  -----===[[BOOLS]]===-----
local cursor = true
local cursortw = true
local inputblock = false
local checkpopupwindow = false
local stroboscope = false
local fixnewarzframes = false
local actv = false
local spawn = false
local fillcar = false
local prodaoilfill = false
local callproda = false

		-----==[[OTHER]]==-----
local directIni = "ezHelper/ezHelper.ini"
local directOIni = "ezHelper/ezOnline.ini"
local gsub, gmatch, find, ceil, len = string.gsub, string.gmatch, string.find, math.ceil, string.len
local sizeX, sizeY = getScreenResolution()
local nowTime = os.date("%H:%M:%S", os.time())
encoding.default = 'CP1251'         
local u8 = encoding.UTF8

local updateText = [[��������� ��� �������. ����� ������� HUD+, � ����� �� ��������� �������. ������� ������� CorrectDMG. ������� ���� ���������� �������.]]
local logversionText1 = [[01.07.2022 - 1.2.0 - �������� ��������� ��� � ��������.
02.07.2022 - 1.2.1 - ������� ������� /showdoor, ����� ������.
02.07.2022 - 1.2.2 - ������ ������ ������� ��������� ���, �������� ���������.
02.07.2022 - 1.2.3 - �������� ����� ������� �� ���������� (����������� � ������� ����).
05.07.2022 - 1.2.5 - ������� ���c���� �������, ������� ������� ��������� ���, �������� ���������.
05.07.2022 - 1.2.6 - ������� ����� ��������� ������� � �������: "CarFuncs".
06.07.2022 - 1.2.7 - �������� ��� � AutoFill. ������� AutoFill ��� ������������.
06.07.2022 - 1.3.0 - �������� ��� HUD+ � ������ ���������� �� �������. ������ �������� PopUp'a.
07.07.2022 - 1.3.1 - �������� ������ ���� � ����� ������.
07.07.2022 - 1.3.2 - �������� ���� � ������������� �������� �������.
10.07.2022 - 1.3.5 - ������� � ������ ��������������. �������� ������� /findibiz. ������ � ����� �������� ����� /fbz. ��������� ��� �������.
11.07.2022 - 1.3.6 - �������� ��� ��������� � ����������� ������� � ������.
11.07.2022 - 1.3.7 - ����������: ������! (����)
12.07.2022 - 1.3.8 - ������� �������������� � �������.
12.07.2022 - 1.3.9 - ������� ����� ������.
18.07.2022 - 1.4.0 - �������� ��������� ���� � �������, ������� ������� ABL. ������� ������� �������������� � ���������� � Barracks. �������� ��� � HUD+ ��� ����������. ������� �����������.
01.08.2022 - 1.4.1 - �������������� ��������.
04.08.2022 - 1.4.2 - ������� HUD+, ��������� ��� �������, ������� ����� ������.
04.08.2022 - 1.4.3 - ������������� ������, ������� �� ������]]
local logversionText2 = [[26.08.2022 - 1.4.4 - ������� ���� ���� ����� ���� �������� �� ���, ����� ������.
08.09.2022 - 1.4.5 - ���� ���� ������������, ����� ������� "����������", ����� �� HUD+ ������� hphud, ��-�� ������������.
20.09.2022 - 1.4.7 - ����� ������, ���� ��������� �����.
01.10.2022 - 1.4.8 - ��������� ���� ���� � ������������� ������������, ������� ������� /showdoor �� /infoveh, ���� ���� �� �������.
03.10.2022 - 1.4.9 - ����������, PieMenu! ������� ����� PieMenu. ������� ������, ������ ��������. ������� ����������� ������ �� ������ ��������� � �������. ���������� ������� ������.
15.10.2022 - 1.5.0 - ��������� ��� �������. ������� ������ �������, ����� ������� HUD+, ������� ������ �������, ����� ���. ������� ������� CorrectDMG. ������� ���� ���������� �������. ����� ������� /�all [ID]. ����� ������� Music After Connected [MAC]. ������ ������������ ������ �������.
21.10.2022 - 1.5.1 - ������ ��������.
03.11.2022 - 1.5.2 - {FF69B4}[Update From The Hospital]{ffffff} ������� RHUD. �������� ���� � RHUD. ������� �������� �� ������� (checkbox).
06.11.2022 - 1.5.3 - {FF69B4}[Update From The Hospital]{ffffff} ������� ����������� ���������� ������� ����������� � �������.
25.11.2022 - 1.5.4 - ������������� ������� ����������� ���������� ������� ����������� � �������. �������� ������� AutoID. �������� ������ ���� � RHUD, ������� �������� ������, ����� �� ���������. ����������� ������ ������� "Autofill", AutoTT", "RGPS", "Correct DMG" - ������� �������, ����� ������������ ����� ���� ������: 1) ������������ ������� 2) �������� ������ �� ������.
]]

	-----===[[INIFILE]]===-----
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
		fixarzdialogs = false,
		launcher = true,
	},
	fpsup =	{hidefam = false},
	features =
	{
		autoid = false,
		fisheye = false,
		autopin = false,
		panicarz = false,
		correctdmg = false,
		mac = true,
		kolokol = true,
		kolvolume = 1,
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
		hud = false,
		maxhp = 100,
		lid = 1,
		adrunk = true,
		hun = 0
	},
	TimeWeather =
	{
		twtoggle = true,
		hours = 12,
		weather = 0,
		realtime = true,
	},
}, directIni)

local onlineIni = inicfg.load({
	onDay = {
		today = os.date("%a"),
		online = 0
	}
}, directOIni)

if not doesFileExist("moonloader/config/ezHelper/ezHelper.ini") then inicfg.save(mainIni, directIni) end
if not doesFileExist("moonloader/config/ezHelper/ezOnline.ini") then inicfg.save(onlineIni, directOIni) end

	-----===[[SOUNDS]]===-----
local panic = getGameDirectory().."\\moonloader\\resource\\ezHelper\\panic.mp3"
local notification = getGameDirectory().."\\moonloader\\resource\\ezHelper\\notification.mp3"

	-----===[[IMAGES]]===-----

	-----===[[FONTS]]===-----
local font = renderCreateFont('segmdl2', 10, 5)
local bigfont = renderCreateFont('segmdl2', 14, 5)

local widgetcfg = {
	widget = {
		active = true,
		info = true,
		online = true,
		wpos = {
			posX = 349,
			posY = 889,
		},
		color = {0, 0, 0, 1},
	},
	piemenu_active = true,

	piemenu_car_fill = true,
	piemenu_car_charge = true,
	piemenu_car_repcar = true,
	piemenu_car_domkrat = true,

	piemenu_item_healmed = true,
	piemenu_item_narko = true,
	piemenu_item_armor = true,
	piemenu_item_beer = true,
	piemenu_item_mask = true,

	piemenu_acs_rcveh = true,
	piemenu_acs_skate = true,
	piemenu_acs_surf = true,
	piemenu_acs_shar = true,
	piemenu_acs_deltap = true,
	
	piemenu_rp_bodycam = true,

}
wgname = getGameDirectory()..'\\moonloader\\config\\ezHelper\\widget.cfg'
ecfg.update(widgetcfg, wgname)
ecfg.save(wgname, widgetcfg)

	-----===[[IMGUI VARIABLES]]===-----
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local renderWindow = new.bool(false)
local TimeWeatherWindow = new.bool(false)
local updatewindow = new.bool(false)
local sesOnline = new.int(0)
local oxygen = new.int(100)
local hidefam = new.bool(mainIni.fpsup.hidefam)

local boolfixes = {
	fixdver = new.bool(mainIni.fixes.fixdver),
	fixgps = new.bool(mainIni.fixes.fixgps),
	fixspawn = new.bool(mainIni.fixes.fixspawn),
	fixvint = new.bool(mainIni.fixes.fixvint),
	fixarzdialogs = new.bool(mainIni.fixes.fixarzdialogs),
	launcher = new.bool(mainIni.fixes.launcher),
}

local binder = {
	delay = imgui.new.float(5),
	btext = new.char[10000](),
	bname = new.char[50]()
}

local boolhud = {
	hud = new.bool(mainIni.hud.hud),
	show = new.bool(true),
	maxhp = new.int(mainIni.hud.maxhp),
	lid = new.int(mainIni.hud.lid),
	adrunk = new.bool(mainIni.hud.adrunk)
}

local boolwidget = {
	widget = new.bool(widgetcfg.widget.active),
	show = new.bool(true),
	info = new.bool(widgetcfg.widget.info),
	online = new.bool(widgetcfg.widget.online),
	color = new.float[4](widgetcfg.widget.color),
	posX = widgetcfg.widget.wpos.posX,
	posY = widgetcfg.widget.wpos.posY
}

local piebool = {
	piemenu = new.bool(widgetcfg.piemenu_active),

	fillcar = new.bool(widgetcfg.piemenu_car_fill),
	chargecar = new.bool(widgetcfg.piemenu_car_charge),
	repcar = new.bool(widgetcfg.piemenu_car_repcar),
	domkrat = new.bool(widgetcfg.piemenu_car_domkrat),

	healmed = new.bool(widgetcfg.piemenu_item_healmed),
	narko = new.bool(widgetcfg.piemenu_item_narko),
	armor = new.bool(widgetcfg.piemenu_item_armor),
	beer = new.bool(widgetcfg.piemenu_item_beer),
	mask = new.bool(widgetcfg.piemenu_item_mask),

	rcveh = new.bool(widgetcfg.piemenu_acs_rcveh),
	skate = new.bool(widgetcfg.piemenu_acs_skate),
	surf = new.bool(widgetcfg.piemenu_acs_surf),
	shar = new.bool(widgetcfg.piemenu_acs_shar),
	deltap = new.bool(widgetcfg.piemenu_acs_deltap)
}

local features = {
	fisheye = new.bool(mainIni.features.fisheye),
	autoid = new.bool(mainIni.features.autoid),
	autopin = new.bool(mainIni.features.autopin),
	pincode = new.char[20](u8:decode(mainIni.features.pincode)),
	panicarz = new.bool(mainIni.features.panicarz),
	correctdmg = new.bool(mainIni.features.correctdmg),
	mac = new.bool(mainIni.features.mac),
	kolokol = new.bool(mainIni.features.kolokol)
}

local ezafk = {
	afkcontrol = new.bool(mainIni.afkcontrol.afkcontrol),
	afkexit = new.bool(mainIni.afkcontrol.afkexit),
	afklimit = new.int(mainIni.afkcontrol.afklimit),
	afkexittime = new.int(mainIni.afkcontrol.afkexittime)
}

local carfuncs = {
	autoscroll = new.bool(mainIni.carfuncs.autoscroll),
	autotwinturbo = new.bool(mainIni.carfuncs.autotwinturbo),
	autofill = new.bool(mainIni.carfuncs.autofill),
	carlight = new.bool(mainIni.carfuncs.carlight),
	antifine = new.bool(mainIni.carfuncs.antifine),
	trunk = new.bool(mainIni.carfuncs.trunk),
	antibreaklight = new.bool(mainIni.carfuncs.antibreaklight),
	strobe = new.bool(mainIni.carfuncs.strobe)
}

local WeaponsList = {"M4A1", "Combat Shotgun", "AK-47", 'Shotgun'}
local combobox = {
	current_weapon = imgui.new.int(0),
	weapons = imgui.new['const char*'][#WeaponsList](WeaponsList)
}

local TimeWeather = {
	twtoggle = new.bool(mainIni.TimeWeather.twtoggle),
	realtime = new.bool(mainIni.TimeWeather.realtime)
}

local slider = {
    hours = imgui.new.int(mainIni.TimeWeather.hours),
    weather = imgui.new.int(mainIni.TimeWeather.weather),
	fisheye = imgui.new.int(mainIni.features.fov),
	strobespeed = imgui.new.int(mainIni.carfuncs.strobespeed),
	kolvolume = new.int(mainIni.features.kolvolume)
}

local fa_icon = {
	['ICON_FA_VK'] = "\xef\x86\x89",
	['ICON_FA_TELEGRAM_PLANE'] = "\xef\x8f\xbe",
	['ICON_FA_DISCORD'] = "\xef\x8e\x92",
}

local ui_meta = {
    __index = function(self, v)
        if v == "switch" then
            local switch = function()
                if self.process and self.process:status() ~= "dead" then
                    return false -- // ���������� �������� ��� �� �����������!
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
                return true -- // ��������� ���� ��������!
            end
            return switch
        end
 
        if v == "alpha" then
            return self.state and 1.00 or 0.00
        end
    end
}
	-----===[[BINDERCFG]]===-----
local cfg = {}
cfg.binds = {}

filename = getGameDirectory()..'\\moonloader\\config\\ezHelper\\binds.cfg'
ecfg.update(cfg, filename)
ecfg.save(filename, cfg)

	-----===[[HOTKEYCFG]]===-----
local hcfg = {
	openscript = {}, antifreeze = {},  --OTHER
	narko = {}, aidkit = {}, armor = {}, beer = {}, --ITEMS
	fllcar = {}, repcar = {}, hkstrobe = {}, domkrat = {}, --CARS
	rcveh = {},	surf = {}, skate = {}, shar = {}, deltap = {} --ACS
}

hkname = getGameDirectory()..'\\moonloader\\config\\ezHelper\\hotkeys.cfg'
ecfg.update(hcfg, hkname) -- ��������� � ���������� cfg �������� �� �����
ecfg.save(hkname, hcfg)

	-----===[[HOTKEYS SETTINGS]]===-----
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

	-----===[[HOTKEY VARIABLES]]===-----
local bhotkey = {}
bhotkey.v = {}

local openscript, antifreeze = {}, {}
local aidkit, narko, armor, beer = {}, {}, {}, {}
local fllcar, repcar, hkstrobe, domkrat = {}, {}, {}, {}
local rcveh, surf, skate, shar, deltap = {}, {}, {}, {}, {}

openscript.v, antifreeze.v = hcfg.openscript, hcfg.antifreeze
aidkit.v, narko.v, armor.v, beer.v = hcfg.aidkit, hcfg.narko, hcfg.armor, hcfg.beer
fllcar.v, repcar.v, hkstrobe.v, domkrat.v = hcfg.fllcar, hcfg.repcar, hcfg.hkstrobe, hcfg.domkrat
rcveh.v, surf.v, skate.v, shar.v, deltap.v = hcfg.rcveh, hcfg.surf, hcfg.skate, hcfg.shar, hcfg.deltap

local rwindow = { state = false, duration = 0.5 }	--�������� ����
setmetatable(rwindow, ui_meta)

local TWWindow = { state = false, duration = 0.5 }	--����������� ����
setmetatable(TWWindow, ui_meta)

local popupwindow = { state = false, duration = 0.4 } --����� ����
setmetatable(popupwindow, ui_meta)

local colorhunger = { state = false, duration = 0.2 } --�����
setmetatable(colorhunger, ui_meta)

--==[[\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\]]==--
------------------------KEYSNAMES------------------------
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
-----------------------ENDKEYSNAMES-----------------------
--==[[\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\]]==--

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

function update()
    local raw = 'https://raw.githubusercontent.com/chapple01/ezHelper/main/version.json'
	local rawupdate = 'https://raw.githubusercontent.com/chapple01/ezHelper/main/updateText.json'
    local dlstatus = require('moonloader').download_status
    local f = {}
    function f:getLastVersion()
        local response = requests.get(raw)
        if response.status_code == 200 then
            return decodeJson(response.text)['last']
        else
            return 'UNKNOWN'
        end
    end
	function f:getUpdateText()
		local response = requests.get(rawupdate)
		print(unpack(response))
        if response.status_code == 200 then
            return decodeJson(response.text)['newupdate']
        else
            return 'UNKNOWN'
        end
	end
    function f:download()
        local response = requests.get(raw)
        if response.status_code == 200 then
            downloadUrlToFile(decodeJson(response.text)['updateurl'], thisScript().path, function (id, status, p1, p2)
				if status == 57 then
					ezMessage('������� �������� �������...')
				end
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    ezMessage('������ ��������, ������������...')
                end
            end)
        else
            ezMessage('������, ���������� ���������� ����������, ��� ������: '..response.status_code)
        end
    end
    return f
end

local utext = update():getUpdateText()
local menu = {
    opened = imgui.new.bool(false),
    selected = {[0] = ''}, -- ��������� ����� (�������� ����� menu.selected[0])
}

imgui.OnInitialize(function()
	apply_custom_style()

	local dirImages = getWorkingDirectory() .. "\\resource\\ezHelper\\WeaponsIcon"
	weapons = {}
	for i = 0, 46 do
		local path = string.format("%s\\%s.png", dirImages, i)
		if doesFileExist(path) then 
			weapons[i] = imgui.CreateTextureFromFile(path)
		end
	end
	slogo = imgui.CreateTextureFromFile(getWorkingDirectory()..'\\resource\\ezHelper\\arz07.png')

	logo1 = imgui.CreateTextureFromFile(getWorkingDirectory()..'\\resource\\ezHelper\\logo\\common1.png')
	logo2 = imgui.CreateTextureFromFile(getWorkingDirectory()..'\\resource\\ezHelper\\logo\\common2.png')
	logo3 = imgui.CreateTextureFromFile(getWorkingDirectory()..'\\resource\\ezHelper\\logo\\Halloween.png')
	logo4 = imgui.CreateTextureFromFile(getWorkingDirectory()..'\\resource\\ezHelper\\logo\\HiTech.png')
	logo = {logo1, logo2, logo3, logo4}

	xPD = imgui.CreateTextureFromFile(getWorkingDirectory() .. "\\resource\\ezHelper\\XPayDay.png")

	local config = imgui.ImFontConfig()
    config.MergeMode = true
	config.GlyphOffset.y = 1.0
	config.GlyphOffset.x = -5.0
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
    mainfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 16.0, nil, glyph_ranges) --16
   	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 20.0, config, iconRanges)
	smallfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 14.0, nil, glyph_ranges) --14
	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 15.0, config, iconRanges)
	piefont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 15.0, nil, glyph_ranges) --15
	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 22.0, config, iconRanges)
	brandfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 16.0, nil, glyph_ranges) -- brands font
	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-brands-400.ttf', 25.0, config, iconRanges) --brands font
	hpfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 18.0, nil, glyph_ranges) --18
   	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 16.0, config, iconRanges)

 	wfont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/arialbd.ttf', 24.0, nil, glyph_ranges) --24
	icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 24.0, config, iconRanges)
	hudfont1 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ezHelper/fonts/unineueheavy-italic.ttf', 24.0, nil, glyph_ranges) --24
		icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 24.0, config, iconRanges)
	hudfont2 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ezHelper/fonts/unineueheavy-italic.ttf', 26.0, nil, glyph_ranges) --24
		icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-regular-400.ttf', 24.0, config, iconRanges)
	hudfont3 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ezHelper/fonts/UniNeueHeavy.ttf', 28.0, nil, glyph_ranges) --24
		icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 30.0, config, iconRanges)
	wanted1font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ezHelper/fonts/unineueheavy-italic.ttf', 20.0, nil, glyph_ranges) --24
		icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-regular-400.ttf', 16.0, config, iconRanges)
	wanted2font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ezHelper/fonts/unineueheavy-italic.ttf', 20.0, nil, glyph_ranges) --24
		icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 16.0, config, iconRanges)
	hudfont4 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ezHelper/fonts/GothamProNarrow-Medium.ttf', 20.0, nil, glyph_ranges) --20
	hudfont5 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ezHelper/fonts/PFDinDisplayPro-Regular.ttf', 18.0, nil, glyph_ranges) --18
	hudfont6 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ezHelper/fonts/GothamProNarrow-Bold.ttf', 13.0, nil, glyph_ranges) --16
		icon = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 16.0, config, iconRanges)
	hudfont7 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/ezHelper/fonts/UniNeueHeavy.ttf', 19.0, nil, glyph_ranges) --24


	imgui.GetIO().IniFilename = nil
end)

local hun = 0

--HOOKS
local hook = {hooks = {}}
addEventHandler('onScriptTerminate', function(scr)
    if scr == script.this then
        for i, hook in ipairs(hook.hooks) do
            if hook.status then
                hook.stop()
            end
        end
    end
end)
ffi.cdef [[
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
]]
function hook.new(cast, callback, hook_addr, size)
    jit.off(callback, true) --off jit compilation | thx FYP
    local size = size or 5
    local new_hook = {}
    local detour_addr = tonumber(ffi.cast('intptr_t', ffi.cast('void*', ffi.cast(cast, callback))))
    local void_addr = ffi.cast('void*', hook_addr)
    local old_prot = ffi.new('unsigned long[1]')
    local org_bytes = ffi.new('uint8_t[?]', size)
    ffi.copy(org_bytes, void_addr, size)
    local hook_bytes = ffi.new('uint8_t[?]', size, 0x90)
    hook_bytes[0] = 0xE9
    ffi.cast('uint32_t*', hook_bytes + 1)[0] = detour_addr - hook_addr - 5
    new_hook.call = ffi.cast(cast, hook_addr)
    new_hook.status = false
    local function set_status(bool)
        new_hook.status = bool
        ffi.C.VirtualProtect(void_addr, size, 0x40, old_prot)
        ffi.copy(void_addr, bool and hook_bytes or org_bytes, size)
        ffi.C.VirtualProtect(void_addr, size, old_prot[0], old_prot)
    end
    new_hook.stop = function() set_status(false) end
    new_hook.start = function() set_status(true) end
    new_hook.start()
    table.insert(hook.hooks, new_hook)
    return setmetatable(new_hook, {
        __call = function(self, ...)
            self.stop()
            local res = self.call(...)
            self.start()
            return res
        end
    })
end
--HOOKS

--MAIN
function main()
    while not isSampAvailable() do
        wait(100)
    end
    applySampfuncsPatch()
    lua_thread.create(time)
	mac = bass.BASS_StreamCreateFile(false, "moonloader\\resource\\ezHelper\\oldarzmusic.mp3", 0, 0, 0)
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
	sampChatHook = hook.new("void(__thiscall *)(uintptr_t this, uint32_t type, const char* text, const char* prefix, uint32_t color, uint32_t pcolor)", sampChatHook, getModuleHandle('samp.dll') + 0x67460)
	
	repeat
		wait(0)
	until sampIsLocalPlayerSpawned()
	spawn = true
	local lastver = update():getLastVersion()
    ezMessage('������ ��������. ������: '..lastver)
    if thisScript().version ~= lastver then
        ezMessage('����� ���������� ������� ('..thisScript().version..' -> '..lastver..')!')
		updatewindow[0] = true
    end
	files_add()

	sampRegisterChatCommand("ezhelper", function()
		if spawn == true then
			rwindow.switch()
			renderWindow[0] = true
			menu_ = 1
			menu.selected[0] = 1
		else
			ezMessage("��� ������������� ������� ���������� ��������������.")
		end
	end)
	sampRegisterChatCommand("fh", function(id)
		if id == "" then
			ezMessage("������� ID ����: /fh [ID].")
		else
			sampSendChat('/findihouse '..id..'')
		end
	end)
	sampRegisterChatCommand("fbz", function(id)
		if id == "" then
			ezMessage("������� ID �������: /fbz [ID].")
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
			ezMessage("������� ID ����������: /cjb [ID].")
		else
			sampSendChat('/checkjobprogress '..id..'')
		end
	end)
	sampRegisterChatCommand("mb", function()
		sampSendChat("/members")
	end)
	sampRegisterChatCommand("delltd", function()
		for a = 0, 2304	do
			sampTextdrawDelete(a)
		end
	end)
	sampRegisterChatCommand("st", function(hours)
		if TimeWeather.twtoggle[0] == true then
			if hours == "" then
				ezMessage("����� �����: /st [0-23].")
			else 
				local hours = tonumber(hours)
				if hours < 0 or hours > 23 then ezMessage("�������� ������ ���� �� ������ 0 � �� ������ 23") else
					if hours >= 0 and hours <= 23 then ezMessage("�������� ������� ����������� �� {F7E937}" .. hours)
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
				ezMessage("����� �����: /sw [0-23].")
			else 
				local weather = tonumber(weather)
				if weather < 0 or weather > 45 then ezMessage("�������� ������ ���� �� ������ 0 � �� ������ 45") else
					if weather >= 0 and weather <= 45 then ezMessage("�������� ������ ����������� �� {F7E937}" .. weather)
						slider.weather[0] = weather
						mainIni.TimeWeather.weather = weather
						inicfg.save(mainIni, directIni)
						setTime(weather)
					end
				end
			end
		end
	end)
	sampRegisterChatCommand('infoveh',function ()
        iveh = not iveh
    end)

	sampRegisterChatCommand('call', function(arg)
		if arg == "" then 
			ezMessage("����� ID ������, �������� ������ ���������: /call [ID].")
		else 
			callpotok = lua_thread.create(function()
				sampSendChat(string.format("/number %s", arg))
				callproda = true
				wait(500)
				sampSendChat(string.format("/call %s", number))
			end)
		end
	end)

		

	
	if onlineIni.onDay.today ~= os.date("%a") then 
		onlineIni.onDay.today = os.date("%a")
		onlineIni.onDay.online = 0
	end
----------------------------------------------SpawnFix
		if boolfixes.fixspawn[0] == true then
			memory.fill(0x4217F4, 0x90, 21, true)
			memory.fill(0x4218D8, 0x90, 17, true)
			memory.fill(0x5F80C0, 0x90, 10, true)
			memory.fill(0x5FBA47, 0x90, 10, true)
		end
------------------------------------------------------

    	lua_thread.create(carfunc)
		lua_thread.create(strobe)
		lua_thread.create(famhide)

    while true do
		wait(0)
		
		if sampGetGamestate() ~= 3 then
			thisScript():reload()
		end

	-----===[[FISHEYE]]===-----
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

	-----===[[BINDPLAY]]===-----
		if BIND_START then
			BIND_START = false
			bindplay = true
			
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
			renderFontDrawText(bigfont,'����� ���������� ���������, ������� {FFD700}END',sizeX / 1.41, sizeY / 1.045,-1)	
		end

		-----===[[CARTWEAKS]]===-----
		if not boolfixes.launcher[0] then
			if isKeyJustPressed(VK_L) and not sampIsChatInputActive() and not sampIsDialogActive() then
				sampSendChat("/lock")
			end	
			if isKeyJustPressed(VK_K) and not sampIsChatInputActive() and not sampIsDialogActive() then
				sampSendChat("/key")
			end
		end
        if isKeyJustPressed(VK_O) and not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat("/olock")	
		end
        if isKeyJustPressed(VK_J) and not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat("/jlock")
		end

		-----===[[OTHER]]===-----
		if isKeyJustPressed(VK_BACK) and not sampIsChatInputActive() and not sampIsDialogActive() then
			playVolume(panic, 0)
		end
		if isKeyJustPressed(VK_END) and not sampIsChatInputActive() and not sampIsDialogActive() then
			bindplay = false
		end

		fixes_func()
		hotkeyactivate()
		autoscroll_func()
		afkcontrol_func()
    end
end

function sampChatHook(this, type, text, prefix, color, pcolor)
    local text = ffi.string(text)
    if text:find('^������ �����%. ��������� �����������%.%.%.') then
        connectingcount = connectingcount + 1
        text = ('%s (x%d)'):format(text, connectingcount)
    elseif text:find('^�������� ����%. �������� ���� �� ������� .+') then
        text = ('�������� ���� (�������: %d) �������� ���� �� ������� :)'):format(connectingcount)
		connectingcount = 0
    end
    sampChatHook(this, type, text, prefix, color, pcolor)
end

function fixes_func()
	if boolfixes.fixarzdialogs[0] then
		if isKeyJustPressed(VK_B) and not sampIsChatInputActive() and not sampIsDialogActive() then
			fixnewarzframes = true
			if boolwidget.show[0] and boolwidget.widget[0] then
				boolwidget.show[0] = false
			end
			if boolhud.show[0] and boolhud.hud[0] then
				boolhud.show[0] = false
			end
		elseif isKeyJustPressed(VK_U) and not sampIsChatInputActive() and not sampIsDialogActive() then
			if boolwidget.show[0] and boolwidget.widget[0] then
				boolwidget.show[0] = false
			end
			if boolhud.show[0] and boolhud.hud[0] then
				boolhud.show[0] = false
			end
		end
		if isKeyDown(VK_F5) then
			printStringNow("Fix ARZ_Windows: ~b~~g~ACTIVATE", 10)
			if boolwidget.show[0] and boolwidget.widget[0] then
				boolwidget.show[0] = false
			end
			if boolhud.show[0] and boolhud.hud[0] then
				boolhud.show[0] = false
			end
		elseif wasKeyReleased(VK_F5) then
			if not boolwidget.show[0] and boolwidget.widget[0] then
				boolwidget.show[0] = true
			end
			if not boolhud.show[0] and boolhud.hud[0] then
				boolhud.show[0] = true
			end
		end
		
		if fixnewarzframes == true then
			printStringNow("Fix ARZ_Windows: ~b~~g~ACTIVATE", 10)
		end
	end

	if isKeyJustPressed(VK_ESCAPE) and not sampIsChatInputActive() and not sampIsDialogActive() then
		fixnewarzframes = false
		if not boolwidget.show[0] and boolwidget.widget[0] then
			boolwidget.show[0] = true
		end
		if not boolhud.show[0] and boolhud.hud[0] then
			boolhud.show[0] = true
		end
	end

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
end


function afkcontrol_func()
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
				ShowMessage('�������� ��� ��� �������� '..ezafk.afklimit[0]..' ������.\n����� '..ezafk.afkexittime[0]..' ������ ���� ���������.', 'ezHelper', 0x30)
			end
			if tonumber(afks) == ezafk.afklimit[0] + ezafk.afkexittime[0] then
				os.execute('taskkill /IM gta_sa.exe /F')
			end
		else
			if tonumber(afks) == ezafk.afklimit[0] then
				ShowMessage('�������� ��� ��� �������� '..ezafk.afklimit[0]..' ������.', 'ezHelper', 0x30)
			end
		end
	end
end

function autoscroll_func()
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
end

function hotkeyactivate()
	if not sampIsDialogActive() and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and not sampIsScoreboardOpen() then
		if #openscript.v < 2 then
			if wasKeyPressed(openscript.v[1]) then
				rwindow.switch()
				renderWindow[0] = true
				if rwindow.state == true then
					menu_ = 1
					menu.selected[0] = 1
				end
			end
		else
			if isKeyDown(openscript.v[1]) and wasKeyPressed(openscript.v[2]) then
				rwindow.switch()
				renderWindow[0] = true
				if rwindow.state == true then
					menu_ = 1
					menu.selected[0] = 1
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

		if #skate.v < 2 then
			if wasKeyPressed(skate.v[1]) then
				sampSendChat('/skate')
			end
		else
			if isKeyDown(skate.v[1]) and wasKeyPressed(skate.v[2]) then
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
				--restoreCameraJumpcut()
				clearCharTasksImmediately(PLAYER_PED)
			end
		else
			if isKeyDown(antifreeze.v[1]) and wasKeyPressed(antifreeze.v[2]) and not isCharInAnyCar(1) and not isCharInAnyHeli(1) and not isCharInAnyPlane(1) and not isCharInAnyBoat(1) and not isCharInAnyPoliceVehicle(1) then
				freezeCharPosition(PLAYER_PED, true)
				freezeCharPosition(PLAYER_PED, false)
				setPlayerControl(PLAYER_HANDLE, true)
				--restoreCameraJumpcut()
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

		if #deltap.v < 2 then
			if wasKeyPressed(deltap.v[1]) then
				sampSendChat('/delta')
			end
		else
			if isKeyDown(deltap.v[1]) and wasKeyPressed(deltap.v[2]) then
				sampSendChat('/delta')
			end
		end
	end
end

local hudFrame = imgui.OnFrame(
	function() return boolhud.show[0] and boolhud.hud[0] end,
	function(h)
		imgui.DisableInput = false
		h.HideCursor = true
		displayHud(false)
		if spawn == true then
			if features.mac[0] then
				bass.BASS_ChannelStop(mac)
			end
			
			local textinv = sampTextdrawGetString(inv)
			if textinv == "�H�EH�AP�" or textinv == "INVENTORY" then
				oiv = true
			else
				oiv = false 
			end
			if not isPauseMenuActive() and sampGetGamestate() == 3 and oiv == false and sampGetChatDisplayMode() ~= 0 then
				local DL = imgui.GetBackgroundDrawList()

				local radius = 17
				local polygons = radius * 1.5

				local health = getCharHealth(PLAYER_PED)
				local hunger = math.floor((mainIni.hud.hun / 54.4) * 100)
				local armour = getCharArmour(PLAYER_PED)
				local money = getPlayerMoney(Player)
				local wanted = memory.getuint8(0x58DB60)
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 1.28, sizeY * 0.01 / 100), imgui.Cond.Always)
				imgui.SetNextWindowSize(imgui.ImVec2(420, 290), imgui.Cond.Always)
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.2, 0.2, 0.2, 0))
				imgui.Begin('##1', boolhud.show, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar)
				DL:AddImage(slogo, imgui.ImVec2(sizeX / 1.069, 17), imgui.ImVec2(sizeX / 1.069 + 125, 17 + 54))
				DL:AddImage(logo[boolhud.lid[0]], imgui.ImVec2(sizeX / 1.1745, 16), imgui.ImVec2(sizeX / 1.1745 + 50, 16 + 50))
				local servername = sampGetCurrentServerName()
				local xpdint = servername:match("%d")
				if xpdint ~= nil then
					imgui.PushFont(hudfont7)
					DL:AddImage(xPD, imgui.ImVec2(sizeX / 1.29, 27), imgui.ImVec2(sizeX / 1.29 + 31, 27 + 30))
					DL:AddText(imgui.ImVec2(sizeX / 1.28685, 34), 0xFFFFFFFF, "X"..xpdint)
					imgui.PopFont()
				end
				DL:AddCircleFilled(imgui.ImVec2(sizeX / 1.048, 44), radius - 4, Convert(0x788b94), polygons)
				imgui.PushFont(hudfont5)
				local size = imgui.ImVec2((radius * 5.3) - 10, (radius * 5.5) - 10)
				DL:AddText(imgui.ImVec2(sizeX / 1.05, 36.0), 0xFFFFFFFF, "7")
				DL:AddText(imgui.ImVec2(sizeX / 1.038, 36.0), 0xFFFFFFFF, "Mesa")
				DL:AddText(imgui.ImVec2(sizeX / 1.1295, 51.0), 0xFF000000, "Role Play")
				DL:AddText(imgui.ImVec2(sizeX / 1.12955, 50.0), Convert(0xadbabf), "Role Play")
				imgui.PopFont()
				imgui.PushFont(hudfont6)
				DL:AddText(imgui.ImVec2(sizeX / 1.24155, 24.0), 0xFF000000, fa.ICON_FA_USER)
				DL:AddText(imgui.ImVec2(sizeX / 1.24155, 23.0), Convert(0xc0cacd), fa.ICON_FA_USER)
				DL:AddText(imgui.ImVec2(sizeX / 1.22555, 25.0), 0xFF000000, tostring(pid))
				DL:AddText(imgui.ImVec2(sizeX / 1.22555, 24.0), 0xFFFFFFFF, tostring(pid))
				DL:AddText(imgui.ImVec2(sizeX / 1.24355, 51.0), 0xFF000000, fa.ICON_FA_USERS)
				DL:AddText(imgui.ImVec2(sizeX / 1.24355, 50.0), Convert(0xc0cacd), fa.ICON_FA_USERS)
				DL:AddText(imgui.ImVec2(sizeX / 1.22555, 52.0), 0xFF000000, tostring(servonl))
				DL:AddText(imgui.ImVec2(sizeX / 1.22555, 51.0), 0xFFFFFFFF, tostring(servonl))
				imgui.PopFont()
				imgui.PushFont(hudfont4)
				DL:AddText(imgui.ImVec2(sizeX / 1.13055, 26.0), 0xFF000000, "Arizona")
				DL:AddText(imgui.ImVec2(sizeX / 1.13055, 25.0), 0xFFFFFFFF, "Arizona")
				imgui.PopFont()
				imgui.SetCursorPos(imgui.ImVec2(60, 115)) imgui.PushFont(hudfont2) imgui.IconColoredRGB("{000000}"..fa.ICON_FA_HEART)	imgui.PopFont()
				imgui.SetCursorPos(imgui.ImVec2(60, 113)) imgui.PushFont(hudfont2) imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_HEART)	imgui.PopFont()	imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(90, 117))
				imgui.CustomAnimProgressBar("##shadow", 100, 100, 4, 340, 191, imgui.ImVec2(175,20), imgui.ImVec4(0, 0, 0, 1), imgui.ImVec4(0, 0, 0, 1))
				imgui.SetCursorPos(imgui.ImVec2(90, 115))
				imgui.CustomAnimProgressBar("health", health, boolhud.maxhp[0], 4, 340, 111, imgui.ImVec2(175,20), imgui.ImVec4(0.4, 0,0, 1), imgui.ImVec4(0.9, 0.2, 0.2, 1))
				imgui.SetCursorPos(imgui.ImVec2(50, 155)) imgui.PushFont(hudfont1) imgui.IconColoredRGB("{000000}"..fa.ICON_FA_SHIELD_ALT) imgui.PopFont()
				imgui.SetCursorPos(imgui.ImVec2(50, 153)) imgui.PushFont(hudfont1) imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_SHIELD_ALT) imgui.PopFont()
				imgui.SetCursorPos(imgui.ImVec2(80, 157))
				imgui.CustomAnimProgressBar("##shadow", 100, 100, 4, 340, 191, imgui.ImVec2(175,20), imgui.ImVec4(0, 0, 0, 1), imgui.ImVec4(0, 0, 0, 1))
				imgui.SetCursorPos(imgui.ImVec2(80, 155))
				imgui.CustomAnimProgressBar("armour", armour, 100, 4, 325, 151, imgui.ImVec2(175,20), imgui.ImVec4(0.35, 0.35,0.35, 1), imgui.ImVec4(0.6, 0.6, 0.6, 1))
				imgui.SetCursorPos(imgui.ImVec2(60, 195)) imgui.PushFont(hudfont1) imgui.IconColoredRGB("{000000}"..fa.ICON_FA_UTENSILS) imgui.PopFont()
				imgui.SetCursorPos(imgui.ImVec2(60, 193)) imgui.PushFont(hudfont1) imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_UTENSILS) imgui.PopFont()
				imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, colorhunger.alpha)
				imgui.SetCursorPos(imgui.ImVec2(60, 193)) imgui.PushFont(hudfont1) imgui.IconColoredRGB("{fa0000}"..fa.ICON_FA_UTENSILS) imgui.PopFont()
				imgui.PopStyleVar()
				imgui.SetCursorPos(imgui.ImVec2(90, 197))
				imgui.CustomAnimProgressBar("##shadow", 100, 100, 4, 340, 191, imgui.ImVec2(175,20), imgui.ImVec4(0, 0, 0, 1), imgui.ImVec4(0, 0, 0, 1))
				imgui.SetCursorPos(imgui.ImVec2(90, 195))
				imgui.CustomAnimProgressBar("satiety", hunger, 100, 4, 340, 191, imgui.ImVec2(175,20), imgui.ImVec4(0.6, 0.4, 0, 1), imgui.ImVec4(1, 0.75,0, 1))
				if isCharInWater(PLAYER_PED) or isCharInAnyCar(playerPed) and isCarInWater(storeCarCharIsInNoSave(playerPed)) then
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.01 * (100 - oxygen[0]), 0, 1 / ((100 - oxygen[0]) * 0.025), 1))
					imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0,0,0,1))
					imgui.SetCursorPos(imgui.ImVec2(272.25, 105))
					oxygen[0] = getCharOxygen()
					addons.CircularProgressBar(oxygen, 56, 6)
					imgui.PopStyleColor(2)
				end

				hp = sampGetPlayerHealth(pid)
				razn = hp - lasthp
				if actv == true then
					if razn >1 and razn ~= 0 and razn then
						if razn >=10 then
							imgui.PushFont(hudfont2)
							imgui.SetCursorPos(imgui.ImVec2(12, 113));
							imgui.IconColoredRGB("{000000}+"..razn)
							imgui.SetCursorPos(imgui.ImVec2(12, 112));
							imgui.IconColoredRGB("{FF0000}+"..razn)
							imgui.PopFont()
						else
							imgui.PushFont(hudfont2)
							imgui.SetCursorPos(imgui.ImVec2(25, 113));
							imgui.IconColoredRGB("{000000}+"..razn)
							imgui.SetCursorPos(imgui.ImVec2(25, 112));
							imgui.IconColoredRGB("{FF0000}+"..razn)
							imgui.PopFont()
						end
					end
				end

				imgui.PushFont(hudfont3)
				local text = int_separator(money)
				local len = imgui.CalcTextSize(text).x
				DL:AddText(imgui.ImVec2( sizeX / 1.1 - radius - len, 230.5), 0xFF000000, text)
				DL:AddText(imgui.ImVec2( sizeX / 1.1 - radius - len, 228.5), 0xFFFFFFFF, text)
				imgui.PopFont()
				imgui.PushFont(hudfont1)
				DL:AddCircleFilled(imgui.ImVec2(sizeX / 1.097, 242), radius, 0xFF000000, polygons)
				DL:AddCircleFilled(imgui.ImVec2(sizeX / 1.097, 240), radius, 0xFF00FF00, polygons)
				DL:AddText(imgui.ImVec2(sizeX / 1.0978, 229), 0xFF000000, fa.ICON_FA_DOLLAR_SIGN)


				local weapon_id = getCurrentCharWeapon(PLAYER_PED)
				if weapons[weapon_id] ~= nil then
					local size = imgui.ImVec2((radius * 5.3) - 10, (radius * 5.5) - 10)
					local A = 0
					if weapon_id == 0 then
						A = imgui.ImVec2(1831 + 3 - size.x / 2, 160 - size.y / 2)
					elseif weapon_id == 25 then
						A = imgui.ImVec2(1831 + 3 - size.x / 2, 164 - size.y / 2)
					elseif weapon_id == 28 then
						A = imgui.ImVec2(1830 + 3 - size.x / 2, 166 - size.y / 2)
					elseif weapon_id == 30 then
						A = imgui.ImVec2(1831 + 3 - size.x / 2, 166 - size.y / 2)
					elseif weapon_id == 31 then
						A = imgui.ImVec2(1828 + 3 - size.x / 2, 166 - size.y / 2)
					elseif weapon_id == 34 then
						A = imgui.ImVec2(1826 + 3 - size.x / 2, 165 - size.y / 2)
					else
						A = imgui.ImVec2(1830 + 3 - size.x / 2, 162 - size.y / 2)
					end
					local B = imgui.ImVec2(A.x + size.x, A.y + size.y)
					DL:AddCircle(imgui.ImVec2(sizeX / 1.048, 164.5), radius * 3.3, 0xFF000000, polygons + 10, 4)
					DL:AddImage(weapons[weapon_id], A, B)
				end
				
				local ammo = getAmmoInCharWeapon(PLAYER_PED, weapon_id)
				if ammo > 0 then
					local ammoInClip = getAmmoInClip()
					local weapons_without_clip = {25, 33, 34, 35, 36, 39}
					local no_shooting_weapons = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 40, 44, 45, 46}
					local lastammo = ammo - ammoInClip
					local text = ""
					if lastammo == 0 then
						text = string.format("%d", ammoInClip)
					else
						text = string.format("%d/%s", ammoInClip, lastammo)
					end
					for _, v in pairs(no_shooting_weapons) do
						if weapon_id == v then 
							text = "" 
						end
					end
					for _, v in pairs(weapons_without_clip) do
						if weapon_id == v then
							text = ammo
							break
						end
					end
					local len = imgui.CalcTextSize(tostring(text)).x
					DL:AddText(imgui.ImVec2(1830 - (len / 2), 200 + radius + 10), 0xFFFFFFFF, tostring(text))
				end

				imgui.PopFont()

				imgui.PushFont(wanted2font)
				if wanted == 1 then
					imgui.SetCursorPos(imgui.ImVec2(365, 94.5))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)

					imgui.SetCursorPos(imgui.ImVec2(365, 92.5))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
				elseif wanted == 2 then
					imgui.SetCursorPos(imgui.ImVec2(365, 94.5))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 94.5 + 20))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)

					imgui.SetCursorPos(imgui.ImVec2(365, 92.5))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 92.5 + 20))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
				elseif wanted == 3 then
					imgui.SetCursorPos(imgui.ImVec2(365, 94.5))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 94.5 + 20))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 94.5 + 45))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)

					imgui.SetCursorPos(imgui.ImVec2(365, 92.5))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 92.5 + 20))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 92.5 + 45))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
				elseif wanted == 4 then
					imgui.SetCursorPos(imgui.ImVec2(365, 94.5))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 94.5 + 20))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 94.5 + 45))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 94.5 + 73))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)

					imgui.SetCursorPos(imgui.ImVec2(365, 92.5))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 92.5 + 20))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 92.5 + 45))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 92.5 + 73))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
				elseif wanted == 5 then
					imgui.SetCursorPos(imgui.ImVec2(365, 94.5))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 94.5 + 20))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 94.5 + 45))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 94.5 + 73))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 94.5 + 100))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)

					imgui.SetCursorPos(imgui.ImVec2(365, 92.5))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 92.5 + 20))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 92.5 + 45))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 92.5 + 73))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 92.5 + 100))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
				elseif wanted == 6 then
					imgui.SetCursorPos(imgui.ImVec2(365, 94.5))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 94.5 + 20))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 94.5 + 45))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 94.5 + 73))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 94.5 + 100))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365, 94.5 + 120))
					imgui.IconColoredRGB("{000000}"..fa.ICON_FA_STAR)

					imgui.SetCursorPos(imgui.ImVec2(365, 92.5))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 92.5 + 20))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 92.5 + 45))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 37, 92.5 + 73))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365 + 25, 92.5 + 100))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
					imgui.SetCursorPos(imgui.ImVec2(365, 92.5 + 120))
					imgui.IconColoredRGB("{FFD700}"..fa.ICON_FA_STAR)
				end
				imgui.PopFont()
				imgui.PopStyleColor()
				imgui.End()
			end
		end
	end
)

function imgui.CustomAnimProgressBar(label, int, func, duration, tPosX, tPosY, size, bgclolor, fillcolor)
	imgui.PushFont(hudfont1)
	imgui.AnimProgressBar("##"..label, int, func, duration, size, bgclolor, fillcolor)
	local textsize = tostring(int):gsub('{.-}', '')
	local text_width = imgui.CalcTextSize(u8(textsize))
	imgui.SetCursorPos(imgui.ImVec2(tPosX / 2 - text_width.x / 2 + 4, 1.99 + tPosY))
	imgui.TextColoredRGB(tostring(int))
	imgui.PopFont()
end

local widgetFrame = imgui.OnFrame(
	function() return boolwidget.show[0] and boolwidget.widget[0] end,
	function(w)
		imgui.DisableInput = false
		if piebool.piemenu[0] then
			w.HideCursor = (piebool.piemenu[0] and not imgui.IsMouseDown(2))
		else
			w.HideCursor = true
		end

		if not isPauseMenuActive() and sampGetChatDisplayMode() ~= 0 then
			imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(boolwidget.color[0], boolwidget.color[1], boolwidget.color[2],  boolwidget.color[3]))
			imgui.SetNextWindowPos(imgui.ImVec2(boolwidget.posX, boolwidget.posY), imgui.Cond.Always)
			imgui.SetNextWindowSize(imgui.ImVec2(200, -1), imgui.Cond.Always)
			imgui.Begin('  ', boolwidget.show, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar)
			imgui.PushFont(wfont)
			imgui.CenterTextColoredRGB(nowTime)
			imgui.PopFont()
			imgui.SetCursorPosY(25)
            imgui.CenterTextColoredRGB(getStrDate(os.time()))
			if boolwidget.info[0] == true then
				imgui.Separator()
				imgui.PushFont(smallfont)
				imgui.SetCursorPos(imgui.ImVec2(12, 52.5))
				imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_USER) imgui.SameLine(26)
				imgui.TextColoredRGB(tostring(pid))
				imgui.SetCursorPos(imgui.ImVec2(56, 52.5))
				imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_WIFI) 
				local len = imgui.CalcTextSize(tostring(ping)).x
				imgui.SetCursorPos(imgui.ImVec2(82.5 - len / 2, 52.5))
				imgui.TextColoredRGB(tostring(ping))
				imgui.SetCursorPos(imgui.ImVec2(102, 52.5))
				imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_USERS) imgui.SameLine(120)
				imgui.TextColoredRGB(tostring(servonl))
				imgui.SetCursorPos(imgui.ImVec2(151, 52.5))
				imgui.IconColoredRGB("{FFFFFF}"..fa.ICON_FA_IMAGES) imgui.SameLine(168)
				imgui.TextColoredRGB(tostring(fps))
				imgui.PopFont()
				imgui.SetCursorPosY(75)
			end
			if boolwidget.online[0] == true then
				imgui.PushFont(smallfont)
				imgui.Separator()
				if sampGetGamestate() ~= 3 then
					imgui.CenterTextColoredRGB("�����������: "..get_clock(connectingTime))
				else
					imgui.CenterTextColoredRGB("������: "..get_clock(sesOnline[0]))
					imgui.CenterTextColoredRGB("�� ����: "..get_clock(onlineIni.onDay.online))
				end
				imgui.PopFont()
			end
			
			if piebool.piemenu[0] then
				if imgui.IsMouseClicked(2) then imgui.OpenPopup('PieMenu') end
					if pie.BeginPiePopup('PieMenu', 2) then
					imgui.PushFont(piefont)
					if pie.BeginPieMenu(fa.ICON_FA_CAR..u8'���������') then
						if piebool.domkrat[0] then
							if pie.PieMenuItem(fa.ICON_FA_SNOWPLOW..u8'�������') then
								sampSendChat("/domkrat")
							end
						end
						if piebool.chargecar[0] then
							if pie.PieMenuItem(fa.ICON_FA_BOLT..u8'��������') then
								sampSendChat("/chargecar")
							end
						end
						if piebool.fillcar[0] then
							if pie.PieMenuItem(fa.ICON_FA_GAS_PUMP..u8'���������') then
								sampSendChat("/fillcar")
							end
						end
						if piebool.repcar[0] then
							if pie.PieMenuItem(fa.ICON_FA_TOOLS..u8'��������') then
								sampSendChat("/repcar")
							end
						end
						pie.EndPieMenu()
					end
					if pie.BeginPieMenu(fa.ICON_FA_TOOLBOX..u8'��������') then
						if piebool.healmed[0] then
							if pie.PieMenuItem(fa.ICON_FA_FIRST_AID..u8'�������') then
								sampSendChat("/usemed")
							end
						end
						if piebool.narko[0] then
							if pie.PieMenuItem(fa.ICON_FA_CANNABIS..u8'���������') then
								sampSendChat("/usedrugs 3")
							end
						end
						if piebool.armor[0] then
							if pie.PieMenuItem(fa.ICON_FA_SHIELD_ALT..u8'����������') then
								sampSendChat("/armour")
							end
						end
						if piebool.beer[0] then
							if pie.PieMenuItem(fa.ICON_FA_WINE_BOTTLE..u8'����') then
								sampSendChat("/beer")
							end
						end
						if piebool.mask[0] then
							if pie.PieMenuItem(fa.ICON_FA_MASK..u8'�����') then
								sampSendChat("/mask")
							end
						end
						pie.EndPieMenu()
					end
					if pie.BeginPieMenu(fa.ICON_FA_STAR..u8'����������') then
						if piebool.rcveh[0] then
							if pie.PieMenuItem(fa.ICON_FA_GAMEPAD..u8'��') then
								sampSendChat("/rcveh")
							end
						end
						if piebool.surf[0] then
							if pie.PieMenuItem(fa.ICON_FA_SNOWBOARDING..u8'Ѹ��') then
								sampSendChat("/surf")
							end
						end
						if piebool.skate[0] then
							if pie.PieMenuItem(fa.ICON_FA_SNOWBOARDING..u8'�����') then
								sampSendChat("/skate")
							end
						end
						if piebool.shar[0] then
							if pie.PieMenuItem(fa.ICON_FA_GLOBE..u8'���') then
								sampSendChat("/balloon")
							end
						end
						if piebool.deltap[0] then
							if pie.PieMenuItem(fa.ICON_FA_PLANE..u8'����������') then
								sampSendChat("/delta")
							end
						end
						pie.EndPieMenu()
					end
					pie.EndPiePopup()
					imgui.PopFont()
				end
			end
			imgui.PopStyleColor()
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
		imgui.CenterTextColoredRGB('���������� ezHelper!')
		imgui.Separator()
		imgui.PopFont()
		imgui.PushFont(smallfont)
		imgui.PopFont()
		imgui.BeginChild("##UpdateChild",imgui.ImVec2(260, 95), true)
		imgui.PushFont(smallfont)
		imgui.CenterTextColoredRGB('��� ������?')
		imgui.WrappedTextRGB(utext)
		imgui.PopFont()
		imgui.EndChild()
		imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
		imgui.SetCursorPos(imgui.ImVec2(((imgui.GetWindowWidth() + imgui.GetStyle().ItemSpacing.x) / 6 + 5), 130))
		imgui.PushFont(mainfont)
		if imgui.AnimatedButton(u8"��", imgui.ImVec2(80, 35)) then updatewindow[0] = false update():download() end
		imgui.SetCursorPos(imgui.ImVec2(((imgui.GetWindowWidth() + imgui.GetStyle().ItemSpacing.x) / 6) + 88 + 5, 130))
		if imgui.AnimatedButton(u8"���", imgui.ImVec2(80, 35)) then updatewindow[0] = false end
		imgui.PopFont()
		imgui.PopStyleVar()
		
		imgui.End()
	end
end
)

local TimeWeatherFrame = imgui.OnFrame(
	function() return TWWindow.alpha > 0.00 end, -- ��������� ����� ������ �������, ��� ����� ������� ���� ������ � ��� ������, ���� ��� ������������ ������ ����
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
			imgui.CenterTextColoredRGB("{1E90FF}����� � ������:")
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
			if imgui.Checkbox(u8"�������� �����", TimeWeather.realtime) then
				mainIni.TimeWeather.realtime = TimeWeather.realtime[0]
				inicfg.save(mainIni, directIni)
			end
			imgui.PopFont()
			imgui.ezHint('�������������� ����� �� ���������� � ������� ��������.',
			hpfont, mainfont, 14.000000, 92.500000)
		imgui.EndChild()
		imgui.CenterTextColoredRGB('������� ESC, ����� ��������� �����')
		imgui.CenterTextColoredRGB('������� SHIFT, ����� ������� �������')
		imgui.End()
		imgui.PopStyleVar(1)
	end
)

local newFrame = imgui.OnFrame(
	function() return rwindow.alpha > 0.00 end, -- ��������� ����� ������ �������, ��� ����� ������� ���� ������ � ��� ������, ���� ��� ������������ ������ ����
    function(player)
        player.HideCursor = not rwindow.state -- // ������ ����� ��������� �� �������, ����� ���� �������� ��������
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(580, 380), imgui.Cond.FirstUseEver)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, rwindow.alpha)
		imgui.BeginWin11Menu("ezHelper v"..thisScript().version, renderWindow, nil, menu.selected, menu.opened, 50, 50, imgui.WindowFlags.NoResize)
		imgui.DisableInput = false
		imgui.PushFont(mainfont)
		if menu.selected[0] == 1 then menu_ = 1 end
		if menu.selected[0] == 2 then menu_ = 2 end
		if menu.selected[0] == 3 then imgui.OpenPopup('BinderOrHotkey') popupwindow.switch() menu.selected[0] = 0 end
		if menu.selected[0] == 4 then menu_ = 3 end
		imgui.PopFont()
				if renderWindow[0] == false then
					rwindow.switch()
					renderWindow[0] = true
				end
				imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, popupwindow.alpha)
				if imgui.BeginPopupModal('BinderOrHotkey', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
					imgui.BeginChild("##E1ditBinder", imgui.ImVec2(250, 90), false)
					imgui.PushFont(smallfont)
					imgui.CenterTextColoredRGB("��� �� ������ �������?")
					imgui.PopFont()
					imgui.PushFont(mainfont)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
					imgui.SetCursorPos(imgui.ImVec2(3.000000,22.000000));
					if imgui.AnimatedButton(fa.ICON_FA_CLIPBOARD..u8'������', imgui.ImVec2(120,50), 0.15) then
						menu_ = 'binder'
						popupwindow.switch()
						checkpopupwindow = true
						menu.selected[0] = "Binder"
					end
					imgui.SameLine()
					imgui.SetCursorPos(imgui.ImVec2(128.000000,22.000000));
					if imgui.AnimatedButton(fa.ICON_FA_KEYBOARD..u8'������', imgui.ImVec2(120,50), 0.15) then
						menu_ = 'hotkey'
						popupwindow.switch()
						checkpopupwindow = true
						menu.selected[0] = "Hotkey"
					end
					imgui.PopStyleVar()
					imgui.PopFont()
					if checkpopupwindow and popupwindow.alpha <= 0.09 then imgui.CloseCurrentPopup() checkpopupwindow = false end
					
					imgui.EndChild()
					imgui.EndPopup()
				end
				imgui.PopStyleVar()
			if menu_ == 1 then
				imgui.BeginChild("menu",imgui.ImVec2(529.5, 330.5), false)
				imgui.PushFont(mainfont)
				imgui.SetCursorPosY(10)
				imgui.CenterTextColoredRGB("{FFA500}�����������")
				imgui.PopFont()
				imgui.PushFont(smallfont)
				
				imgui.WrappedTextRGB(u8'  {FFFAFA}���� ������������������� ������ ������ ������� ��� � �������� ��������   ���� �� ������� Arizon� RP.')
				imgui.Text(" ")
				imgui.TextColoredRGB("	{1E90FF}������� � ��� ������������:\n" ..
				"{ADD8E6}		- �������:\n" ..
				"{FFFAFA}			- ������ ���������� ������ ��� �����.\n" ..
				"{FFFAFA}			- ����� ���\n" ..
				"{FFFAFA}			- ����� ��������� ��������� ��������.\n" ..
				"{ADD8E6}		- ˸���� ���������� �����������:\n" ..
				"{FFFAFA}			- ����� ��������� � ��������� ��������� �� ������ (L)\n" ..
				"{FFFAFA}			- ����� ����������� ����� �� ���������� �� ������ (K)\n" ..
				"{FFFAFA}			- ����� ��������� ��������������� (O) � ������������ (J)\n" ..
				"{FFFAFA}          	���������\n" ..
				"{FF0000}		- �����:\n" ..
				"{FFFAFA}			-�����, ���������, ������ �����������{FF4040} � ������� ����\n" ..
				"{FFFAFA}			-�� ������ �� ���������� � {FF4040}��������{FFFAFA} / {FF4040}c��������{FFFAFA} � �����\n")
				

				imgui.PopFont()
				
				imgui.EndChild()
			end

			if menu_ == 2 then
				imgui.BeginChild("settings",imgui.ImVec2(529.5, 330.5), false)

				imgui.SetCursorPos(imgui.ImVec2(10.000000,5.000000));
				imgui.BeginChild("poleznoe",imgui.ImVec2(290, 135), true)

					imgui.SetCursorPosY(1)
					imgui.PushFont(mainfont)
					imgui.CenterTextColoredRGB('{1E90FF}��������')
					imgui.PopFont()

					imgui.SetCursorPos(imgui.ImVec2(30.000000,20.000000));
					if imgui.Checkbox(u8"HideFamTag", hidefam) then
						mainIni.fpsup.hidefam = hidefam[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('������� ��� ������� �������� ����',
					hpfont, mainfont, 14.000000, 21.000000)
				
					imgui.SetCursorPos(imgui.ImVec2(30.000000,45.000000));
					if imgui.Checkbox(u8"AutoPIN", features.autopin) then
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
						if imgui.BeginPopup('autopin', false, imgui.WindowFlags.AlwaysAutoResize) then
							imgui.PushItemWidth(80)
							if imgui.InputText("##pincode", features.pincode, sizeof(features.pincode)) then
							mainIni.features.pincode = ffi.string(features.pincode) 
							inicfg.save(mainIni, directIni)
							end
							imgui.PopItemWidth()
							imgui.EndPopup()
						end
					end
					imgui.ezHint('������������� ������ PIN-��� � �����.',
					hpfont, mainfont, 14.000000, 46.000000)

					imgui.SetCursorPos(imgui.ImVec2(30.000000,70.000000));
					if imgui.Checkbox(u8"CorrectDMG", features.correctdmg) then
						mainIni.features.correctdmg = features.correctdmg[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('{FF0000}[NEW]{FFFFFF} ������������ ����� � ��������� �� ���� �:�:�.',
					hpfont, mainfont, 14.000000, 71.000000)

					imgui.SetCursorPos(imgui.ImVec2(30.000000,95.000000));
					if imgui.Checkbox(u8"Widget", boolwidget.widget) then
						widgetcfg.widget.active = boolwidget.widget[0]
						ecfg.save(wgname, widgetcfg)
					end
					
					imgui.ezHint('{FF0000}[NEW]{FFFFFF} ������ ��� ������� ��.\n'..
					'{808080}������, PieMenu',
					hpfont, mainfont, 14.000000, 96.000000)

					if boolwidget.widget[0] then
						imgui.PushFont(smallfont)
						imgui.SetCursorPos(imgui.ImVec2(106.00000,98.000000));
						imgui.Text(fa.ICON_FA_COG)
						imgui.PopFont()
						if imgui.IsItemClicked() then
							imgui.OpenPopup('Widgets')
						end
						if imgui.BeginPopup('Widgets', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
							if imgui.Checkbox(u8"����������", boolwidget.info) then
								widgetcfg.widget.info = boolwidget.info[0]
								ecfg.save(wgname, widgetcfg)
							end
							if imgui.Checkbox(u8"������", boolwidget.online) then
								widgetcfg.widget.online = boolwidget.online[0]
								ecfg.save(wgname, widgetcfg)
							end
							imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
							if imgui.Button(u8'��������������', imgui.ImVec2(120,20)) then
								lua_thread.create(function()
									checkCursor = true
									sampSetCursorMode(4)
									ezMessage('������� {0087FF}SPACE{FFFFFF} ���-�� ��������� �������')
									while checkCursor do
										local cX, cY = getCursorPos()
										boolwidget.posX, boolwidget.posY = cX, cY
										if isKeyDown(32) then
											sampSetCursorMode(0)
											widgetcfg.widget.wpos.posX, widgetcfg.widget.wpos.posY = boolwidget.posX, boolwidget.posY
											checkCursor = false
											if ecfg.save(wgname, widgetcfg) then ezMessage('������� ���������!') end
										end
										wait(0)
									end
								end)
							end
							if imgui.Button(u8'���� �������', imgui.ImVec2(120,20)) then
								imgui.OpenPopup("ColorEdit")
							end
							imgui.PopStyleVar()
							if imgui.BeginPopup('ColorEdit', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
								if imgui.ColorEdit4("##", boolwidget.color) then
									widgetcfg.widget.color = {boolwidget.color[0], boolwidget.color[1], boolwidget.color[2], boolwidget.color[3]}
									ecfg.save(wgname, widgetcfg)
								end

								imgui.EndPopup()
							end
							imgui.Separator()
							if imgui.Checkbox(u8"PieMenu", piebool.piemenu) then
								widgetcfg.piemenu_active = piebool.piemenu[0]
								ecfg.save(wgname, widgetcfg)
							end
							if piebool.piemenu[0] then
								imgui.PushFont(smallfont)
								imgui.SetCursorPos(imgui.ImVec2(88.00000,110.000000));
								imgui.Text(fa.ICON_FA_COG)
								imgui.PopFont()
								if imgui.IsItemClicked() then
									imgui.OpenPopup('PieSettings')
								end
								if imgui.BeginPopupModal('PieSettings', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
									imgui.CenterTextColoredRGB("{1E90FF}������")
									if imgui.Checkbox(u8"���������", piebool.fillcar) then
										widgetcfg.piemenu_car_fill = piebool.fillcar[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"��������", piebool.chargecar) then
										widgetcfg.piemenu_car_charge = piebool.chargecar[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"��������", piebool.repcar) then
										widgetcfg.piemenu_car_repcar = piebool.repcar[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"�������", piebool.domkrat) then
										widgetcfg.piemenu_car_domkrat = piebool.domkrat[0]
										ecfg.save(wgname, widgetcfg)
									end
									imgui.Separator()
									imgui.CenterTextColoredRGB("{1E90FF}��������")
									if imgui.Checkbox(u8"�������", piebool.healmed) then
										widgetcfg.piemenu_item_healmed = piebool.healmed[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"���������", piebool.narko) then
										widgetcfg.piemenu_item_narko = piebool.narko[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"����������", piebool.armor) then
										widgetcfg.piemenu_item_armor = piebool.armor[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"����", piebool.beer) then
										widgetcfg.piemenu_item_beer = piebool.beer[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"�����", piebool.mask) then
										widgetcfg.piemenu_item_mask = piebool.mask[0]
										ecfg.save(wgname, widgetcfg)
									end
									imgui.Separator()
									imgui.CenterTextColoredRGB("{1E90FF}����������")
									if imgui.Checkbox(u8"��", piebool.rcveh) then
										widgetcfg.piemenu_acs_rcveh = piebool.rcveh[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"�����", piebool.skate) then
										widgetcfg.piemenu_acs_skate = piebool.skate[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"Ѹ��", piebool.surf) then
										widgetcfg.piemenu_acs_surf = piebool.surf[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"���", piebool.shar) then
										widgetcfg.piemenu_acs_shar = piebool.shar[0]
										ecfg.save(wgname, widgetcfg)
									end
									if imgui.Checkbox(u8"����������", piebool.deltap) then
										widgetcfg.piemenu_acs_deltap = piebool.deltap[0]
										ecfg.save(wgname, widgetcfg)
									end
									imgui.Separator()
									imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
									if imgui.Button(u8'�������', imgui.ImVec2(-1, 25)) then
										imgui.CloseCurrentPopup()
									end
									imgui.PopStyleVar()
									imgui.EndPopup()
								end
							end
							imgui.EndPopup()
						end
					end

					imgui.SetCursorPos(imgui.ImVec2(166.000000,20.000000));
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
					imgui.ezHint('����� ������ ������ �� �������\n'..
					'���� ����������� ������������� ������� � ��.',
					hpfont, mainfont, 150.000000, 21.000000)

					imgui.SetCursorPos(imgui.ImVec2(166.000000,45.000000));
					if imgui.Checkbox(u8"AFK Control", ezafk.afkcontrol) then
						mainIni.afkcontrol.afkcontrol = ezafk.afkcontrol[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint(('��������� �������������� ���.\n{808080}�������, ���� �� ������ �� ������� ����������.'),
					hpfont, mainfont, 150.000000, 45.000000)

					if ezafk.afkcontrol[0] == true then
						imgui.PushFont(smallfont)
						imgui.SetCursorPos(imgui.ImVec2(268.00000,46.600000));
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
							imgui.ezHint(('����� ���, ����� �������� ��� ������ ��������������.'),
							hpfont, mainfont, 12.000000, 5.000000)
							imgui.SetCursorPos(imgui.ImVec2(27.00000,8.000000));
							imgui.Text(u8"����� ���:")
							imgui.SetCursorPos(imgui.ImVec2(110.00000,5.000000));
							imgui.PushItemWidth(50)
							if imgui.InputInt(u8'���##afklimit', ezafk.afklimit, 0, 1) then
								mainIni.afkcontrol.afklimit = ezafk.afklimit[0]
								inicfg.save(mainIni, directIni)
							end
							imgui.PopItemWidth()
							imgui.SetCursorPos(imgui.ImVec2(153.00000,8.000000));
							
							if ezafk.afkexit[0] == true then
								imgui.SetCursorPos(imgui.ImVec2(5.00000,55.000000));
								if imgui.Checkbox(u8"����� ��� ����������", ezafk.afkexit) then
									mainIni.afkcontrol.afkexit = ezafk.afkexit[0]
									inicfg.save(mainIni, directIni)
								end
							else
								imgui.SetCursorPos(imgui.ImVec2(5.00000,30.000000));
								if imgui.Checkbox(u8"����� ��� ����������", ezafk.afkexit) then
									mainIni.afkcontrol.afkexit = ezafk.afkexit[0]
									inicfg.save(mainIni, directIni)
								end
							end
							if ezafk.afkexit[0] == true then
								imgui.ezHint(('������� �� ����, ����� '..ezafk.afkexittime[0]..' ������.'),
								hpfont, mainfont, 12.000000, 30.000000)
								imgui.SetCursorPos(imgui.ImVec2(27.00000,33.000000));
								imgui.Text(u8"����� �����:")
								imgui.SetCursorPos(imgui.ImVec2(110.00000,30.000000));
								imgui.PushItemWidth(50)
								if imgui.InputInt(u8'���##afkexittime', ezafk.afkexittime, 0, 1) then
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
					imgui.ezHint(('�������� ������, ����� ��� �������� ������.\n{808080}����� ��������� ������ ������� {DCDCDC}BACKSPACE.'),
					hpfont, mainfont, 150.000000, 71.000000)

					imgui.SetCursorPos(imgui.ImVec2(166.000000,95.000000));
					if imgui.Checkbox(u8"ADrunk", boolhud.adrunk) then
						mainIni.hud.adrunk = boolhud.adrunk[0]
						inicfg.save(mainIni, directIni)
					end
					
					imgui.ezHint('{ffffff}������� ������ ������ (�� ������� �� ���������).',
					hpfont, mainfont, 150.000000, 96.000000)

				imgui.EndChild()

				imgui.SetCursorPos(imgui.ImVec2(310.000000,5.000000));
				imgui.BeginChild("otherfuncs",imgui.ImVec2(210, 135), true)

					imgui.PushFont(mainfont)
					imgui.SetCursorPosY(1)
					imgui.CenterTextColoredRGB('{1E90FF}������')
					imgui.PopFont()

					imgui.SetCursorPos(imgui.ImVec2(30.000000,20.000000));
					if imgui.Checkbox(u8"AutoID", features.autoid) then
						mainIni.features.autoid = features.autoid[0]
						inicfg.save(mainIni, directIni)
					end
					
					imgui.ezHint('{FF0000}������� ��� �����\n'..
					'������������� ��������� ID ������, ���� �� ��������� � ������� (/pursuit)',
					hpfont, mainfont, 14.000000, 21.000000)

					imgui.SetCursorPos(imgui.ImVec2(30.000000,45.000000));
					if imgui.Checkbox(u8"AScroll", carfuncs.autoscroll) then
						mainIni.carfuncs.autoscroll = carfuncs.autoscroll[0]
						inicfg.save(mainIni, directIni)
					end
					if carfuncs.autoscroll[0] == true then
						imgui.PushFont(smallfont)
						imgui.SetCursorPos(imgui.ImVec2(102.00000,48.0));
						imgui.Text(fa.ICON_FA_COG)
						imgui.PopFont()
						if imgui.IsItemClicked() then
							imgui.OpenPopup('##autoscroll')
						end
						if imgui.BeginPopup('##autoscroll', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
							imgui.PushItemWidth(120)
							imgui.Combo("##weapon", combobox.current_weapon, combobox.weapons, #WeaponsList)
							imgui.PopItemWidth()
							imgui.EndPopup()
						end
					end
					imgui.ezHint('������������� ����������� ������, ����� �������� � ������.\n'..
					'{808080}��������, ���� �� ������ ����������� ������.',
					hpfont, mainfont, 14.000000, 46.000000)

					imgui.SetCursorPos(imgui.ImVec2(30.000000,70.000000));
					if imgui.Checkbox(u8"RGPS", boolfixes.fixgps) then
						mainIni.fixes.fixgps = boolfixes.fixgps[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('{FF0000}������� ��� �����\n'..
					'������� ������� GPS:ON, ��� ��������� ����������� /time �� ����� /pursuit',
					hpfont, mainfont, 14.000000, 71.000000)

					imgui.SetCursorPos(imgui.ImVec2(30.000000,95.000000));
					if imgui.Checkbox(u8"RHUD", boolhud.hud) then
						mainIni.hud.hud = boolhud.hud[0]
						inicfg.save(mainIni, directIni)
					end
					if boolhud.hud[0] == true then
						imgui.PushFont(smallfont)
						imgui.SetCursorPos(imgui.ImVec2(95.00000,98.0));
						imgui.Text(fa.ICON_FA_COG)
						imgui.PopFont()
						if imgui.IsItemClicked() then
							imgui.OpenPopup('hudsettings')
						end
						if imgui.BeginPopup('hudsettings', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
							imgui.CenterTextColoredRGB("���� ������������ ��:")
							if imgui.RadioButtonIntPtr(u8'Common', boolhud.lid,1) then
								mainIni.hud.lid = boolhud.lid[0]
								inicfg.save(mainIni, directIni)
							end
							imgui.SameLine()
							if imgui.RadioButtonIntPtr(u8'White', boolhud.lid,2) then
								mainIni.hud.lid = boolhud.lid[0]
								inicfg.save(mainIni, directIni)
							end
							imgui.SameLine()
							if imgui.RadioButtonIntPtr(u8'Halloween', boolhud.lid,3) then
								mainIni.hud.lid = boolhud.lid[0]
								inicfg.save(mainIni, directIni)
						 	end
							 imgui.SameLine()
							 if imgui.RadioButtonIntPtr(u8'HiTech', boolhud.lid,4) then
								 mainIni.hud.lid = boolhud.lid[0]
								 inicfg.save(mainIni, directIni)
							  end
							imgui.Separator()
							imgui.CenterTextColoredRGB("���� ������������ ��:")
							if imgui.RadioButtonIntPtr(u8'100 HP', boolhud.maxhp,100) then
								mainIni.hud.maxhp = boolhud.maxhp[0]
								inicfg.save(mainIni, directIni)
							end
							imgui.SameLine()
							if imgui.RadioButtonIntPtr(u8'130 HP', boolhud.maxhp,130) then
								mainIni.hud.maxhp = boolhud.maxhp[0]
								inicfg.save(mainIni, directIni)
							end
							imgui.SameLine()
							if imgui.RadioButtonIntPtr(u8'160 HP', boolhud.maxhp,160) then
								mainIni.hud.maxhp = boolhud.maxhp[0]
								inicfg.save(mainIni, directIni)
						 	end
							imgui.EndPopup()
						end
					end
					imgui.ezHint('{FF0000}[NEW]{FFFFFF} RHUD - Reborn HUD. ������������ ������ ���� �������.\n'..
					'��� ����������� ����������� ����, � /settings ���������� ������� [��� ���� - �������].',
					hpfont, mainfont, 14.000000, 96.000000)

					imgui.SetCursorPos(imgui.ImVec2(136.000000,20.000000));
					if imgui.Checkbox(u8"FOV", features.fisheye) then
						mainIni.features.fisheye = features.fisheye[0]
						inicfg.save(mainIni, directIni)
					end
					if features.fisheye[0] == true then
						imgui.PushFont(smallfont)
						imgui.SetCursorPos(imgui.ImVec2(192.00000,23.0));
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
					imgui.ezHint('����� �������� ���� ������ ������.\n'..
					'{808080}��� �� ������� ��������� ������ � ������ ��� ������� ��������.',
					hpfont, mainfont, 120.000000, 21.000000)

					imgui.SetCursorPos(imgui.ImVec2(136.000000,45.000000));
					if imgui.Checkbox(u8"MAC", features.mac) then
						mainIni.features.mac = features.mac[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('{FF0000}[NEW]{FFFFFF} MAC - Music After Connected.\n'..
					'�������� ������ ������, ����� ����������� � �������.',
					hpfont, mainfont, 120.000000, 46.000000)

					imgui.SetCursorPos(imgui.ImVec2(136.000000,70.000000));
					if imgui.Checkbox(u8"CSK", features.kolokol) then
						mainIni.features.kolokol = features.kolokol[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('{FF0000}[NEW]{FFFFFF} CSK - Custom Sound Kolokol.\n'..
					'�������� ����������� ���� ������������ �� ���������.',
					hpfont, mainfont, 120.000000, 71.000000)
					
					if features.kolokol[0] == true then
						imgui.PushFont(smallfont)
						imgui.SetCursorPos(imgui.ImVec2(192.00000,73.0));
						imgui.Text(fa.ICON_FA_COG)
						imgui.PopFont()
						if imgui.IsItemClicked() then
							imgui.OpenPopup('kolvolume')
						end
						if imgui.BeginPopup('kolvolume', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
							imgui.CenterTextColoredRGB("���������:")
							imgui.PushItemWidth(148.5)
							if imgui.SliderInt('##slider.kolvolume', slider.kolvolume, 1, 10) then
								inicfg.load(mainIni, directIni)
								mainIni.features.kolvolume = slider.kolvolume[0]
								inicfg.save(mainIni, directIni)
							end 
							imgui.PopItemWidth()
							imgui.EndPopup()
						end
					end

				imgui.EndChild()

				imgui.SetCursorPos(imgui.ImVec2(10.000000,150.000000));
				imgui.BeginChild("carfuncs",imgui.ImVec2(230, 140), true)

					imgui.PushFont(mainfont)
					imgui.CenterTextColoredRGB('{1E90FF}CarFuncs')
					imgui.PopFont()

					imgui.SetCursorPos(imgui.ImVec2(30.000000,23.000000));
					if imgui.Checkbox(u8"AutoTT", carfuncs.autotwinturbo) then
						mainIni.carfuncs.autotwinturbo = carfuncs.autotwinturbo[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('{ffffff}������������� �������� ����� ���� {ff0000}SPORT{ffffff}, ����� �� � ������.',
					hpfont, mainfont, 14.000000, 24.000000)

					imgui.SetCursorPos(imgui.ImVec2(30.000000,48.000000));
					if imgui.Checkbox(u8"AutoFill", carfuncs.autofill) then
						mainIni.carfuncs.autofill = carfuncs.autofill[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('{FFFFFF}������������� �������� ������� � ���������� ��������.\n��� �� ������������� �������� �����������.',
					hpfont, mainfont, 14.000000, 51.000000)

					imgui.SetCursorPos(imgui.ImVec2(30.000000,73.000000));
					if imgui.Checkbox(u8"VintColl", boolfixes.fixvint) then
						mainIni.fixes.fixvint = boolfixes.fixvint[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('���� ����� �������� �� �������������� ��-�� ������, �� ��� �������\n'..
					'������� ��� ���������� �����, �� ��������� �������.',
					hpfont, mainfont, 14.000000, 74.000000)

					imgui.SetCursorPos(imgui.ImVec2(140.000000,23.000000));
					if imgui.Checkbox(u8"CarLight", carfuncs.carlight) then
						mainIni.carfuncs.carlight = carfuncs.carlight[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('{FFFFFF}���������� ��������� ��� �� {FFD700}CTRL\n'..
					'{808080}����� �������� ���������� ����, ������� {DCDCDC}CTRL + ALT.',
					hpfont, mainfont, 126.000000, 24.000000)

					imgui.SetCursorPos(imgui.ImVec2(140.000000,48.000000));
					if imgui.Checkbox(u8"OldTrunk", carfuncs.trunk) then
						mainIni.carfuncs.trunk = carfuncs.trunk[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('{FFFFFF}���������� ������ �������������� � ���������� ����� {FFD700}ALT.\n'..
					'{808080}����� ������� �������� Barracks, ������� {FFD700}��� + ALT',
					hpfont, mainfont, 126.000000, 49.000000)

					imgui.SetCursorPos(imgui.ImVec2(140.000000,73.000000));
					if imgui.Checkbox(u8"AntiFine", carfuncs.antifine) then
						mainIni.carfuncs.antifine = carfuncs.antifine[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('{FFFFFF}�� ��������� �����, ����� �� ������� �� ������ � ����.\n'..
					'{808080}����� ����������, ���� �� ������� �� ������.',
					hpfont, mainfont, 126.000000, 74.000000)

					imgui.SetCursorPos(imgui.ImVec2(30.000000,98.000000));
					if imgui.Checkbox(u8"Strobes", carfuncs.strobe) then
						mainIni.carfuncs.strobe = carfuncs.strobe[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.ezHint('��������� �������� ����������� �� ����� ����������.\n'..
					'{808080}��������� ������ �� ��������� ����� � �������.',
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
					imgui.ezHint('ABL - AntiBreakLight, ������ ���� ���������� �����������.\n'..
					'������� ������, ����� � ���� ����� ����.',
					hpfont, mainfont, 126.000000, 99.000000)

				imgui.EndChild()

				imgui.SetCursorPos(imgui.ImVec2(250.000000,150.000000));
				imgui.BeginChild("fixes",imgui.ImVec2(170, 140), true)
					imgui.PushFont(mainfont)
					imgui.CenterTextColoredRGB('{FF0000}�����')
					imgui.PopFont()
					imgui.SetCursorPos(imgui.ImVec2(30.000000,20.000000));
					if imgui.Checkbox(u8"Fix Doors", boolfixes.fixdver) then
						mainIni.fixes.fixdver = boolfixes.fixdver[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.SetCursorPos(imgui.ImVec2(30.000000,45.000000));
					if imgui.Checkbox(u8"Fix Spawns", boolfixes.fixspawn) then
						mainIni.fixes.fixspawn = boolfixes.fixspawn[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.SetCursorPos(imgui.ImVec2(30.000000,70.000000));
					if imgui.Checkbox(u8"Fix WARZ", boolfixes.fixarzdialogs) then
						mainIni.fixes.fixarzdialogs = boolfixes.fixarzdialogs[0]
						inicfg.save(mainIni, directIni)
					end
					imgui.SetCursorPos(imgui.ImVec2(30.000000,95.000000));
					if imgui.Checkbox(u8"Launcher", boolfixes.launcher) then
						mainIni.fixes.launcher = boolfixes.launcher[0]
						inicfg.save(mainIni, directIni)
					end
					

					imgui.ezHint('{FFFFFF}��������� ��������� ����� �����������.\n'..
					'{808080}���������: {DCDCDC}H',
					hpfont, mainfont, 14.000000, 21.000000)

					imgui.ezHint('{FFFFFF}�� ������ �� ���������� � {FF4040}��������{FFFAFA} / {FF4040}c��������{FFFFFF} � �����\n'..
					'{808080}��� ����������, ����� ���������.',
					hpfont, mainfont, 14.000000, 46.000000)

					imgui.ezHint('{FFFFFF}���������� ��� � ������ ������ �� �������� ������� ��.\n'..
					'{808080}���� ���������� �� ���� ArizonaPASS/Donate, F5.',
					hpfont, mainfont, 14.000000, 71.000000)

					imgui.ezHint('{FF0000}[NEW]{FFFFFF} ���������� ��� � ������ �������� �� �������.\n'..
					'{808080}���������: {DCDCDC}��������������',
					hpfont, mainfont, 14.000000, 96.000000)
					
				imgui.EndChild()			
			end

			if menu_ == 'binder' then
				imgui.BeginChild("binder",imgui.ImVec2(529.5, 330.5), false) 
				imgui.PushFont(smallfont)
				if #cfg.binds > 0 then
					for index, item in ipairs(cfg.binds) do
						imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
						if imgui.AnimatedButton(u8(item.name)..'##'..index, imgui.ImVec2(460, 30)) then
							EditBinder = true
							getpos = index
							bhotkey.v = {unpack(item.hotkey)} --���������� ������
							local wrappedtext = item.text:gsub('~', '\n')
							imgui.StrCopy(binder.btext, u8(wrappedtext))
							imgui.StrCopy(binder.bname, u8(item.name))
							binder.delay[0] = item.delay
							imgui.OpenPopup(u8'������')
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
						imgui.SetCursorPosY(index * 35	)				
					end
					imgui.SetCursorPosX((imgui.GetWindowWidth() - 25) / 2)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
					imgui.Separator()
					if imgui.AnimatedButton(fa.ICON_FA_PLUS_CIRCLE..u8'������� ����', imgui.ImVec2(-1,30)) then
						imgui.StrCopy(binder.btext, '')
						imgui.StrCopy(binder.bname, '')
						binder.delay[0] = 1
						bhotkey.v = {}

						imgui.OpenPopup(u8'������')
					end
					imgui.PopStyleVar()
					imgui.PopFont()
				else
					imgui.CenterTextColoredRGB('����� ���� ���� ����� ������.')
					imgui.CenterTextColoredRGB('�� ����� �������!')
					imgui.SetCursorPosX((imgui.GetWindowWidth() - 25) / 2)
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
					imgui.Separator()
					if imgui.AnimatedButton(fa.ICON_FA_PLUS_CIRCLE..u8'������� ����', imgui.ImVec2(-1,30)) then
						imgui.StrCopy(binder.btext, '')
						imgui.StrCopy(binder.bname, '')
						binder.delay[0] = 1
						bhotkey.v = {}
						
						imgui.OpenPopup(u8'������')
					end
					imgui.PopStyleVar()
					imgui.PopFont()
				end
			end
			if imgui.BeginPopupModal(u8'������', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
				inputblock = true
				imgui.BeginChild("##EditBinder", imgui.ImVec2(600, 337), false)
				imgui.PushItemWidth(95)
				imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.6, 0.5))
				imgui.InputFloat(u8"��������", binder.delay, 0.5, 1.0, "%.1f", imgui.CharsNoBlank); imgui.SameLine()
				if binder.delay[0] <= 0.5 then binder.delay[0] = 1.0 end
				if binder.delay[0] >= 15.5 then binder.delay[0] = 15.0 end
				imgui.PopStyleVar()
				imgui.PopItemWidth()
				imgui.SetCursorPosX(460)
				imgui.Text(u8"������"); imgui.SameLine()
				imgui.SetCursorPosX(505)
				imgui.HotKey('##name', bhotkey, 90)
				imgui.InputTextMultiline("##EditMultiline", binder.btext, ffi.sizeof(binder.btext), imgui.ImVec2(-1, 250))
				imgui.SetCursorPosY(287)
				imgui.Text(u8'�������� �����:') imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(110.000000,285.000000));
				imgui.PushItemWidth(200)
				imgui.InputText("##binder_name", binder.bname, ffi.sizeof(binder.bname))
				imgui.PopItemWidth()
				imgui.SameLine()
				if #ffi.string(binder.btext) > 0 and #ffi.string(binder.bname) > 0 then
					imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
					if imgui.Button(u8'���������##bind1', imgui.ImVec2(140,20)) then
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
					imgui.DisableButton(u8'���������##bind2', imgui.ImVec2(140,20))
					imgui.PopStyleVar(1)
				end
				imgui.SameLine()
				imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
				if imgui.Button(u8'�������', imgui.ImVec2(140,20)) then
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
			if menu_ == 'hotkey' then
				hotkeylist()
			end

			if menu_ == 3 then
				imgui.BeginChild("info",imgui.ImVec2(529.5, 330.5), false)
				imgui.PushFont(mainfont)
				imgui.SetCursorPosY(10)
				imgui.CenterTextColoredRGB(" {FFA500}����������")
				imgui.PopFont()
				imgui.PushFont(smallfont)
				imgui.WrappedTextRGB(u8"  � ���� ������� �� ������ ���������� ������ ������ � ������ �� � �������. ���   �� � ���� ������� ����� ����� ������ �� ������������ �������.")
				imgui.PopFont()
				imgui.PushFont(brandfont)

				imgui.SetCursorPos(imgui.ImVec2(10,200));
				imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
				if imgui.Button(u8"CMD", imgui.ImVec2(100, 40)) then imgui.OpenPopup(u8'���������� �� ��������') list = 1 popupwindow.switch() end
				imgui.PopStyleVar(1)

				imgui.SetCursorPos(imgui.ImVec2(410,200));
				imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign , imgui.ImVec2(0.5, 0.5))
				if imgui.Button(u8"LogVersion", imgui.ImVec2(100, 40)) then imgui.OpenPopup(u8'����') popupwindow.switch() end
				imgui.PopStyleVar(1)
				
			

				imgui.SetCursorPos(imgui.ImVec2(10.000000,265.500000));
				imgui.Separator()
				imgui.BeginChild("ideveloper",imgui.ImVec2(410, 50), false)
				imgui.Text(u8"	�����������: CH4PPLE")

				imgui.SetCursorPos(imgui.ImVec2(25.000000,26.000000));
				imgui.Link('https://vk.com/chapple', fa_icon.ICON_FA_VK, false, false) imgui.SameLine(60)
				--imgui.SetCursorPos(imgui.ImVec2(32.000000,25.000000));
				--[[imgui.TextQuestion("                                       ", u8"�������, ����� �����������")
				imgui.SetCursorPos(imgui.ImVec2(32.000000,25.000000));
				imgui.Text(primer_text[1]) -- ����� ����������
				if imgui.IsItemClicked() then
					imgui.LogToClipboard()
					imgui.LogText(primer_text[1]) -- ����������� ����������
					ezMessage("������� �����������!")
					imgui.LogFinish()
				end]]

				--imgui.SetCursorPos(imgui.ImVec2(12.500000,48.000000));
				imgui.Link('https://t.me/CH4PPLE', fa_icon.ICON_FA_TELEGRAM_PLANE, false, false)
				--imgui.SetCursorPos(imgui.ImVec2(32.000000,47.000000));
				--[[imgui.TextQuestion("                                     ", u8"�������, ����� �����������")
				imgui.SetCursorPos(imgui.ImVec2(32.000000,47.000000));
				imgui.Text(primer_text[2]) -- ����� ����������
				if imgui.IsItemClicked() then
					imgui.LogToClipboard()
					imgui.LogText(primer_text[2]) -- ����������� ����������
					ezMessage("������� �����������!")
					imgui.LogFinish()
				end]]
				imgui.PopFont()
				imgui.EndChild()

			end
			imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, popupwindow.alpha)
			if imgui.BeginPopupModal(u8'���������� �� ��������', false,  imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize) then
				if list == 1 then
					imgui.BeginChild("fastcmd",imgui.ImVec2(625, 220), true)
					imgui.PushFont(mainfont)
					imgui.TextColoredRGB("{FFA500}������� �������.")
					imgui.PopFont()
					imgui.PushFont(smallfont)
					imgui.TextColoredRGB("{E6E6FA}��� ���������� ����������� �������. ��������, ���� ��� ������ ���-�� ����� �������.\n" .. 
					'{E6E6FA}	��������: {7FFFD4}����� ���, ������, ���������� /members\n' ..
					'{00BFFF}		�������:\n' ..
					'{E6E6FA}			/fh {FFD700}[ID]{E6E6FA} - ����� ����\n' ..
					'{E6E6FA}			/fbz {FFD700}[ID]{E6E6FA} - ����� �������\n' ..
					'{00BFFF}		���������������:\n' ..
					'{E6E6FA}			/jb - ���������� ���� ������������ {808080}(/jobprogress)\n' ..
					'{E6E6FA}			/cjb {FFD700}[ID]{E6E6FA} - �������� ������������ ���������� {808080}(/checkjobprogress) {FF0000}9+ rank{E6E6FA}\n' ..
					'{E6E6FA}			/mb - ��������� ������ ����������� {808080}(/members)')
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
					imgui.BeginChild("newcmd",imgui.ImVec2(625, 220), true)
					imgui.PushFont(mainfont)
					imgui.TextColoredRGB("{FFA500}����� �������.")
					imgui.PopFont()
					imgui.PushFont(smallfont)
					imgui.TextColoredRGB("{E6E6FA}��� ����� �������. ��� �� ������ � ���� ������������.\n" .. 
					'		{00BFFF}����� / ������:\n' ..
					'			{E6E6FA}/st {FFD700}[0-23]{E6E6FA} - �������� �����\n' ..
					'			{E6E6FA}/sw {FFD700}[0-45]{E6E6FA} - �������� ������\n' ..
					'		{00BFFF}������:\n' ..
					'			{E6E6FA}/delltd - �������� ���� ����������� �� ������\n' ..
					'			{E6E6FA}/infoveh - ����������, ������� �� ������\n' ..
					'			{E6E6FA}/�all {FFD700}[ID]{E6E6FA} - ��������� ������ �� id')
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
			if imgui.BeginPopupModal(u8'����', false,  imgui.WindowFlags.NoResize) then
				imgui.SetWindowSizeVec2(imgui.ImVec2(650, 400))
				imgui.BeginChild("logscript",imgui.ImVec2(650, 316), false)
				imgui.PushFont(smallfont)
				imgui.WrappedTextRGB(u8(logversionText1))
				imgui.SameLine(); imgui.Link('https://t.me/DoubleTapInside','Double Tap Inside.', false, true)
				imgui.WrappedTextRGB(u8(logversionText2))
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
        imgui.EndWin11Menu()
		imgui.PopStyleVar()
    end
)

function hotkeylist()
	imgui.BeginChild("hotkey",imgui.ImVec2(529.5, 330.5), false)
	imgui.PushFont(smallfont)
		imgui.SetCursorPos(imgui.ImVec2(45.000000,5.000000));
			imgui.BeginChild("other",imgui.ImVec2(220, 55), true)
			imgui.CenterTextColoredRGB('{1E90FF}��������')

				imgui.SetCursorPos(imgui.ImVec2(5,25 + 3));
				imgui.TextColoredRGB('�������� �������')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8'�������� �������').x + 10, 25))
				if imgui.HotKey(u8'##open', openscript, 90) then
					hcfg.openscript = {unpack(openscript.v)}
					ecfg.save(hkname, hcfg)
				end
	
			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(285.000000,5.000000));
			imgui.BeginChild("heal",imgui.ImVec2(195, 130), true)
			imgui.CenterTextColoredRGB('{1E90FF}��������')

				imgui.SetCursorPos(imgui.ImVec2(10,25 + 3));
				imgui.TextColoredRGB('�������')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('����������')).x + 15, 25))
				if imgui.HotKey(u8'##aidkit', aidkit, 90) then
					hcfg.aidkit = {unpack(aidkit.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,50 + 3));
				imgui.TextColoredRGB('���������')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('����������')).x + 15, 50))
				if imgui.HotKey(u8'##narko', narko, 90) then
					hcfg.narko = {unpack(narko.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,75 + 3));
				imgui.TextColoredRGB('����������')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('����������')).x + 15, 75))
				if imgui.HotKey(u8'##armor', armor, 90) then
					hcfg.armor = {unpack(armor.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,100 + 3));
				imgui.TextColoredRGB('����')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('����������')).x + 15, 100))
				if imgui.HotKey(u8'##beer', beer, 90) then
					hcfg.beer = {unpack(beer.v)}
					ecfg.save(hkname, hcfg)
				end

			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(45.000000,80.000000));	
			imgui.BeginChild("acs",imgui.ImVec2(220, 130), true)
			imgui.CenterTextColoredRGB('{1E90FF}����������')

				imgui.SetCursorPos(imgui.ImVec2(5,25 + 3));
				imgui.TextColoredRGB('��������� ��')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('�������� �������')).x + 10, 25))
				if imgui.HotKey(u8'##rcveh', rcveh, 90) then
					hcfg.rcveh = {unpack(rcveh.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(5,50 + 3));
				imgui.TextColoredRGB('����� ��� ����')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('�������� �������')).x + 10, 50))
				if imgui.HotKey(u8'##surf', surf, 90) then
					hcfg.surf = {unpack(surf.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(5,75 + 3));
				imgui.TextColoredRGB('�����')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('�������� �������')).x + 10, 75))
				if imgui.HotKey(u8'##skate', skate, 90) then
					hcfg.skate = {unpack(skate.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(5,100 + 3));
				imgui.TextColoredRGB('���')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('�������� �������')).x + 10, 100))
				if imgui.HotKey(u8'##shar', shar, 90) then
					hcfg.shar = {unpack(shar.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(5,125 + 3));
				imgui.TextColoredRGB('����������')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('�������� �������')).x + 10, 125))
				if imgui.HotKey(u8'##deltap', deltap, 90) then
					hcfg.deltap = {unpack(deltap.v)}
					ecfg.save(hkname, hcfg)
				end
			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(285.000000,155.000000));
			imgui.BeginChild("car",imgui.ImVec2(195, 130), true)
			imgui.CenterTextColoredRGB('{1E90FF}����������')

				imgui.SetCursorPos(imgui.ImVec2(10,25 + 3));
				imgui.TextColoredRGB('���������')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('����������')).x + 15, 25))
				if imgui.HotKey(u8'##fllcar', fllcar, 90) then
					hcfg.fllcar = {unpack(fllcar.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,50 + 3));
				imgui.TextColoredRGB('��������')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('����������')).x + 15, 50))
				if imgui.HotKey(u8'##repcar', repcar, 90) then
					hcfg.repcar = {unpack(repcar.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,75 + 3));
				imgui.TextColoredRGB('�������')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('����������')).x + 15, 75))
				if imgui.HotKey(u8'##domkrat', domkrat, 90) then
					hcfg.domkrat = {unpack(domkrat.v)}
					ecfg.save(hkname, hcfg)
				end

				imgui.SetCursorPos(imgui.ImVec2(10,100 + 3));
				imgui.TextColoredRGB('������')
				imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('����������')).x + 15, 100))
				if imgui.HotKey(u8'##hkstrobe', hkstrobe, 90) then
					hcfg.hkstrobe = {unpack(hkstrobe.v)}
					ecfg.save(hkname, hcfg)
				end

			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(45.000000,230.000000));	
			imgui.BeginChild("CheatFuncs	",imgui.ImVec2(220, 55), true)
			imgui.CenterTextColoredRGB('{FF0000}���-�������')

					imgui.SetCursorPos(imgui.ImVec2(5,25 + 3));
					imgui.TextColoredRGB('����-����')
					imgui.SetCursorPos(imgui.ImVec2(imgui.CalcTextSize(u8('�������� �������')).x + 10, 25))
					if imgui.HotKey(u8'##antfrz', antifreeze, 90) then
						hcfg.antifreeze = {unpack(antifreeze.v)}
						ecfg.save(hkname, hcfg)
					end

		imgui.EndChild()
		
	imgui.PopFont()
	imgui.EndChild()
			
end

function imgui.Link(link,name,myfunc,addline)
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
		if addline then
        	imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32Vec4(imgui.ImVec4(0, 0.5, 1, 1)))
		end
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
		if inicfg.save(onlineIni, directOIni) then sampfuncsLog('��� ������ ��������!') end
	end
end

function playVolume(arg, state)
	if doesFileExist(arg) then
		local audio = loadAudioStream(arg)
		setAudioStreamState(audio, state)
		setAudioStreamVolume(audio, slider.kolvolume[0])
	end
end
function sampev.onServerMessage(color, text)
	--if text:find(".+") then print(text) end
	if features.autoid[0] == true then
		if text:find('�� ������� ������ ������ �� ������� .+') then
			namePur = text:match('�� ������� ������ ������ �� ������� (%w+_?%w+)')
			print(namePur)
		end
		
		if text:find('%[������%] %{......%}����� ���� �� ������! ��������� ��������������') then
			print("1111")
			local pursuitoff = false
			local pursuit = lua_thread.create(function()
				wait(800)
				sampSendChat("/id " .. namePur)
				pursuitoff = true
			end)
			if pursuitoff then
				pursuit:terminate()
				pursuitoff = false
			end
			
		end
	end
	if callproda == true then
		if text:find("(%w+_%w+)%[(%d+)%]:    %{33CCFF%}(%d+)") then
			callnick, number = text:match("(%w+_%w+)%[%d+%]:    %{33CCFF%}(%d+)")
			ezMessage("������ ������: {87CEFA}"..callnick)
			callproda = false
			return false
		end
	end
	if text:find('�������� ����� ���� ����� ������ ���� � ��� ����������� ����������� ����������� ��� �� ����������� ����!') then
		ezMessage('�� ��� ���������� ��� TwinTurbo.')
		return false
	end
	if text:find('%[����������%] %{FFFFFF%}����������� ������ ����� ������� ��� ������� � ��� ���%-%��') then
		fillcar = true
	end
	if carfuncs.autofill[0] == true then
		if text:find('��� ��������� ���������.+') then
			fillcar = false
		elseif text:find('��� ��������� ��� �������.+') then
			electofill = false
		end
	end
end
callarg = 0

function setTime(hours)
    memory.write(0xB70153, hours, 1, false)
end

function setWeather(weather)
	forceWeatherNow(weather)
end

function sampev.onShowTextDraw(id, data)
	if boolhud.hud[0] then
		if data.text:find(".+ HP") or data.text:find(".+ H") then
			return false
		end
		if data.text:find('You are hungry!') or data.text:find('You are very hungry!') then
			hungeranim()
			return false
		end
	end

	if boolfixes.fixgps[0] == true then
		if data.text:find("GPS: ON") then
			return false
		end
	end

	if carfuncs.autotwinturbo[0] then
		if isCharInAnyCar(playerPed) then
			if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
				ezMessage("AutoTT: TwinTurbo �������.")
				sampSendChat('/style')
			end
		end
	end

	--[[if data.text:find('Played .+') then
		data.text = "~n~"..data.text
		return {id, data}
	end]]
	if data.text == "~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~CAR~g~ UNLOCK~n~/lock" or data.text == "~w~~n~~n~~n~~n~~n~~n~~n~~n~CAR~g~ UNLOCK~n~/lock" then
		data.text = "~w~~n~~n~~n~~n~~n~~n~~n~~n~CAR~g~ UNLOCK"
		return {id, data}
	elseif data.text == "~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~CAR~r~ LOCK~n~/lock" or data.text == "~w~~n~~n~~n~~n~~n~~n~~n~~n~CAR~r~ LOCK~n~/lock" then
		data.text = "~w~~n~~n~~n~~n~~n~~n~~n~~n~CAR~r~ LOCK"
		return {id, data}
	end
	print(data.text)
	if data.text == "�H�EH�AP�" or data.text == "INVENTORY" then
		inv = id
	end
	if data.text == "A" or data.text == "rizona" or data.text == "mesa" or data.text:find("~y~PAYDAY~n~Launcher.+") or data.text:find("Armour") then
		return false
	end

	if data.position.x == 620 and data.position.y == 230 then
		data.text = "~n~"..data.text
		return {id, data}
	end

	if features.correctdmg[0] then
		if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec.') then
			dmgtime = data.text:match('~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed (%d+) Sec.')
			data.text = string.format(conv("~n~~n~~n~~n~~n~~n~~n~~n~~y~��������:~n~~w~%s"), get_clock(dmgtime))
			return {id, data}
		end
	end

	if carfuncs.autofill[0] == true then
		--print("ID: "..id)
		--print("DATA: "..data.text)	
		print("POS_X: "..data.position.x)
		print("POS_Y: "..data.position.y)
		if fillcar == true then
			atfll = lua_thread.create_suspended(function()
				if data.text:find("~w~This type of fuel ~r~ is not suitable~w~~n~ for your vehicles!") then
					sampSendClickTextdraw(arrow_id)
					prodaoilfill = false
				else
					prodaoilfill = true
				end
			end)
			atfll:run()
		end

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

	if data.position.x == 547.5 and data.position.y == 58 and data.boxColor == -16777216 then
		return false
	end
	if data.position.x == 549.5 and data.position.y == 60 and data.boxColor == -1436898180 then
		hun = data.lineWidth + -549.5
		mainIni.hud.hun = hun
		inicfg.save(mainIni, directIni)

		return false
	end
	if data.position.x == 549.5 and data.position.y == 60 and data.boxColor == 1622575210 then
		return false
	end
end

function hungeranim()
	local potok = lua_thread.create(function()
		colorhunger.switch()
		while true do
			wait(0)
			if colorhunger.alpha == 1 then
				colorhunger.switch()
			end
		end
		potok:terminate()

	end)
	
end

--[[function sampev.onDisplayGameText(style, time, text)
	if boolhud.hud[0] then
		if text:find('You are hungry!') or text:find('You are very hungry!') then
			hungeranim()
			return false
		end
	end

	if carfuncs.autotwinturbo[0] then
		if isCharInAnyCar(playerPed) then
			if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
				ezMessage("AutoTT: TwinTurbo �������.")
				sampSendChat('/style')
			end
		end
	end
	if text:find('.+') then print(text) end
	if features.correctdmg[0] then
		if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec.') then
			dmgtime = text:match('~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed (%d+) Sec.')
			return {style, time, string.format(conv("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~��������:~n~~w~%s"), get_clock(dmgtime))}
		end
	end
		
	if boolfixes.fixgps[0] == true then
		if text:find("GPS: ON") then
			return false
		end
	end

	if text:find(".+ HP") or text:find(".+ H") then
		return false
	end

	if text:find("~y~PAYDAY~n~Launcher.+") then
		return false
	end
end]]

function sampev.onPlaySound(id, pos)
	if id == 17802 and features.kolokol[0] then
		return false
	end
end

function sampev.onSendGiveDamage(playerId, damage, weapon, bodypart)
	if features.kolokol[0] then
		local audio = loadAudioStream('moonloader/resource/ezHelper/bang.mp3')
		setAudioStreamState(audio, 1)
		setAudioStreamVolume(audio, slider.kolvolume[0])
	end
end

function sampev.onSetPlayerHealth(health)
	lasthp = sampGetPlayerHealth(pid)
	lua_thread.create(function()
		while true do wait(0)
			actv = true
			wait(2000)
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
    local module = getModuleHandle("SAMPFUNCS.asi")
    if module ~= 0 and memory.compare(module + 0xBABD, memory.strptr('\x8B\x43\x04\x8B\x5C\x24\x20\x8B\x48\x34\x83\xE1'), 12) then
        memory.setuint16(module + 0x83349, 0x01ac, true)
        memory.setuint16(module + 0x8343c, 0x01b0, true)
        memory.setuint16(module + 0x866dd, 0x00f4, true)
        memory.setuint16(module + 0x866e9, 0x0306, true)
        memory.setuint8(module + 0x8e754, 0x40, true)
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

function getAmmoInClip()
	local pointer = getCharPointer(PLAYER_PED)
	local weapon = getCurrentCharWeapon(PLAYER_PED)
	local slot = getWeapontypeSlot(weapon)
	local offset = pointer + 0x5A0
	local address = offset + slot * 0x1C
	return memory.getuint32(address + 0x8)
end

function sampev.onShowDialog(id, style, title, button1, button2, text)

    if text:find("{929290}�� ������ ����������� ���� PIN%-��� � ��������.") then
		sampSendDialogResponse(id, 1, nil, mainIni.features.pincode)
	end
	if text:find('{ffffff}������������� (.+) ������� ���%:') then
		playVolume(panic, 1)
	end
	if id == 15330 then
		countdialog = countdialog + 1
		if countdialog >= 3 then 
			sampSendDialogResponse(15300, 0, 0, nil)
		end
    end

	if id == 222 then
    	fixnewarzframes = true
		if boolwidget.show[0] and boolwidget.widget[0] then
			boolwidget.show[0] = false
		end
		if boolhud.show[0] and boolhud.hud[0] then
			boolhud.show[0] = false
		end
	end
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

function onReceivePacket(id)
    if id == 34 then
		if features.mac[0] then
			--print(id)
			bass.BASS_ChannelSetAttribute(mac, BASS_ATTRIB_VOL, 0.1) -- ���������
			bass.BASS_ChannelPlay(mac, false)
		end
    end
end


function time()
	startTime = os.time()
    connectingTime = 0
    while true do
        wait(1000)
        nowTime = os.date("%H:%M:%S", os.time())
		fps = ("%.0f"):format(memory.getfloat(0xB7CB50, true))
		ping =  sampGetPlayerPing(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		if sampGetGamestate() == 3 then
	        sesOnline[0] = sesOnline[0] + 1
			onlineIni.onDay.online = onlineIni.onDay.online + 1
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
    return os.date((onDay and math.floor(time / 86400)..'� ' or '')..'%H:%M:%S', time + timezone_offset)
end

function getStrDate(unixTime)
    local tMonths = {'������', '�������', '�����', '������', '���', '����', '����', '�������', '��������', '�������', '������', '�������'}
	local tWeekdays = {[0] = '�����������', [1] = '�����������', [2] = '�������', [3] = '�����', [4] = '�������', [5] = '�������', [6] = '�������'}
    local day = tonumber(os.date('%d', unixTime))
    local month = tMonths[tonumber(os.date('%m', unixTime))]
    local weekday = tWeekdays[tonumber(os.date('%w', unixTime))]
    return string.format('%s, %s %s', weekday, day, month)
end

function isCarLightsOn(car)
	return readMemory(getCarPointer(car) + 0x428, 1) > 62
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
						statusstr = '{00FF00}�������'
					elseif DoorsStats == 2 then
						statusstr = '{FF0000}�������'
					end
					local a1, a2, a3, b1, b2, b3 = getModelDimensions(model)
					local aX, aY, aZ = getOffsetFromCarInWorldCoords(v, a1, a2, a3)
					local bX, bY, bZ = getOffsetFromCarInWorldCoords(v, b1, a2, b3)
					local cX, cY, cZ = (aX + bX) / 2, (aY + bY) / 2, (aZ + bZ) / 2
					local disttrunk = getDistanceBetweenCoords3d(pX, pY, pZ, cX, cY, cZ)
					if (min_dist == nil or disttrunk < min_dist) and disttrunk <= math.abs(a1) then
						target, min_dist = v, disttrunk
					end
					if iveh then
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
	if not doesDirectoryExist("moonloader/resource/ezHelper/WeaponsIcon") then createDirectory('moonloader/resource/ezHelper/WeaponsIcon') end
	if not doesDirectoryExist("moonloader/resource/ezHelper/logo") then createDirectory('moonloader/resource/ezHelper/logo') end
	if not doesDirectoryExist("moonloader/resource/ezHelper/fonts") then createDirectory('moonloader/resource/ezHelper/fonts') end
	if not doesDirectoryExist("moonloader/resource/fonts") then createDirectory('moonloader/resource/fonts') end
	if not doesFileExist('moonloader\\resource\\ezHelper\\panic.mp3') then
		ezMessage("{FF0000}������!{FFFFFF} � ��� ����������� ������ ����� ��� ������ �������, ������� ����������.")
		ezMessage("�������� ������..")
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/panic.mp3?raw=true", getWorkingDirectory().."/resource/ezHelper/panic.mp3", function(id, status, p1, p2)
		end)
	end
	if not doesFileExist('moonloader\\resource\\ezHelper\\oldarzmusic.mp3') then
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/oldarzmusic.mp3?raw=true", getWorkingDirectory().."/resource/ezHelper/oldarzmusic.mp3", function(id, status, p1, p2) end)
	end
	if not doesFileExist('moonloader\\resource\\ezHelper\\bang.mp3') then
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/bang.mp3?raw=true", getWorkingDirectory().."/resource/ezHelper/bang.mp3", function(id, status, p1, p2) end)
	end
	if not doesFileExist('moonloader\\resource\\ezHelper\\notification.mp3') then
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/notification.mp3?raw=true", getWorkingDirectory().."/resource/ezHelper/notification.mp3", function(id, status, p1, p2)
			if status == 58 then
				ezMessage('�������� ������ {00FF00}������� ���������.')
			end
		end)
	end
	if not doesFileExist('moonloader\\resource\\ezHelper\\fonts\\GothamPro-Medium.ttf') then
		ezMessage("�������� �������..")
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/fonts/arialbd.ttf?raw=true", getWorkingDirectory().."/resource/fonts/arialbd.ttf", function(id, status, p1, p2)	end)
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/fonts/fa-brands-400.ttf?raw=true", getWorkingDirectory().."/resource/fonts/fa-brands-400.ttf", function(id, status, p1, p2)	end)
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/fonts/fa-solid-900.ttf?raw=true", getWorkingDirectory().."/resource/fonts/fa-solid-900.ttf", function(id, status, p1, p2) end)
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/fonts/fa-regular-400.ttf?raw=true", getWorkingDirectory().."/resource/fonts/fa-regular-400.ttf", function(id, status, p1, p2) end)
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/fonts/GothamPro-Medium.ttf?raw=true", getWorkingDirectory().."/resource/ezHelper/fonts/GothamPro-Medium.ttf", function(id, status, p1, p2)	end)
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/fonts/GothamProNarrow-Bold.ttf?raw=true", getWorkingDirectory().."/resource/ezHelper/fonts/GothamProNarrow-Bold.ttf", function(id, status, p1, p2)	end)
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/fonts/GothamProNarrow-Medium.ttf?raw=true", getWorkingDirectory().."/resource/ezHelper/fonts/GothamProNarrow-Medium.ttf", function(id, status, p1, p2)	end)
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/fonts/PFDinDisplayPro-Regular.ttf?raw=true", getWorkingDirectory().."/resource/ezHelper/fonts/PFDinDisplayPro-Regular.ttf", function(id, status, p1, p2) end)
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/fonts/UniNeueHeavy.ttf?raw=true", getWorkingDirectory().."/resource/ezHelper/fonts/UniNeueHeavy.ttf", function(id, status, p1, p2)	end)
		downloadUrlToFile("https://github.com/chapple01/ezHelper/blob/main/resource/ezHelper/fonts/unineueheavy-italic.ttf?raw=true", getWorkingDirectory().."/resource/ezHelper/fonts/unineueheavy-italic.ttf", function(id, status, p1, p2)
			if status == 58 then
				ezMessage('�������� ������� {00FF00}������� ���������.')
			end
		end)

	end
	if not doesFileExist('moonloader\\resource\\ezHelper\\arz07.png') or not doesFileExist('moonloader\\resource\\ezHelper\\XPayDay.png') then
		ezMessage("�������� �������� ����...")
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/arz07.png", getWorkingDirectory().."/resource/ezHelper/arz07.png", function(id, status, p1, p2) end)
		
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/logo/common1.png", getWorkingDirectory().."/resource/ezHelper/logo/common1.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/logo/common2.png", getWorkingDirectory().."/resource/ezHelper/logo/common2.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/logo/Halloween.png", getWorkingDirectory().."/resource/ezHelper/logo/Halloween.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/logo/HiTech.png", getWorkingDirectory().."/resource/ezHelper/logo/HiTech.png", function(id, status, p1, p2) end)
		
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/XPayDay.png", getWorkingDirectory().."/resource/ezHelper/XPayDay.png", function(id, status, p1, p2) end)
		
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/0.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/0.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/1.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/1.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/2.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/2.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/3.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/3.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/4.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/4.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/5.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/5.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/6.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/6.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/7.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/7.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/8.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/8.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/9.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/9.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/10.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/10.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/11.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/11.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/12.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/12.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/13.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/13.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/14.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/14.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/15.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/15.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/16.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/16.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/17.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/17.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/18.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/18.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/22.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/22.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/23.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/23.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/24.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/24.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/25.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/25.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/26.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/26.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/27.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/27.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/28.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/28.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/29.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/29.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/30.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/30.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/31.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/31.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/32.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/32.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/33.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/33.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/34.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/34.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/35.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/35.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/36.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/36.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/37.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/37.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/38.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/38.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/39.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/39.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/40.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/40.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/41.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/41.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/42.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/42.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/43.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/43.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/44.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/44.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/45.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/45.png", function(id, status, p1, p2) end)
		downloadUrlToFile("https://raw.githubusercontent.com/chapple01/ezHelper/main/resource/ezHelper/WeaponsIcon/46.png", getWorkingDirectory().."/resource/ezHelper/WeaponsIcon/46.png", function(id, status, p1, p2)
			if status == 58 then
				ezMessage("�������� �������� {00FF00}������� ���������. {FFFFFF}��������������...")
				thisScript():reload()
			end
		end)
	end
end

function int_separator(int)
	int = tostring(int)
	if int ~= nil and string.len(int) > 3 then
		local b, e = ("%d"):format(int):gsub("^%-", "")
		local c = b:reverse():gsub("%d%d%d", "%1.")
		local d = c:reverse():gsub("^%.", "")
		return int:gsub(int, (e == 1 and "-" or "") .. d)
	end
	return int
end

function conv(text) --������� ����� � GameText
    local convtbl = {[230]=155,[231]=159,[247]=164,[234]=107,[250]=144,[251]=168,[254]=171,[253]=170,[255]=172,[224]=97,[240]=112,[241]=99,[226]=162,[228]=154,[225]=151,[227]=153,[248]=165,[243]=121,[184]=101,[235]=158,[238]=111,[245]=120,[233]=157,[242]=166,[239]=163,[244]=63,[237]=174,[229]=101,[246]=36,[236]=175,[232]=156,[249]=161,[252]=169,[215]=141,[202]=75,[204]=77,[220]=146,[221]=147,[222]=148,[192]=65,[193]=128,[209]=67,[194]=139,[195]=130,[197]=69,[206]=79,[213]=88,[168]=69,[223]=149,[207]=140,[203]=135,[201]=133,[199]=136,[196]=131,[208]=80,[200]=133,[198]=132,[210]=143,[211]=89,[216]=142,[212]=129,[214]=137,[205]=72,[217]=138,[218]=167,[219]=145}
    local result = {}
    for i = 1, #text do
        local c = text:byte(i)
        result[i] = string.char(convtbl[c] or c)
    end
    return table.concat(result)
end


function ezMessage(arg)
	sampAddChatMessage("{fff000}[ezHelper]: {ffffff}"..arg, 0xfff000)
end

function Convert(color)
    r = bit.rshift(color, 16)
    g = bit.band(bit.rshift(color, 8), 0xFF)
    b = bit.band(color, 0xFF)
    fullcolor = bit.bor(bit.bor(bit.lshift(b, 16), bit.lshift(g, 8)), r)
    return bit.bor(fullcolor, 0xFF000000)
end

function U32ToImVec4(color)
    r = bit.rshift(color, 16)
    g = bit.band(bit.rshift(color, 8), 0xFF)
    b = bit.band(color, 0xFF)
    return imgui.ImVec4(r / 255, g / 255, b / 255, 1.0)
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
	style.WindowMinSize = imgui.ImVec2(20, 20)

	colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]         = ImVec4(0.77, 0.77, 0.77, 1.00)
	colors[clr.WindowBg]             = ImVec4(0.05, 0.05, 0.05, 2.00)
	colors[clr.ChildBg]              = ImVec4(0.18, 0.18, 0.18, 0.75)
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
	colors[clr.Button]               = ImVec4(0.28, 0.28, 0.28, 1.00)
	colors[clr.ButtonHovered]        = ImVec4(0.54, 0.54, 0.54, 0.65)
	colors[clr.ButtonActive]         = ImVec4(0.50, 0.50, 0.50, 0.65)
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

--[[
    title - ���������
    var - ���������� ����
    stateButton - ����� �� ������ "��������/����������" ������� (��������� nil ���� ������ �� �����)
    tabs - ������ �������
    selected - ��������� �������
    isOpened - ������ (��������/����������)
    sizeClosed - ������ ������ ���� ��������
    sizeOpened - ������ ������ ���� ����������
    windowFlags - ����� ���� (��� �� ��� � � imgui.Begin())
]]
function imgui.BeginWin11Menu(title, var, stateButton, selected, isOpened, sizeClosed, sizeOpened, windowFlags)
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
    imgui.Begin(title, var, imgui.WindowFlags.NoTitleBar + (windowFlags or 0))

    local size = imgui.GetWindowSize()
    local pos = imgui.GetWindowPos()
    local dl = imgui.GetWindowDrawList()

    local tabSize = sizeClosed - 10

    imgui.SetCursorPos(imgui.ImVec2(size.x - tabSize + 5, 5))
	imgui.PushFont(mainfont)
	imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(1, 0.85))
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.1, 0.1, 0.1, 0.5))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.1, 0.1, 0.1, 0.5))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.2, 0.2, 0.2, 0.5))
    if imgui.Button(fa.ICON_FA_TIMES..'##'..title..'::closebutton', imgui.ImVec2(tabSize - 10, tabSize - 10)) then if var then var[0] = false end end
	imgui.PopStyleVar()
	imgui.PopStyleColor(3)
	imgui.PopFont()

    --==[ MAIN BG ]==--
   --[[ imgui.SetCursorPos(imgui.ImVec2(sizeClosed, sizeClosed))
    local p = imgui.GetCursorScreenPos()
    dl:AddRectFilled(p, imgui.ImVec2(p.x + size.x - sizeClosed, p.y + size.y - sizeClosed), imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.ChildBg]), imgui.GetStyle().WindowRounding, 1 + 8)
   ]]
    --==[ TITLEBAR ]==--
    imgui.SetCursorPos(imgui.ImVec2(0, 0))
    local p = imgui.GetCursorScreenPos()
    dl:AddRectFilled(p, imgui.ImVec2(p.x + (isOpened[0] and sizeOpened or sizeClosed), p.y + size.y), imgui.GetColorU32Vec4(imgui.ImVec4(0.1, 0.1, 0.1, 1)), imgui.GetStyle().WindowRounding, 1 + 4)
    imgui.SetCursorPos(imgui.ImVec2(tabSize + 22, sizeClosed / 2 - imgui.CalcTextSize(title).y / 2))
	imgui.PushFont(mainfont)
	if selected[0] == 1 then
    imgui.TextColoredRGB("{FFFFFF}"..title.." | {1E90FF}�������")
	elseif selected[0] == 2 then
	imgui.TextColoredRGB("{FFFFFF}"..title.." | {1E90FF}�������")
	elseif selected[0] == 0 then
	imgui.TextColoredRGB("{FFFFFF}"..title.." | {1E90FF}�����")
	elseif selected[0] == "Binder" then
	imgui.TextColoredRGB("{FFFFFF}"..title.." | {1E90FF}���� ��������� ������")
	elseif selected[0] == "Hotkey" then
	imgui.TextColoredRGB("{FFFFFF}"..title.." | {1E90FF}���� �������")
	elseif selected[0] == 4 then
	imgui.TextColoredRGB("{FFFFFF}"..title.." | {1E90FF}� �������")
	end
	imgui.PopFont()
		

    --==[ TABS BUTTONS ]==--
    imgui.SetCursorPosY(5)
    if stateButton then
        imgui.SetCursorPosX(5)
        if imgui.Button(stateButton, imgui.ImVec2(tabSize, tabSize)) then isOpened[0] = not isOpened[0] end
    else
        imgui.SetCursorPosY(5 + tabSize + 5)
    end
        imgui.SetCursorPos(imgui.ImVec2(5, 5))
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.2, 0.2, 0.5))
        imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.9, 0.6))
		imgui.PushFont(mainfont)
        if imgui.Button(fa.ICON_FA_HOME, imgui.ImVec2(isOpened[0] and sizeOpened - 10 or tabSize, tabSize)) then selected[0] = 1 end
		if imgui.IsItemHovered() then
			if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
			local alpha = (os.clock() - go_hint) * 5 -- �������� ���������
			if os.clock() >= go_hint then
				imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
				imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
				imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(700)
				imgui.TextColoredRGB("�������")
				if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
				imgui.PopStyleColor()
				imgui.PopStyleVar(2)
			end
		end
		imgui.PopStyleColor()
		imgui.SetCursorPos(imgui.ImVec2(5, 50))
		imgui.PushStyleColor(imgui.Col.Button, selected[0] == 2 and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImVec4(0.2, 0.2, 0.2, 0.5))
		if imgui.Button(fa.ICON_FA_COGS, imgui.ImVec2(isOpened[0] and sizeOpened - 10 or tabSize, tabSize)) then selected[0] = 2 end
		if imgui.IsItemHovered() then
			if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
			local alpha = (os.clock() - go_hint) * 5 -- �������� ���������
			if os.clock() >= go_hint then
				imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
				imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
				imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(700)
				imgui.TextColoredRGB("�������")
				if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
				imgui.PopStyleColor()
				imgui.PopStyleVar(2)
			end
		end
		imgui.PopStyleVar()
		imgui.PopStyleColor()
		imgui.SetCursorPos(imgui.ImVec2(5, 100))
		imgui.PushStyleColor(imgui.Col.Button, selected[0] == 0 and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImVec4(0.2, 0.2, 0.2, 0.5))
		imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(1, 0.6))
		if imgui.Button(fa.ICON_FA_EDIT, imgui.ImVec2(isOpened[0] and sizeOpened - 10 or tabSize, tabSize)) then selected[0] = 3 end
		if imgui.IsItemHovered() then
			if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
			local alpha = (os.clock() - go_hint) * 5 -- �������� ���������
			if os.clock() >= go_hint then
				imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
				imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
				imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(700)
				imgui.TextColoredRGB("�����")
				if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
				imgui.PopStyleColor()
				imgui.PopStyleVar(2)
			end
		end
		imgui.PopStyleColor()
		imgui.PopStyleVar()
		imgui.SetCursorPos(imgui.ImVec2(5, 150))
		imgui.PushStyleColor(imgui.Col.Button, selected[0] == 4 and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImVec4(0.2, 0.2, 0.2, 0.5))
		imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.835, 0.6))
		if imgui.Button(fa.ICON_FA_INFO_CIRCLE, imgui.ImVec2(isOpened[0] and sizeOpened - 10 or tabSize, tabSize)) then selected[0] = 4 end
		if imgui.IsItemHovered() then
			if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
			local alpha = (os.clock() - go_hint) * 5 -- �������� ���������
			if os.clock() >= go_hint then
				imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
				imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
				imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(700)
				imgui.TextColoredRGB("� �������")
				if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
				imgui.PopStyleColor()
				imgui.PopStyleVar(2)
			end
		end
		imgui.PopFont()
        imgui.PopStyleVar()
        imgui.PopStyleColor()

    --==[ CHILD ]==--
    imgui.SetCursorPos(imgui.ImVec2(sizeClosed, sizeClosed))
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(4, 4))
    imgui.BeginChild(title..'::mainchild', imgui.ImVec2(size.x - sizeClosed + 10, size.y - sizeClosed), false)
end

function imgui.EndWin11Menu()
    imgui.EndChild()
    imgui.End()
    imgui.PopStyleVar(2)
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

function imgui.AnimProgressBar(label, int, func, duration,size, bgclolor, fillcolor)
	local function bringFloatTo(from, to, start_time, duration)
		local timer = os.clock() - start_time
		if timer >= 0.00 and timer <= duration then; local count = timer / (duration / 100); return from + (count * (to - from) / 100),timer,false
		end; return (timer > duration) and to or from,timer,true
	end
		--if int > 100 then imgui.TextColored(imgui.ImVec4(1,0,0,0.7),'error func imgui.AnimProgressBar(*),int > 100') return end
		if IMGUI_ANIM_PROGRESS_BAR == nil then IMGUI_ANIM_PROGRESS_BAR = {} end
		if IMGUI_ANIM_PROGRESS_BAR ~= nil and IMGUI_ANIM_PROGRESS_BAR[label] == nil then
			IMGUI_ANIM_PROGRESS_BAR[label] = {int = (int or 0),clock = 0}
		end
		local mf = math.floor
		local p = IMGUI_ANIM_PROGRESS_BAR[label];
		if (p['int']) ~= (int) then
			if p.clock == 0 then; p.clock = os.clock(); end
			local d = {bringFloatTo(p.int,int,p.clock,(duration or 2.25))}
			if d[1] > int  then
				if ((d[1])-0.01) < (int) then; p.clock = 0; p.int = mf(d[1]-0.01); end
			elseif d[1] < int then
				if ((d[1])+0.01) > (int) then; p.clock = 0; p.int = mf(d[1]+0.01); end
			end
			p.int = d[1];
		end
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0,0,0,0))
		imgui.PushStyleColor(imgui.Col.FrameBg, bgclolor) -- background color progress bar
		imgui.PushStyleColor(imgui.Col.PlotHistogram, fillcolor) -- fill color progress bar
		imgui.ProgressBar(p.int / func, size or imgui.ImVec2(-1,15))
		imgui.PopStyleColor(3)
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

function imgui.Hint(text, delay)
	if imgui.IsItemHovered() then
		if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
		local alpha = (os.clock() - go_hint) * 5 -- �������� ���������
		if os.clock() >= go_hint then
			imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
			imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
			imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(700)
			imgui.IconColoredRGB('{1E90FF} '..fa.ICON_FA_INFO_CIRCLE..u8'���������:')
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

function imgui.ButtonActivated(activated, ...)
    if activated then
        imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.CheckMark])

            imgui.Button(...)

        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()

    else
        return imgui.Button(...)
    end
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
    if imgui.Button((tostring(sKeys):len() == 0 and u8"��������" or sKeys) .. name, imgui.ImVec2(width, 0)) then
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
