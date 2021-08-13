import std/times

type
  AllegroInfo* = object
    date*: DateTime
    version*: AllegroVersion
    release*: AllegroRelease
  AllegroVersion* = object
    major*: uint
    minor*: uint
    patch*: uint
  AllegroRelease* {.pure.} = enum
    git           = 0
    firstRelease  = 1
    hotfixes      = 2

{.push header: "<allegro5/base.h>"}
let allegroVersion {.importc: "ALLEGRO_VERSION".}: cint
let allegroSubVersion {.importc: "ALLEGRO_SUB_VERSION".}: cint
let allegroWipVersion {.importc: "ALLEGRO_WIP_VERSION".}: cint
let allegroDate {.importc: "ALLEGRO_DATE".}: cint
let allegroReleaseNumber {.importc: "ALLEGRO_RELEASE_NUMBER".}: cint
{.pop.}

proc newAllegroInfo*(): AllegroInfo =
  result = AllegroInfo()
  result.date = parse($allegroDate, "yyyyMMdd")
  result.version = AllegroVersion()
  result.version.major = allegroVersion.uint
  result.version.minor = allegroSubVersion.uint
  result.version.patch = allegroWipVersion.uint
  result.release = AllegroRelease(allegroReleaseNumber)
