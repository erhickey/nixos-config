import Data.Maybe (fromMaybe)
import XMonad
import XMonad.Actions.OnScreen (Focus(FocusCurrent), onScreen)
import XMonad.Actions.PhysicalScreens (getScreen, viewScreen)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.InsertPosition (Focus(Newer), Position(Below), insertPosition)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Hooks.ManageHelpers (doCenterFloat, isDialog)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Spacing (spacingWithEdge)
import qualified XMonad.StackSet as W
import XMonad.Util.Cursor (setDefaultCursor, xC_left_ptr)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Ungrab (unGrab)
import Graphics.X11.Xinerama (getScreenInfo)

workspaceOnScreen p w = do
    s <- getScreen def p
    windows $ onScreen (W.view w) FocusCurrent (fromMaybe 0 s)

numScreens :: X Int
numScreens = withDisplay $ io . fmap length . getScreenInfo

switchWorkspace ws = do
  n <- numScreens
  case n of
    2 -> do
      let screen = if ws == wsFour then 1 else 0
      workspaceOnScreen screen ws
      viewScreen def screen
    _ -> do
      windows $ W.view ws

wsOne = "1"
wsTwo = "2"
wsThree = "3"
wsFour = "4"

myWorkspaces = [wsOne, wsTwo, wsThree, wsFour]

myLayout = avoidStruts
    . wsOneLayout
    . wsTwoLayout
    . spacingWithEdge 6 $ tiled ||| Full
  where
    wsOneLayout = onWorkspace wsOne . spacingWithEdge 6 $ tiled ||| Full
    wsTwoLayout = onWorkspace wsTwo . spacingWithEdge 6 $ tiled ||| Full
    tiled = Tall mpNum ratioIncrement ratio
      where
        mpNum = 1 -- number of windows in master pane
        ratio = 1 / 2 -- proportion of screen occupied by master pane
        ratioIncrement = 3 / 100 -- percent of screen to increment by when resizing panes

myManageHook = insertPosition Below Newer <+> composeAll
  [ className =? "Gimp" --> doFloat
  , className =? "Pavucontrol" --> doCenterFloat
  , isDialog --> doCenterFloat
  ]

myStartupHook = do
  setDefaultCursor xC_left_ptr
  n <- numScreens
  case n of
    2 -> do
      workspaceOnScreen 1 wsFour
      workspaceOnScreen 0 wsOne
      viewScreen def 0
    _ -> do
      workspaceOnScreen 0 wsOne
      viewScreen def 0

-- key map creation details:
-- https://xmonad.github.io/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html#v:mkKeymap
myKeys =
  [ ("M-b", spawn "qutebrowser")
  , ("M-<Return>", spawn "st tmux")
  , ("M-s", unGrab *> spawn "maim -slDc 0.8,0.8,0.2,0.5 ~/tmp/$(date +%Y_%m_%d__%H_%M_%S_maim).png")
  , ("M-S-s", unGrab *> spawn "maim -slDc 0.8,0.8,0.2,0.5 | xclip -selection clipboard -t image/png")
  , ("M-p", spawn "dmenu_run -i -fn 'LiterationMono Nerd Font'")
  , ("M-g", spawn "google-chrome-stable")
  , ("<XF86AudioMute>", spawn "amixer -D pipewire set Master 1+ toggle")
  , ("<XF86AudioLowerVolume>", spawn "amixer -D pipewire set Master 5%- unmute")
  , ("<XF86AudioRaiseVolume>", spawn "amixer -D pipewire set Master 5%+ unmute")
  , ("<XF86AudioMicMute>", spawn "amixer -D pipewire set Capture toggle")
  , ("<XF86MonBrightnessDown>", spawn "light -U 5")
  , ("<XF86MonBrightnessUp>", spawn "light -A 5")
  , ("M-1", switchWorkspace wsOne)
  , ("M-2", switchWorkspace wsTwo)
  , ("M-3", switchWorkspace wsThree)
  , ("M-4", switchWorkspace wsFour)
  ]

myConfig = def
    { terminal = "st"
    , borderWidth = 0
    , focusFollowsMouse = False
    , manageHook = myManageHook
    , workspaces = myWorkspaces
    , layoutHook = myLayout
    , startupHook = myStartupHook
    }
    `additionalKeysP` myKeys

main = xmonad . docks . ewmh $ myConfig
