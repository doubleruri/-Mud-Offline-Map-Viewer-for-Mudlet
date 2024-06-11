--Original by doubleruri
--1. IMPORTMANT Notice:
--     Need function and variable of generic_mapper:
--     getRoomName() getRoomUserData() getRoomExits() getSpecialExits()
--     map.currentRoom
--2. You can skip searching config file by saving your variable<OfflineMapViewer.config.SavePath, put your config-file fullpath in it> permanely.
--
----Working flow----
--1. Set where to start explorer offline world.
--   You can choise a room ID from map or where you are now.
--2. Get All Data to construstion offline world.
--3. Find out all exits, there are to pattern to show
--   pattern 1: show in a line
--   pattern 2: show line by line
--4. There are 2 method to move in offline world:
--   [1] click exits
--   [2][Todo]type command to move
--5. If you want to back to Reality,just type look or use OfflineMapViewer.Logout()
--
----Function LIST----
--[Done]OfflineMapViewer.echo(what,err)
--[Done]OfflineMapViewer.DataLoad(RoomID)
--[Done]OfflineMapViewer.Login(RoomID)
--[Done]OfflineMapViewer.Logout()
--[Done]OfflineMapViewer.config()
--[Done]save configs to file
--
----key Variable----
--OfflineMapViewer.currentRoom
--OfflineMapViewer.previousRoom
--OfflineMapViewer.recallPoint
--settingInProfile:   File that store user config-file. You can asign a path to one directory for different profile.


OfflineMapViewer = OfflineMapViewer or {}
OfflineMapViewer.configs = OfflineMapViewer.configs or {}

local settingInProfile = getMudletHomeDir().."/Module_OfflineMapViewer.txt"
if not OfflineMapViewer.configs.SavePath then
  if io.exists(settingInProfile)
    then
      table.load(settingInProfile,OfflineMapViewer.configs)
      table.load(OfflineMapViewer.configs.SavePath,OfflineMapViewer.configs)
    else
      local FileInProfile = io.open(settingInProfile,"w+")
      FileInProfile:close()
      OfflineMapViewer.configs.SavePath = invokeFileDialog(false, "Where do you save the config file? ")
      local ConfigFile = io.open(OfflineMapViewer.configs.SavePath.."/OMapViewerConfig.txt","a+")
      ConfigFile:close()
      OfflineMapViewer.configs.SavePath = OfflineMapViewer.configs.SavePath.."/OMapViewerConfig.txt"
      table.save(getMudletHomeDir().."/Module_OfflineMapViewer.txt",OfflineMapViewer.configs)
	  table.save(OfflineMapViewer.configs.SavePath,OfflineMapViewer.configs)
  end
  else
table.load(OfflineMapViewer.configs.SavePath,OfflineMapViewer.configs)
end
--result : profile folder 有記錄檔，讀取紀錄的設定內含自訂的位置。
--        讀取自訂位置的紀錄檔
--        如果沒有，在profile folder內創一個檔，自選一個路徑後在該路徑下創自訂紀錄檔案，
--        並把路徑指向該檔案後寫進profile folder內的檔案和自訂路徑的檔案
--table.load(getMudletHomeDir().."/Module_OfflineMapViewer.txt",OfflineMapViewer)

OfflineMapViewer.configs.pattern = OfflineMapViewer.configs.pattern or 2
OfflineMapViewer.configs.moveMethod = OfflineMapViewer.configs.moveMethod or 1
OfflineMapViewer.configs.ClearWindow = OfflineMapViewer.configs.ClearWindow or false
OfflineMapViewer.configs.whatInRoom = OfflineMapViewer.configs.whatInRoom or {"description","NPC","OBJ","Notes"}
OfflineMapViewer.Message = {}
OfflineMapViewer.Message.Set1=[[
╔════════════╦════════════╗
║       Pattern 1        ║       Pattern 2        ║
╟────────────╫────────────╢
║  <255,255,0>Exits<192,192,192>: <34,139,34>east<192,192,192>,<34,139,34>west<192,192,192>...   ║   <255,255,0>Exits<192,192,192>:               ║
║                        ║     <34,139,34>east<192,192,192>－roomname     ║
║                        ║     <34,139,34>west<192,192,192>－roomname     ║
╚════════════╩════════════╝
]]
OfflineMapViewer.Message.Set2=[[

      Where do you want to login World?
        <167,145,199>Set your position<192,192,192> in map and Login again <255,255,0>OR<192,192,192>
        Alias <167,145,199>worldlogin <RoomID>  <255,255,0>OR<192,192,192>
        <167,145,199>Type <RoomID><192,192,192> at CmdLine and Click Login Button
]]

