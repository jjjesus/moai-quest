----------------------------------------------------------------------------------------------------
-- ウィジェットクラスを定義するモジュールです.
-- ゲームに特化した部品を定義します.
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local widget = require "widget"
local entities = require "libs/entities"
local display = require "libs/display"
local repositry = entities.repositry
local class = flower.class
local table = flower.table
local ClassFactory = flower.ClassFactory
local InputMgr = flower.InputMgr
local SceneMgr = flower.SceneMgr
local Group = flower.Group
local Label = flower.Label
local TextAlign = widget.TextAlign
local UIView = widget.UIView
local UIComponent = widget.UIComponent
local Joystick = widget.Joystick
local Button = widget.Button
local Panel = widget.Panel
local ListBox = widget.ListBox
local ListItem = widget.ListItem
local TextBox = widget.TextBox
local FaceImage = display.FaceImage
local ActorImage = display.ActorImage

-- classes
local ActorStatusBox
local ActorDetailBox
local ItemListBox
local ItemListItem
local SkillListBox
local SkillListItem
local MemberListBox
local MemberListItem
local InventoryListBox

-- ウィジェットの最大の横幅
local WIDGET_WIDTH = 320

--------------------------------------------------------------------------------
-- @type MenuActorDetailBox
-- アクターのステータス詳細を表示するボックスです.
--------------------------------------------------------------------------------
ActorDetailBox = class(Panel)
M.ActorDetailBox = ActorDetailBox

-- Label names
ActorDetailBox.STATUS_LABEL_NAMES = {
    "STR",
    "VIT",
    "INT",
    "MEN",
    "SPD",
}

-- Label names
ActorDetailBox.EQUIP_ICONS = {
    1,
    2,
    3,
    4,
}

---
-- 内部変数を初期化します.
function ActorDetailBox:_initInternal()
    ActorDetailBox.__super._initInternal(self)
    self._faceImage = nil
    self._statusNameLabels = {}
    self._statusValueLabels = {}
    self._actor = nil
end

---
-- 子オブジェクトを生成します.
function ActorDetailBox:_createChildren()
    ActorDetailBox.__super._createChildren(self)
    self:_createFaceImage()
    self:_createHeaderLabel()
    self:_createStatusLabel()

    self:setSize(WIDGET_WIDTH, 260)
end

---
-- フェイスイメージを生成します.
function ActorDetailBox:_createFaceImage()
    self._faceImage = FaceImage(1)
    self._faceImage:setPos(10, 10)
    self:addChild(self._faceImage)
end

---
-- ヘッダーラベルを生成します.
function ActorDetailBox:_createHeaderLabel()
    self._headerLabel = Label("DUMMY", 200, 100, nil, 20)
    self._headerLabel:setPos(self._faceImage:getRight() + 10, 10)
    self:addChild(self._headerLabel)
end

---
-- ステータスラベルを生成します.
function ActorDetailBox:_createStatusLabel()
    local offsetX, offsetY = self._faceImage:getLeft(), 5 + self._faceImage:getBottom()
    for i, name in ipairs(ActorDetailBox.STATUS_LABEL_NAMES) do
        local nameLabel = Label(name, 50, 30, nil, 20)
        nameLabel:setPos(offsetX, offsetY + (i - 1) * nameLabel:getHeight())

        local valueLabel = Label("", 50, 30, nil, 20)
        valueLabel:setPos(nameLabel:getRight(), offsetY + (i - 1) * nameLabel:getHeight())

        self:addChild(nameLabel)
        self:addChild(valueLabel)
        table.insert(self._statusNameLabels, nameLabel)
        table.insert(self._statusValueLabels, valueLabel)
    end
end

---
-- 表示を更新します.
function ActorDetailBox:updateDisplay()
    ActorDetailBox.__super.updateDisplay(self)
    self:updateHeaderLabel()
    self:updateStatusLabel()
end

---
-- ヘッダーの表示を更新します.
function ActorDetailBox:updateHeaderLabel()
    if not self._actor then
        return
    end
    local a = self._actor
    local text = string.format("%s\nHP:%d/%d\nMP:%d/%d", a.name, a.hp, a.mhp, a.mp, a.mmp)
    self._headerLabel:setString(text)
