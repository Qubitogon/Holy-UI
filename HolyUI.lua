_,HUI=...

_huiGlobal=HUI

HUI.bigS=45
HUI.medS=30
HUI.smallS=20
HUI.bigFS=24
HUI.medFS=15
HUI.smallFS=13

local tempF=CreateFrame("Frame")
tempF:RegisterEvent("PLAYER_ENTERING_WORLD")
tempF:SetScript("OnEvent",function()
  local className=UnitClass("player")
  if className~="Priest" then return
  else
    tempF:UnregisterEvent("PLAYER_ENTERING_WORLD")
    tempF=nil
    local fabn=AuraUtil.FindAuraByName
    local green={0.3,0.95,0.3}
    local red={0.9,0.3,0.3}
    local yellow={0.95,0.95,0.3}
    
    local manaBD={edgeFile ="Interface\\DialogFrame\\UI-DialogBox-Border",edgeSize = 8, insets ={ left = 0, right = 0, top = 0, bottom = 0 }}
    local bd2={edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 10, insets = { left = 4, right = 4, top = 4, bottom = 4 }}
    local insert=table.insert
    local port={}
    local mf=math.floor
    local afterDo=C_Timer.After
    local pairs=pairs
    local playerName=UnitName("player")
    
    function HUI.onCast1(self)
      local t,d=GetSpellCooldown(self.id)
      if d<2 then
        self.offCD:Show()
        self.onCD:Hide()
      else
        self.offCD:Hide()
        self.onCD:Show()
        self.onCD.et=1
        self.onCD.cd:SetCooldown(t,d)
        self.onCD.t=t
        self.onCD.d=d
      end
    end

    function HUI.onCastRap(self)
      local t,d=GetSpellCooldown(self.id)
      if d<2 then
        self.offCD:Show()
        self.onCD:Hide()
      else
        self.offCD:Hide()
        self.onCD:Show()
        self.onCD.et=1
        self.onCD.cd:SetCooldown(t,d)
        self.onCD.t=t
        self.onCD.d=d
        self.active:Show()
        self.active.ext=GetTime()+10
        afterDo(10,function() self.active:Hide() end)
      end
      

    end
    
    function HUI.onUpdate1(self,et)
      self.et=self.et+et
      if self.et<0.1 then return end

      self.et=0
      local rT=self.t+self.d-GetTime()
      self.text1:SetText(mf(rT))
      if rT<0.01 then self.parent:onCast() end
    end
    
    function HUI.onUpdateJSSChannelUp(self,et)
      self.et=self.et+et
      if self.et<0.1 then return end

      self.et=0
      local rT=self.t+self.d-GetTime()
      self.text:SetText(mf(rT))    
    end
    
    local function createCDIcon(id,size,hasCDText)
      local hasCDText=hasCDText
      if not hasCDText then hasCDText=false end --unnecessary, I know
      local iF
      local _,_,icon=GetSpellInfo(id)
      local s,fs
      if size=="big" then s=HUI.bigS; fs=HUI.bigFS end
      if size=="med" then s=HUI.medS; fs=HUI.medFS end
      if size=="small" then s=HUI.smallS; fs=HUI.smallFS end

      iF=CreateFrame("Frame",nil,HUI.f)
      iF:SetSize(s,s)
      iF:SetFrameLevel(5)
      iF.id=id
      
      iF.offCD=CreateFrame("Frame",nil,iF)
      iF.offCD:SetAllPoints(true)

      iF.offCD.texture=iF.offCD:CreateTexture(nil,"BACKGROUND")
      iF.offCD.texture:SetAllPoints(true)
      iF.offCD.texture:SetTexture(icon)

      iF.offCD.cd=CreateFrame("Cooldown",nil,iF.offCD,"CooldownFrameTemplate")
      iF.offCD.cd:SetAllPoints(true)
      iF.offCD.cd:SetFrameLevel(iF.offCD:GetFrameLevel())
      iF.offCD.cd:SetDrawEdge(false)
      iF.offCD.cd:SetDrawBling(false)
      
      iF.offCD.text2=iF.offCD:CreateFontString(nil,"OVERLAY")
      iF.offCD.text2:SetFont("Fonts\\FRIZQT__.ttf",fs,"OUTLINE")
      iF.offCD.text2:SetPoint("CENTER")
      
      iF.onCD=CreateFrame("Frame",nil,iF)
      iF.onCD:SetAllPoints(true)
      
      iF.onCD.texture=iF.onCD:CreateTexture(nil,"BACKGROUND")
      iF.onCD.texture:SetAllPoints(true)
      iF.onCD.texture:SetTexture(icon)
      iF.onCD.texture:SetDesaturated(1)

      iF.onCD.cd=CreateFrame("Cooldown",nil,iF.onCD,"CooldownFrameTemplate")
      iF.onCD.cd:SetAllPoints(true)
      iF.onCD.cd:SetFrameLevel(iF.onCD:GetFrameLevel())
      iF.onCD.cd:SetDrawEdge(false)
      iF.onCD.cd:SetDrawBling(false)
      
      iF.onCD.text1=iF.onCD:CreateFontString(nil,"OVERLAY")
      iF.onCD.text1:SetFont("Fonts\\FRIZQT__.ttf",fs,"OUTLINE")
      iF.onCD.text1:SetPoint("CENTER")

      if hasCDText then iF.onCD:SetScript("OnUpdate",HUI.onUpdate1) end
      iF.onCD.parent=iF

      iF.onCD:Hide()

      iF.onCD.et=0
      port[id]=iF
      return iF
    end
    
    local function createAuraIcon(id,size)
      local iF
      local _,_,icon=GetSpellInfo(id)
      local s,fs
      if size=="big" then s=HUI.bigS; fs=HUI.bigFS end
      if size=="med" then s=HUI.medS; fs=HUI.medFS end
      if size=="small" then s=HUI.smallS; fs=HUI.smallFS end

      iF=CreateFrame("Frame",nil,HUI.f)
      iF:SetSize(s,s)
      iF:SetFrameLevel(5)
      iF.id=id
      
      iF.grey=CreateFrame("Frame",nil,iF)
      iF.grey:SetAllPoints(true)

      iF.grey.texture=iF.grey:CreateTexture(nil,"BACKGROUND")
      iF.grey.texture:SetAllPoints(true)
      iF.grey.texture:SetTexture(icon)
      iF.grey.texture:SetDesaturated(1)

      iF.grey.text=iF.grey:CreateFontString(nil,"OVERLAY")
      iF.grey.text:SetFont("Fonts\\FRIZQT__.ttf",fs,"OUTLINE")
      iF.grey.text:SetPoint("CENTER")
      
      iF.normal=CreateFrame("Frame",nil,iF)
      iF.normal:SetAllPoints(true)
      
      iF.normal.texture=iF.normal:CreateTexture(nil,"BACKGROUND")
      iF.normal.texture:SetAllPoints(true)
      iF.normal.texture:SetTexture(icon)

      iF.normal.cd=CreateFrame("Cooldown",nil,iF.normal,"CooldownFrameTemplate")
      iF.normal.cd:SetAllPoints(true)
      iF.normal.cd:SetFrameLevel(iF.normal:GetFrameLevel())

      iF.normal.text=iF.normal:CreateFontString(nil,"OVERLAY")
      iF.normal.text:SetFont("Fonts\\FRIZQT__.ttf",fs,"OUTLINE")
      iF.normal.text:SetPoint("CENTER")

      iF.normal:Hide()

      iF.normal.et=0
      return iF
    end

    local function checkTalentStuff()

      local _,_,_,halo = GetTalentInfo(6,3,1)

      if halo then HUI.halo:Show(); HUI.halo:onCast() else HUI.halo:Hide() end 
      
    end

    local function checkCombat()
        if true then return  end
        if InCombatLockdown() then HUI.f:Show() else HUI.f:Hide() end 
    end
    
    local function checkSpecialization()
      
      if GetSpecialization()==2 then 
        HUI.f:Show() 
        HUI.f.loaded=true
      else 
        HUI.f:Hide() 
        HUI.f.loaded=false
      end
      checkCombat()
    end
    
    local function checkTargetSWP()
      if not UnitExists("target") then return nil end
      local _,_,_,_,d,ext=fabn("Shadow Word: Pain","target","HARMFUL","PLAYER")
      return d,ext
    end
    
    local function fOnShow()
      for _,v in pairs(port) do  v:onCast() end
      HUI.mana:update()
    end
       
    function HUI.onCastRad(self)
      local s,_,t,d=GetSpellCharges(self.id)

      if s==2 then
        self.onCD:Hide()
        self.offCD:Show()
        self.offCD.et=1
        self.offCD.cd:SetCooldown(0,0)
        self.offCD.t=t
        self.offCD.d=d
        self.offCD.text2:SetText(s)
      elseif s>0 and d>2 then
        self.onCD:Hide()
        self.offCD:Show()
        self.offCD.et=1
        self.offCD.cd:SetCooldown(t,d)
        self.offCD.t=t
        self.offCD.d=d
        self.offCD.text2:SetText(s)
        afterDo(d, function() self:onCast() end)
      elseif s==0 then
        self.offCD:Hide()
        self.onCD:Show()
        self.onCD.et=1
        self.onCD.cd:SetCooldown(t,d)
        self.onCD.t=t
        self.onCD.d=d
      end
      
    end
    
    HUI.eventHandler = function(self,event,_,tar,id,id2)
      if not self.loaded then return end
      if event=="UNIT_HEALTH_FREQUENT" then
        HUI.health:update()

      elseif event=="UNIT_POWER_UPDATE" then 
        HUI.mana:update()
                
      elseif event=="UNIT_SPELLCAST_SUCCEEDED" then
       local spell=port[id]
       if spell then afterDo(0,function() spell:onCast();  end) end
       if id==34861 or id==2050 then afterDo(0,function() port[265202]:onCast() end)
       else afterDo(0,function() port[34861]:onCast(); port[2050]:onCast() end) end
      end
      
    end
    
    HUI.f=CreateFrame("Frame","HUIFrame",UIParent)
    local f=HUI.f

    --main frame + mover + slash command
    do
    f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED","player")
    f:RegisterUnitEvent("UNIT_POWER_UPDATE","player")
    f:RegisterUnitEvent("UNIT_HEALTH_FREQUENT","player")
    f:SetScript("OnEvent",HUI.eventHandler)
    f:SetScript("OnShow",fOnShow)
    f:SetSize(2*HUI.bigS+1,150)
    f:SetPoint("CENTER")
    f:SetMovable(true)

    f.mover=CreateFrame("Frame",nil,f)
    f.mover:SetAllPoints(true)
    f.mover:SetFrameLevel(f:GetFrameLevel()+6)

    f.mover.texture=f.mover:CreateTexture(nil,"OVERLAY")
    f.mover.texture:SetAllPoints(true)
    f.mover.texture:SetColorTexture(0,0,0.1,0.5)

    f.mover:EnableMouse(true)
    f.mover:SetMovable(true)
    f.mover:RegisterForDrag("LeftButton")
    f.mover:SetScript("OnMouseDown", function() HUI.f:StartMoving();  end)
    f.mover:SetScript("OnMouseUp", function() HUI.f:StopMovingOrSizing();  end)
    f.mover:Hide()

    SLASH_HUI1="/hui"
    SlashCmdList["HUI"]= function(arg)
      if f.mover:IsShown() then f.mover:Hide() else f.mover:Show() end
    end

    end --end of main mover slash

    --helper frame
    do
    HUI.h=CreateFrame("Frame","HUIHFrame",UIParent)
    local h=HUI.h
    h:SetPoint("CENTER")
    h:SetSize(1,1)
    h:RegisterEvent("PLAYER_REGEN_ENABLED")
    h:RegisterEvent("PLAYER_REGEN_DISABLED")
    h:RegisterEvent("PLAYER_ENTERING_WORLD")
    h:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    h:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    
    local function hEventHandler(self,event) 
      if event=="PLAYER_REGEN_ENABLED" then
        afterDo(15,checkCombat)
      elseif event=="PLAYER_REGEN_DISABLED" then
        if self.loaded then HUI.f:Show() end
      elseif event=="ACTIVE_TALENT_GROUP_CHANGED" then
        checkTalentStuff()
      elseif event=="PLAYER_SPECIALIZATION_CHANGED" then
        checkSpecialization()
      end
    end

    h:SetScript("OnEvent",hEventHandler)

    end --end of help frame

    --spells 
    do 

    HUI.coh=createCDIcon(204883,"big",true)
    HUI.coh:SetPoint("TOPLEFT",HUI.f,"TOPLEFT",0,0)
    HUI.coh.onCast=HUI.onCast1
    
    HUI.pom=createCDIcon(33076,"big",true)
    HUI.pom:SetPoint("LEFT",HUI.coh,"RIGHT",1,0)
    HUI.pom.onCast=HUI.onCast1

    HUI.halo=createCDIcon(120517,"med",true)
    HUI.halo:SetPoint("TOPRIGHT",HUI.pom,"BOTTOMRIGHT",0,-2-HUI.bigS)
    HUI.halo.onCast=HUI.onCast1
   
    HUI.ds=createCDIcon(110744,"med",true)
    HUI.ds:SetPoint("TOPRIGHT",HUI.pom,"BOTTOMRIGHT",0,-2-HUI.bigS)
    HUI.ds.onCast=HUI.onCast1
    
    HUI.ser=createCDIcon(2050,"big",true)
    HUI.ser:SetPoint("TOP",HUI.pom,"BOTTOM",0,-1)
    HUI.ser.onCast=HUI.onCast1
    
    HUI.sanc=createCDIcon(34861,"big",true)
    HUI.sanc:SetPoint("TOP",HUI.coh,"BOTTOM",0,-1)
    HUI.sanc.onCast=HUI.onCast1
    
    HUI.hws=createCDIcon(265202,"med",false)
    HUI.hws:SetPoint("TOPLEFT",HUI.sanc,"BOTTOMLEFT",0,-1)
    HUI.hws.onCast=HUI.onCast1
    
    HUI.dh=createCDIcon(64843,"med",false)
    HUI.dh:SetPoint("TOP",HUI.hws,"BOTTOM",0,-1)
    HUI.dh.onCast=HUI.onCast1
    
    HUI.gs=createCDIcon(47788,"med",false)
    HUI.gs:SetPoint("TOP",HUI.dh,"BOTTOM",0,-1)
    HUI.gs.onCast=HUI.onCast1
    
    HUI.pf=createCDIcon(527,"med",true)
    HUI.pf:SetPoint("TOP",HUI.gs,"BOTTOM",0,-1)
    HUI.pf.onCast=HUI.onCast1

    HUI.dp=createCDIcon(19236,"med",false)
    HUI.dp:SetPoint("TOPRIGHT",HUI.ser,"BOTTOMRIGHT",0,-2-HUI.medS)
    HUI.dp.onCast=HUI.onCast1
    
    HUI.soh=createCDIcon(64901,"med",false)
    HUI.soh:SetPoint("TOP",HUI.dp,"BOTTOM",0,-1)
    HUI.soh.onCast=HUI.onCast1
    
    HUI.lj=createCDIcon(255647,"med",false)
    HUI.lj:SetPoint("TOP",HUI.soh,"BOTTOM",0,-1)
    HUI.lj.onCast=HUI.onCast1
    
    end

    --mana bar
    do
    local function manaUpdateFunc(self)
      local m=UnitPower("player")
      local mm=UnitPowerMax("player")
      local val=m/mm*100
      self:SetValue(val)
      self.text:SetText(mf(val))
    end


    HUI.mana=CreateFrame("StatusBar","HUImana",HUI.f,"TextStatusBar")
    HUI.mana:SetPoint("TOPLEFT",HUI.pom,"BOTTOMLEFT",1,-2-HUI.bigS)
    HUI.mana:SetHeight(122)
    HUI.mana:SetWidth(12)
    HUI.mana:SetOrientation("VERTICAL")
    HUI.mana:SetReverseFill(false)
    HUI.mana:SetMinMaxValues(0,100)
    HUI.mana:SetStatusBarTexture(0.3,0.3,0.95,1)
    HUI.mana.update=manaUpdateFunc

    local bt=HUI.mana:GetStatusBarTexture()
    bt:SetGradientAlpha("HORIZONTAL",1,1,1,1,0.4,0.4,0.4,1)


    HUI.mana.border=CreateFrame("Frame",nil,HUI.mana)
    HUI.mana.border:SetPoint("TOPRIGHT",HUI.mana,"TOPRIGHT",3,3)
    HUI.mana.border:SetPoint("BOTTOMLEFT",HUI.mana,"BOTTOMLEFT",-6,-3)
    --HUI.mana.border:SetBackdrop(manaBD) 

    HUI.mana.text=HUI.mana.border:CreateFontString(nil,"OVERLAY")
    HUI.mana.text:SetFont("Fonts\\FRIZQT__.ttf",12,"OUTLINE")
    HUI.mana.text:SetPoint("TOP",HUI.mana,"TOP",0,-2)
    HUI.mana.text:Hide() --rmove if want to show obv.

    HUI.mana.bg=HUI.mana:CreateTexture(nil,"BACKGROUND")
    HUI.mana.bg:SetPoint("TOPRIGHT",HUI.mana,"TOPRIGHT",2,2)
    HUI.mana.bg:SetPoint("BOTTOMLEFT",HUI.mana,"BOTTOMLEFT",-2,-2)
    HUI.mana.bg:SetColorTexture(0,0,0,1)

    end

    --health bar
    do
    local function healthUpdateFunc(self)
      local m=UnitHealth("player")
      local mm=UnitHealthMax("player")
      local val=m/mm*100
      self:SetValue(val)
      self.text:SetText(mf(val))
      port[19236]:onCast()
    end


    HUI.health=CreateFrame("StatusBar","HUIhealth",HUI.f,"TextStatusBar")
    HUI.health:SetPoint("TOPRIGHT",HUI.coh,"BOTTOMRIGHT",-1,-2-HUI.bigS)
    HUI.health:SetHeight(122)
    HUI.health:SetWidth(12)
    HUI.health:SetOrientation("VERTICAL")
    HUI.health:SetReverseFill(false)
    HUI.health:SetMinMaxValues(0,100)
    HUI.health:SetStatusBarTexture(0.3,0.85,0.3,1)
    HUI.health.update=healthUpdateFunc

    local bt=HUI.health:GetStatusBarTexture()
    bt:SetGradientAlpha("HORIZONTAL",1,1,1,1,0.4,0.4,0.4,1)

    HUI.health.border=CreateFrame("Frame",nil,HUI.health)
    HUI.health.border:SetPoint("TOPRIGHT",HUI.health,"TOPRIGHT",6,3)
    HUI.health.border:SetPoint("BOTTOMLEFT",HUI.health,"BOTTOMLEFT",-3,-3)
    --HUI.health.border:SetBackdrop(healthBD) 

    HUI.health.text=HUI.health.border:CreateFontString(nil,"OVERLAY")
    HUI.health.text:SetFont("Fonts\\FRIZQT__.ttf",12,"OUTLINE")
    HUI.health.text:SetPoint("TOP",HUI.health,"TOP",0,-2)
    HUI.health.text:Hide() --rmove if want to show obv.

    HUI.health.bg=HUI.health:CreateTexture(nil,"BACKGROUND")
    HUI.health.bg:SetPoint("TOPRIGHT",HUI.health,"TOPRIGHT",2,2)
    HUI.health.bg:SetPoint("BOTTOMLEFT",HUI.health,"BOTTOMLEFT",-2,-2)
    HUI.health.bg:SetColorTexture(0,0,0,1)
    end

    
    --things to do on PAYER_ENTERING_WORLD
    checkTalentStuff()
    fOnShow()
    checkSpecialization()
    if playerName=="Monogon" then afterDo(0,function() HUI.f:SetPoint("TOPRIGHT",_eFGlobal.units,"TOPLEFT",-2,0) end) end
    --HUI.f:SetPoint("CENTER",UIParent,"CENTER")
    checkCombat()
  end
end)