--播報員的function
local MapperVoice = "<112,229,0>[Offline_MAP]: "
local ErrorVoice = "<255,0,0>[<178,34,34>Offline_MAP<255,0,0>]: "
function OfflineMapViewer.echo(what,err)
  if err then decho("Offline_World",ErrorVoice) else decho("Offline_World",MapperVoice) end
  decho("Offline_World",tostring(what))
  --echo("Offline_World","\n")
end
----------
--Function--
function OfflineMapViewer.Login(RoomID)
  if not RoomID then
    if not  map.currentRoom then 
      OfflineMapViewer.echo(OfflineMapViewer.Message.Set2,1)
     return
    else OfflineMapViewer.currentRoom = tonumber(map.currentRoom)
    end
  else
    OfflineMapViewer.currentRoom = RoomID
  end
    OfflineMapViewer.recallPoint = tonumber(OfflineMapViewer.currentRoom)
    echo("Offline_World","Login point is Here you are : #"..OfflineMapViewer.currentRoom.."  "..getRoomName(OfflineMapViewer.currentRoom).."\n")
	decho("Offline_World",MapperVoice)
	echo("Offline_World","Do you want to START HERE??  ")
	dechoLink("Offline_World","<34,139,34>[<u> YES </u>]",[[centerview(OfflineMapViewer.currentRoom) OfflineMapViewer.DataLoad(OfflineMapViewer.currentRoom)]],"", true)
	echo("Offline_World","  ")
  dechoLink("Offline_World","<255,0,255>[<u> NO </u>]\n",[[OfflineMapViewer.echo("Please RE-SELECT START point\n")]],"", true)
    centerview(OfflineMapViewer.currentRoom)
end

function OfflineMapViewer.DataLoad(RoomID)
OfflineMapViewer.roomUserData = getAllRoomUserData(RoomID)
if OfflineMapViewer.configs.ClearWindow then clearWindow("Offline_World") end
echo("Offline_World","\n") 
decho("Offline_World","<255,255,0>"..getRoomName(RoomID).."\n")
--顯示RoomUserData,依照offlineMapViewer.whatInRoom裡的順序
--Show RoomUserData order by OfflineMapViewer.whatInRoom
for k,v in ipairs (OfflineMapViewer.configs.whatInRoom) do
  local results = getRoomUserData(RoomID,v,true)
  if  results then echo("Offline_World",results.."\n") end
end
--顯示出口，有兩種顯示方式
--Show exits and special exits,two display pattern
local exits, special_exits = getRoomExits(RoomID),getSpecialExits(RoomID)
decho("Offline_World","<255,255,0>出口：\n")
if table.is_empty(exits) and table.is_empty(special_exits)
  then decho("Offline_World","<230,0,0:154,205,50>  No Exits!!  \n")
       decho("Offline_World",MapperVoice)
       dechoLink("Offline_World","<34,139,34> Click to previous room\n",function()
                  														  centerview(OfflineMapViewer.previousRoom)
																		  OfflineMapViewer.DataLoad(OfflineMapViewer.previousRoom)
																		end,"")
end
if OfflineMapViewer.configs.pattern == 2 then
  for dir,id in pairs (exits) do
   	dechoLink("Offline_World","<34,139,34>"..dir.."<192,192,192>－"..getRoomName(id).."\n", function() OfflineMapViewer.previousRoom = tonumber(RoomID)
                                                                                                       centerview(id)
                                                                                                       OfflineMapViewer.DataLoad(id)
																							end,"", true)
  end
  for goRoom,v in pairs (special_exits) do
    for command,order in pairs(v) do
      dechoLink("Offline_World","<34,139,34>"..command.."<192,192,192>－"..getRoomName(goRoom).."\n", function() OfflineMapViewer.previousRoom = tonumber(RoomID)
                                                                                                                 centerview(goRoom)
                                                                                                                 OfflineMapViewer.DataLoad(goRoom)
																									  end,"", true)
    end
  end