end

---
-- ステータスラベルの表示を更新します.
function ActorDetailBox:updateStatusLabel()
    if not self._actor then
        return
    end
    local actor = self._actor
    self._statusValueLabels[1]:setString(tostring(actor.str))
    self._statusValueLabels[2]:setString(tostring(actor.vit))
    self._statusValueLabels[3]:setString(tostring(actor.int))
    self._statusValueLabels[4]:setString(tostring(actor.men))
    self._statusValueLabels[5]:setString(tostring(actor.spd))
end

---
-- 表示対象のアクターを設定します.
-- @param actor アクター
function ActorDetailBox:setActor(actor)
    self._actor = actor
    self:updateDisplay()
end


--------------------------------------------------------------------------------
-- @type ActorStatusBox
-- アクターの簡易的なステータスを表示するボックスです.
--------------------------------------------------------------------------------
ActorStatusBox = class(Panel)
M.ActorStatusBox = ActorStatusBox

---
-- コンストラクタ
-- @param params パラメータ
function ActorStatusBox:init(params)
    self._actor = params.actor
    params.size = {120, 140}

    ActorStatusBox.__super.init(self, params)
end

---
-- 子オブジェクトを生成します.
function ActorStatusBox:_createChildren()
    ActorStatusBox.__super._createChildren(self)

    self._faceImage = FaceImage(1)
    self._faceImage:setPos(5, 5)
    self:addChild(self._faceImage)

    self._hpNameLabel = Label("HP:", 40, 20, nil, 16)
    self._hpNameLabel:setPos(5, self._faceImage:getBottom())
    self._hpValueLabel = Label(self._actor.hp .. "/" .. self._actor.mhp, 100, 20, nil, 16)
    self._hpValueLabel:setPos(self._hpNameLabel:getRight(), self._hpNameLabel:getTop())

    self._mpNameLabel = Label("MP:", 40, 20, nil, 16)
    self._mpNameLabel:setPos(5, self._hpNameLabel:getBottom() - 2)
    self._mpValueLabel = Label(self._actor.hp .. "/" .. self._actor.mhp, 100, 20, nil, 16)
    self._mpValueLabel:setPos(self._hpNameLabel:getRight(), self._mpNameLabel:getTop())

    self:addChild(self._hpNameLabel)
    self:addChild(self._hpValueLabel)
    self:addChild(self._mpNameLabel)
    self:addChild(self._mpValueLabel)
end

---
-- 表示を更新します.
function ActorStatusBox:updateDisplay()
    ActorStatusBox.__super.updateDisplay(self)

    self._hpValueLabel:setString(self._actor.hp .. "/" .. self._actor.mhp)
    self._mpValueLabel:setString(self._actor.mp .. "/" .. self._actor.mmp)
end

---
-- 表示対象のアクターを設定します.
function ActorStatusBox:setActor(actor)
    self._actor = actor
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- @type ItemListBox
-- アイテムを表示するリストボックスです.
--------------------------------------------------------------------------------
ItemListBox = class(ListBox)
M.ItemListBox = ItemListBox

---
-- コンストラクタ
-- @param params パラメータ
function ItemListBox:init(params)
    params.listData = {repositry:getBagItems()}
    params.width = flower.viewWidth
    params.rowCount = 6
    params.labelField = "itemName"
    params.listItemFactory = ClassFactory(ItemListItem)

    ItemListBox.__super.init(self, params)
end

--------------------------------------------------------------------------------
-- @type ItemListItem
-- アイテム名とアイテム数をセットで表示するリストアイテムです.
--------------------------------------------------------------------------------
ItemListItem = class(ListItem)
M.ItemListItem = ItemListItem

ItemListItem._COUNT_LABEL_SUFFIX = "個"

---
-- コンストラクタ
-- @param params パラメータ
function ItemListItem:init(params)
    ItemListItem.__super.init(self, params)
end

---
-- 子オブジェクトを生成します.
function ItemListItem:_createChildren()
    ItemListItem.__super._createChildren(self)

    self._countLabel = Label("0")
    self:addChild(self._countLabel)
end

