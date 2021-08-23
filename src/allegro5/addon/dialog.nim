import std/sequtils

import allegro5/private/library
import allegro5/[event_source, bitmap, display]

type
  AllegroFileChooser* = ptr object
  AllegroTextLog* = ptr object
  AllegroMenu* = ptr object
  AllegroMenuInfo* = object
    caption*: cstring
    id*: cushort
    flags*: cint
    icon*: AllegroBitmap
  AllegroFileChooserFlag* {.pure.} = enum
    fileMustExist = 1
    save          = 2
    folder        = 4
    pictures      = 8
    showHiden     = 16
    multiple      = 32
  AllegroMessageboxFlag* {.pure.} = enum
    warn            = 1 shl 0
    error           = 1 shl 1
    okCancel        = 1 shl 2
    yesNo           = 1 shl 3
    questiom        = 1 shl 4
  AllegroTextLogFlag* {.pure.} = enum
    noClose         = 1 shl 0
    monospace       = 1 shl 1
  AllegroDialogEvent* {.pure.} = enum
    nativeDialogClose = 600
    menuClick         = 601
  AllegroMenuItemFlag* {.pure.} = enum
    enabled            = 0
    checkbox           = 1
    checked            = 2
    disabled           = 4
  AllegroMessageboxReturn* {.pure.} = enum
    none    = 0
    yesOrOk = 1
    cancel  = 2

{.push importc, dynlib: library.dialogAddon.}
proc al_init_native_dialog_addon(): bool
proc al_is_native_dialog_addon_initialized(): bool
proc al_shutdown_native_dialog_addon(): void

proc al_create_native_file_dialog(initial_path, title, patterns: cstring, mode: cint): AllegroFileChooser
proc al_show_native_file_dialog(display: AllegroDisplay, dialog: AllegroFileChooser): bool
proc al_get_native_file_dialog_count(dialog: AllegroFileChooser): cint
proc al_get_native_file_dialog_path(dialog: AllegroFileChooser, index: csize_t): cstring
proc al_destroy_native_file_dialog(dialog: AllegroFileChooser): void

proc al_show_native_message_box(display: AllegroDisplay, title, heading, text, buttons: cstring, flags: cint): cint

proc al_open_native_text_log(title: cstring, flags: cint): AllegroTextLog
proc al_close_native_text_log(textlog: AllegroTextLog): void
proc al_append_native_text_log(textlog: AllegroTextLog, format: cstring): void {.varargs.}
proc al_get_native_text_log_event_source(textlog: AllegroTextLog): AllegroEventSource

proc al_create_menu(): AllegroMenu
proc al_create_popup_menu(): AllegroMenu

#[ displaying menus ]#
proc al_get_display_menu(display: AllegroDisplay): AllegroMenu
proc al_set_display_menu(display: AllegroDisplay, popup: AllegroMenu): bool
proc al_popup_menu(popup: AllegroMenu, display: AllegroDisplay): bool
proc al_remove_display_menu(display: AllegroDisplay): AllegroMenu
{.pop.}

proc installAllegroDialogAddon*(): void =
  discard al_init_native_dialog_addon()

proc isDialogAddonInitialized*(): bool =
  return al_is_native_dialog_addon_initialized()

proc shutdownDialogAddon*(): void =
  al_shutdown_native_dialog_addon()

#############################
#    ALLEGRO FILECHOOSER    #
#############################

proc newAllegroFileChooser*(initialPath, title, pattern: string, mode: varargs[AllegroFileChooserFlag]): AllegroFileChooser =
  let flag = mode.mapIt(it.cint).foldl(a or b)
  return al_create_native_file_dialog(initialPath, title, pattern, flag)

proc newAllegroFileChooser*(title: string, patterns: string, mode: varargs[AllegroFileChooserFlag]): AllegroFileChooser =
  let flag = mode.mapIt(it.cint).foldl(a or b)
  return al_create_native_file_dialog(nil, title, patterns, flag)

proc showFileChooser*(display: AllegroDisplay, dialog: AllegroFileChooser): void =
  discard al_show_native_file_dialog(display, dialog)

proc count*(dialog: AllegroFileChooser): int =
  return al_get_native_file_dialog_count(dialog)

proc path*(dialog: AllegroFileChooser, index: uint): string =
  return $al_get_native_file_dialog_path(dialog, index.csize_t)

proc free*(dialog: AllegroFileChooser): void =
  al_destroy_native_file_dialog(dialog)

#############################
#      ALLEGRO TEXTLOG      #
#############################

proc showMessageBox*(display: AllegroDisplay, title, header, text: string, flags: AllegroMessageboxFlag): AllegroMessageboxReturn =
  return AllegroMessageboxReturn(al_show_native_message_box(display, title, header, text, nil, flags.cint))

proc showMessageBox*(title, header, text: string, flags: varargs[AllegroMessageboxFlag]): AllegroMessageboxReturn =
  let flagInt = flags.mapIt(it.cint).foldl(a or b)
  return AllegroMessageboxReturn(al_show_native_message_box(nil, title, header, text, nil, flagInt))

proc newAllegroTextLog*(title: string, flags: varargs[AllegroTextLogFlag]): AllegroTextLog =
  let flagInt = flags.mapIt(it.cint).foldl(a or b)
  return al_open_native_text_log(title, flagInt)

proc close*(textlog: AllegroTextLog): void =
  al_close_native_text_log(textlog)

proc append*(textlog: AllegroTextLog, format: string): void =
  al_append_native_text_log(textlog, format)

proc eventSource*(textlog: AllegroTextLog): AllegroEventSource =
  return al_get_native_text_log_event_source(textlog)

##############################
#        ALLEGRO MENU        #
##############################

proc newAllegroMenu*(): AllegroMenu =
  return al_create_menu()

proc newAllegroPopupMenu*(): AllegroMenu =
  return al_create_popup_menu()

proc menu*(display: AllegroDisplay, popup: AllegroMenu): void =
  discard al_set_display_menu(display, popup)