else
  local numberOfExits = 1
  for dir,id in pairs (exits) do
    if numberOfExits >1 then echo("Offline_World"," , ") end
    dechoLink("Offline_World","<34,139,34>"..dir.."<192,192,192>", function()
	                                                                 OfflineMapViewer.previousRoom = tonumber(RoomID)
																	 centerview(id)
																	 OfflineMapViewer.DataLoad(id)
																   end,getRoomName(id), true)
    numberOfExits = numberOfExits + 1
  end
  for goRoom,v in pairs (special_exits) do
    for command,order in pairs(v) do
      echo("Offline_World"," , ")
      dechoLink("Offline_World","<34,139,34>"..command.."<192,192,192>", function()
	                                                                       OfflineMapViewer.previousRoom = tonumber(RoomID)
																		   centerview(goRoom)
																		   OfflineMapViewer.DataLoad(goRoom)
																		 end,getRoomName(goRoom), true)
    end
  end
end
echo("Offline_World","\n\n")
end

function OfflineMapViewer.Logout()
  send("look")
end

function OfflineMapViewer.setRoomKeyToShow()
local roomKey = getCmdLine("Offline_World")
roomKey = string.split(roomKey,",")
OfflineMapViewer.whatInRoom =roomKey
end

function OfflineMapViewer.config(var,set)
local exitsample = OfflineMapViewer.Message.Set1
decho("Offline_World","<255,255,255:72,61,139>\n-----------------------Setting-----------------------\n")
dechoLink("Offline_World","<b><255,255,255:47,79,79>1.ClearWindow       :</b>",function()
                                                                                 if OfflineMapViewer.configs.ClearWindow 
                                                                                  then OfflineMapViewer.configs.ClearWindow = false
                                                                                  else OfflineMapViewer.configs.ClearWindow = true
                                                                                 end
                                                                                 OfflineMapViewer.config()
                                                                                end,"",true)
decho("Offline_World","  "..tostring(OfflineMapViewer.configs.ClearWindow).."\n")
dechoLink("Offline_World","<b><255,255,255:47,79,79>2.Show userRoomData :</b>",[[OfflineMapViewer.setRoomKeyToShow() OfflineMapViewer.config()]],"",true)
decho("Offline_World","  "..table.concat(OfflineMapViewer.configs.whatInRoom,", ").."\n")
dechoLink("Offline_World","<b><255,255,255:47,79,79>3.Exits Pattern     :</b>",function()
                                                                                 if OfflineMapViewer.configs.pattern == 1 
                                                                                  then OfflineMapViewer.configs.pattern = 2
                                                                                      
                                                                                  else OfflineMapViewer.configs.pattern = 1
                                                                                 end
                                                                                 OfflineMapViewer.config() end,"",true)
decho("Offline_World","  "..tostring(OfflineMapViewer.configs.pattern).."\n")
if OfflineMapViewer.configs.pattern == 1 then
     exitsample = utf8.gsub(exitsample,"Pattern 1","<255,69,0>Pattern 1<192,192,192>")
  else
  exitsample = utf8.gsub(exitsample,"Pattern 2","<255,69,0>Pattern 2<192,192,192>")
end
decho("Offline_World",exitsample)
dechoLink("Offline_World","<b><255,255,255:47,79,79>4.Movemethod        :</b>",function() end,"",true)
decho("Offline_World","  "..OfflineMapViewer.configs.moveMethod.."\n")
decho("Offline_World","(1)-- Click     (2)-- Command (NotComplete)\n")
dechoLink("Offline_World","<b><255,255,255:47,79,79>SavePath :</b>",function() end,"",true)
decho("Offline_World"," "..OfflineMapViewer.configs.SavePath.."\n")
decho("Offline_World","<255,255,255:72,61,139>---------------Click to Switch Setting---------------\n")
OfflineMapViewer.echo("SAVE to File??            ")
dechoLink("Offline_World","<220,220,0>[YES]",function() table.save(OfflineMapViewer.configs.SavePath,OfflineMapViewer.configs) end,"",true)
decho("Offline_World","  ")
dechoLink("Offline_World","<220,220,0>[NO]\n",[[OfflineMapViewer.echo("\nSetting won't save to file.\nOpen Profile next time will be same setting before\n",1)]],"",true)

end