---
-- 表示を更新します.
function ItemListItem:updateDisplay()
    ItemListItem.__super.updateDisplay(self)

    local label = self._countLabel
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin
    self._textLabel:setSize(textWidth - 60, textHeight)
    label:setSize(60, textHeight)
    label:setPos(self._textLabel:getRight(), self._textLabel:getTop())
    label:setString(tostring(self:getItemCount()) .. ItemListItem._COUNT_LABEL_SUFFIX)
    label:setTextSize(self:getTextSize())
    label:setColor(self:getTextColor())
    label:setAlignment(TextAlign.right)
    label:setFont(self:getFont())
end

---
-- データを設定します.データ設定時、件数も更新します.
function ItemListItem:setData(data, dataIndex)
    ItemListItem.__super.setData(self, data, dataIndex)
    self._countLabel:setString(tostring(self:getItemCount()) .. ItemListItem._COUNT_LABEL_SUFFIX)
end

---
-- アイテム数を返します.
-- @return アイテム数
function ItemListItem:getItemCount()
    if self._data then
        return self._data.itemCount or 0
    end
    return 0
end

---
-- サイズ変更時にイベントハンドラです.
-- @param e Touch Event
function ItemListItem:onResize(e)
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- @type SkillListBox
-- アクターが保持するスキルを表示するリストボックスです.
--------------------------------------------------------------------------------
SkillListBox = class(ListBox)
M.SkillListBox = SkillListBox

---
-- コンストラクタ
-- @param params
function SkillListBox:init(params)
    local actor = params.actor
    params = params
    params.listData = {actor:getSkills()}
    params.width = WIDGET_WIDTH
    params.rowCount = 6
    params.labelField = "name"

    SkillListBox.__super.init(self, params)
end

---
-- アクターを設定します.
-- @param actor アクター
function SkillListBox:setActor(actor)
    self._actor = actor
    self:setListData(self._actor:getSkills())
end

--------------------------------------------------------------------------------
-- @type MemberListBox
-- プレイヤーメンバーを表示するリストボックスです.
--------------------------------------------------------------------------------
MemberListBox = class(ListBox)
M.MemberListBox = MemberListBox

---
-- コンストラクタ.
-- @param params パラメータ
function MemberListBox:init(params)
    params = params or {}
    params.listData = {repositry:getMembers()}
    params.width = 200
    params.rowCount = 3
    params.columnCount = 1
    params.labelField = "name"
    params.listItemFactory = ClassFactory(MemberListItem)

    MemberListBox.__super.init(self, params)
end

--------------------------------------------------------------------------------
-- @type MemberListItem
-- メンバーの名前とアイコンを表示するリストアイテムです.
--------------------------------------------------------------------------------
MemberListItem = class(ListItem)
M.MemberListItem = MemberListItem

---
-- コンストラクタ.
-- @param params パラメータ
function MemberListItem:init(params)
    MemberListItem.__super.init(self, params)
end

---
-- 子オブジェクトを生成します.
function MemberListItem:_createChildren()
    MemberListItem.__super._createChildren(self)

    self._actorImage = ActorImage("actor1.png") -- Dummy
    self._actorImage:setIndex(2)
    self:addChild(self._actorImage)
end

---
-- 表示を更新します.
function MemberListItem:updateDisplay()
    MemberListItem.__super.updateDisplay(self)
    
    local data = self._data or {id = 1}
    local xMin, yMin, xMax, yMax = self._backgroundImage:getContentRect()
    local textWidth, textHeight = xMax - xMin - self._actorImage:getWidth(), yMax - yMin

    self._actorImage:setTexture("actor" .. data.id .. ".png")
    self._actorImage:setPos(xMin, (self:getHeight() - self._actorImage:getHeight()) / 2)

    self._textLabel:setSize(textWidth - 60, textHeight)
    self._textLabel:setPos(self._actorImage:getRight() + 5, yMin)
end

---
-- データを設定します.データ設定時、表示全体を更新します.
function MemberListItem:setData(data, dataIndex)
    MemberListItem.__super.setData(self, data, dataIndex)
    self:updateDisplay()
end

---
-- サイズ変更時にイベントハンドラです.
-- @param e Touch Event
function MemberListItem:onResize(e)
    self:updateDisplay()
end

return M