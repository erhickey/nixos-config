import XMonad
  ( Full(Full), Tall(Tall), borderWidth, className, composeAll, def, doFloat, focusFollowsMouse
  , layoutHook , manageHook, spawn , startupHook, terminal, workspaces, xmonad, (-->), (=?), (|||), (<+>)
  )
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.InsertPosition (Focus(Newer), Position(Below), insertPosition)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Hooks.ManageHelpers (doCenterFloat, isDialog)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Spacing (spacingWithEdge)
import XMonad.Util.Cursor (setDefaultCursor, xC_left_ptr)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Ungrab (unGrab)

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

myStartupHook = setDefaultCursor xC_left_ptr

myConfig = def
    { terminal = "st"
    , borderWidth = 0
    , focusFollowsMouse = False
    , manageHook = myManageHook
    , workspaces = myWorkspaces
    , layoutHook = myLayout
    , startupHook = myStartupHook
    }
    `additionalKeysP`
    -- key map creation details:
    -- https://xmonad.github.io/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html#v:mkKeymap
    [ ("M-b", spawn "qutebrowser")
    , ("M-<Return>", spawn "st tmux")
    , ("M-s", unGrab *> spawn "maim -slDc 0.8,0.8,0.2,0.5 ~/tmp/$(date +%Y_%m_%d__%H_%M_%S_maim).png")
    , ("M-S-s", unGrab *> spawn "maim -slDc 0.8,0.8,0.2,0.5 | xclip -selection clipboard -t image/png")
    , ("M-p", spawn "dmenu_run -i -fn 'LiterationMono Nerd Font'")
    ]

main = xmonad . docks . ewmh $ myConfig
