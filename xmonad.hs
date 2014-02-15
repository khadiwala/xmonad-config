import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.PerWorkspace
import XMonad.Layout.NoBorders
import XMonad.Layout.Groups.Wmii
import XMonad.Layout.Groups.Helpers
import XMonad.Hooks.SetWMName
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Prompt.Man
import XMonad.Prompt.RunOrRaise
import Data.Ratio ((%))

myManageHook::ManageHook
myManageHook = composeAll
    [ appName =? "xfrun4"        -->doIgnore
    , appName =? "Xfce4-notifyd" -->doIgnore
    , manageDocks
    ]

myKeys = [ ("M-p", spawn "dmenu_run") 
	     , ("M-f", toggleGroupFull)
         , ("M-c", groupToNextLayout)
         , ("M-; M-c", swapGroupDown)
         , ("M-r", zoomGroupReset)
         , ("M-i", splitGroup)
         --, ("M-S-d", moveToGroupUp True)
         --, ("M-S-f", moveToGroupDown True)
         --, ("M-s", zoomGroupOut)
         --, ("M-g", zoomGroupIn)
         --, ("M-d", focusGroupUp)
         --, ("M-f", focusGroupDown)
         , ("M-; M-h", zoomGroupOut)
         , ("M-; M-l", zoomGroupIn)
         , ("M-; M-k", focusGroupUp)
         , ("M-; M-j", focusGroupDown)
         , ("M-; M-S-k", moveToGroupUp True)
         , ("M-; M-S-j", moveToGroupDown True)
         , ("M-j", focusDown)
         , ("M-k", focusUp)
         , ("M-S-j", swapDown)
         , ("M-S-k", swapUp)
         , ("M-g", windowPromptGoto defaultXPConfig)
         , ("M-b", windowPromptBring defaultXPConfig)
         , ("M-m", manPrompt defaultXPConfig)
         , ("M-x", runOrRaisePrompt defaultXPConfig)
         ]

myWorkspaces = ["1:ecl","2","3:chat","4:email","5","6","7","8,","9"]

myLayoutHook = onWorkspace "1:ecl" wmiiFull$ 
               onWorkspace "2" wmiiFull$
               onWorkspace "3:chat" imLayout$ 
               onWorkspace "4:email" wmiiFull$ 
               stdLayout
    where
        stdLayout = avoidStruts $ layoutHook defaultConfig
        imLayout = avoidStruts $ withIM (1%8) (ClassName "Pidgin") (Tall 1 0.03 0.5) ||| Full
        --dishes = avoidStruts (drawer `onTop` (Tall 1 0.03 0.5) ||| Full)
	    --drawer = simpleDrawer 0.01 0.3 (ClassName "Pidgin")
        wmiiFull = avoidStruts $ wmii shrinkText defaultTheme ||| Full

 
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { manageHook = myManageHook <+> manageHook defaultConfig
        , layoutHook = myLayoutHook
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
        , modMask    = mod4Mask
        , terminal   = "sakura" 
        , workspaces = myWorkspaces
        , startupHook = setWMName "LG3D"
        } `additionalKeysP` myKeys
