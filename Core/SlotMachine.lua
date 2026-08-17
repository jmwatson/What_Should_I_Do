local _, addon = ...;
local slotTimer=nil;
local slotTick=0;
local slotTotal=0;
local slotWinner=nil;
local slotLabel=nil;
local slotCallback=nil;

local function StopSlot()
    if slotTimer then
        slotTimer:Cancel();
        slotTimer = nil;
    end
end
addon.StopSlot = StopSlot;

local function StartSlot(label, pool, OnDone)
    local function Tick()
        slotTick = slotTick + 1;
        
        if slotTick >= slotTotal then
            slotLabel:SetText(slotWinner);
            addon.StopSlot();
            
            if slotCallback then
                slotCallback(slotWinner);
            end
            
            return;
        end

        slotLabel:SetText(pool[math.random(#pool)]);
        slotTimer = C_Timer.NewTimer(0.06 + 0.18*((slotTick/slotTotal)^2), Tick);
    end

    addon.StopSlot();
    
    if not pool or #pool == 0 then
        label:SetText("No options!");
        
        if OnDone then
            OnDone(nil);
        end
    
        return;
    end
    
    slotTick=0;
    slotTotal=26+math.random(0,10);
    slotWinner=pool[math.random(#pool)];
    slotLabel=label;
    slotCallback=OnDone;
    Tick();
end
addon.StartSlot = StartSlot;
