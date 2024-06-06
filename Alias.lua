permAlias("Name","Group",指令,[[
script ]])



tempAlias("regex","code")
返回的alias ID就是name
permAlias("OpenWorldWindow","OfflineMapViewer","^worldopen$",[[OfflineMapViewer.OffLineWindow:show()]])

tempAlias("^worldopen$",[[OfflineMapViewer.OffLineWindow:show()]])
tempAlias("^worldclose$",[[OfflineMapViewer.OffLineWindow:close()]])
tempAlias("^^worldlogin(?: (\d+))?$",[[]])


--[[ memo area:
^worldopen$
OfflineMapViewer.OffLineWindow:show()

^worldclose$
OfflineMapViewer.OffLineWindow:close()

^worldlogin(?: (\d+))?$
if matches[2] then OfflineMapViewer.Login(matches[2])
  else OfflineMapViewer.Login()
end
Offlinetonumber(getCmdline())
]]