module(..., package.seeall)

--------------------------------------------------------------------------------
-- import
--------------------------------------------------------------------------------
local UIView = widget.UIView
local Button = widget.Button
local ListBox = widget.ListBox
local TextBox = widget.TextBox
local MenuControlView = widgets.MenuControlView
local MenuMainView = widgets.MenuMainView
local MenuItemView = widgets.MenuItemView

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    menuMainView = MenuMainView {
        scene = scene,
    }
    
    menuControlView = MenuControlView {
        scene = scene,
    }
    
    -- event listeners
    menuControlView:addEventListener("back", menuControlView_OnBack)
    menuMainView:addEventListener("enter", menuMainView_OnEnter)
end

function menuMainView_OnEnter(e)
    local data = e.data
    local nextScene = data.next_scene
    local sceneAnimation = data.scene_animation
    if nextScene then
        flower.openScene(nextScene, {animation = sceneAnimation})
    end
end

function menuControlView_OnBack(e)
    flower.closeScene()
end
