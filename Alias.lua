if exists("OfflineMapViewer", "alias") == 0 then
permGroup("OfflineMapViewer", "alias")
end
if exists("OpenWorldWindow", "alias") == 0 then
permAlias("OpenWorldWindow","OfflineMapViewer","^worldopen$",[[OfflineMapViewer.OffLineWindow:show()]])
end
if exists("CloseWorldWindow", "alias") == 0 then
permAlias("CloseWorldWindow","OfflineMapViewer","^worldclose$",[[OfflineMapViewer.OffLineWindow:hide()]])
end
if exists("LoginWorld", "alias") == 0 then
permAlias("LoginWorld","OfflineMapViewer","^worldlogin(?: (\d+))?$",[[
OfflineMapViewer.OffLineWindow:show()
decho(" usage : <250,250,250>worldlogin<128,128,128> or <250,250,250>worldlogin RoomID\n")

if not matches[2]
  then
    OfflineMapViewer.Login()
  else
    OfflineMapViewer.Login(matches[2])
end]])

--[[
package 用enable/disable group
disableAlias("OfflineMapViewer")
enableAlias("OfflineMapViewer")
]]

--[[ memo area:
^worldopen$
OfflineMapViewer.OffLineWindow:show()

^worldclose$
OfflineMapViewer.OffLineWindow:close()

^worldlogin(?: (\d+))?$
if matches[2] then OfflineMapViewer.Login(matches[2])
  else OfflineMapViewer.Login()
end
]]