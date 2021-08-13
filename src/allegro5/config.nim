import std/[os, options, tables], private/library

type
  AllegroConfig* = ptr object
  AllegroConfigEntry = ptr object
  AllegroConfigSection = ptr object

{.push dynlib: library.name.}
proc alCreateConfig(): AllegroConfig {.importc: "al_create_config".}
proc alLoadConfigFile(filename: cstring): AllegroConfig {.importc: "al_load_config_file".}
proc alDestroyConfig(config: AllegroConfig): void {.importc: "al_destroy_config".}

proc alSaveConfigFile(filename: cstring, config: AllegroConfig): bool {.importc: "al_save_config_file".}

proc alAddConfigSection(config: AllegroConfig, name: cstring): void {.importc: "al_add_config_section".}
proc alRemoveConfigSection(config: AllegroConfig, section: cstring): bool {.importc: "al_remove_config_section".}
proc alAddConfigComment(config: AllegroConfig, section, comment: cstring): void {.importc: "al_add_config_comment".}

proc alGetConfigValue(config: AllegroConfig, section, key: cstring): cstring {.importc: "al_get_config_value".}
proc alSetConfigValue(config: AllegroConfig, section, key, value: cstring): void {.importc: "al_set_config_value".}
proc alRemoveConfigKey(config: AllegroConfig, section, key: cstring): bool {.importc: "al_remove_config_key".}

proc alGetFirstConfigSection(config: AllegroConfig, configSection: ref AllegroConfigSection): cstring {.importc: "al_get_first_config_section".}
proc alGetNextConfigSection(configSection: ref AllegroConfigSection): cstring {.importc: "al_get_next_config_section".}

proc alGetFirstConfigEntry(config: AllegroConfig, section: cstring, configEntry: ref AllegroConfigEntry): cstring {.importc: "al_get_first_config_entry".}
proc alGetNextConfigEntry(configEntry: ref AllegroConfigEntry): cstring {.importc: "al_get_next_config_entry".}

proc alMergeConfig(cfg1, cfg2: AllegroConfig): AllegroConfig {.importc: "al_merge_config".}
proc alMergeConfigInto(master, add: AllegroConfig): void {.importc: "al_merge_config_into".}
{.pop.}

#[
  Create an empty configuration structure.
]#
proc newAllegroConfig*(): AllegroConfig =
  return alCreateConfig()

#[
  Read a configuration file from disk or create an empty.
]#
proc newAllegroConfig*(filename: string): AllegroConfig =
  if os.fileExists filename:
    return alLoadConfigFile(filename)
  return alCreateConfig()

#[
  Free the resources used by a configuration structure.
]#
proc free*(config: AllegroConfig): void =
  alDestroyConfig(config)

#[
  Write out a configuration file to disk.
]#
proc save*(config: AllegroConfig, filename: string): void =
  discard alSaveConfigFile(filename, config)

#[
  Add a section to a configuration structure with the given name.
  If the section already exists then nothing happens.
]#
proc addSection*(config: AllegroConfig, name: string): void =
  alAddConfigSection(config, name)

#[
  Remove a section of a configuration.
]#
proc removeSection*(config: AllegroConfig, section: string): void =
  discard alRemoveConfigSection(config, section)

#[
  Add a comment in a section of a configuration. If the section doesn’t yet exist, it will be created. The section can be "" for the global section.
  The comment may or may not begin with a hash character. Any newlines in the comment string will be replaced by space characters.
]#
proc addComment*(config: AllegroConfig, section, comment: string): void =
  alAddConfigComment(config, section, comment)

#[]#
proc getValue*(config: AllegroConfig, section, key: string): Option[string] =
  var value = alGetConfigValue(config, section, key)
  if value.isNil:
    return none(string)
  return some($value)

#[
  Set a value in a section of a configuration. If the section doesn’t yet exist, it will be created.
  If a value already existed for the given key, it will be overwritten. The section can be "" for the global section.
  For consistency with the on-disk format of config files, any leading and trailing whitespace will be stripped from the value.
  If you have significant whitespace you wish to preserve, you should add your own quote characters and remove them when reading the values back in.
]#
proc setValue*(config: AllegroConfig, section, key, value: string): void =
  alSetConfigValue(config, section, key, value)

#[
  Remove a key and its associated value in a section of a configuration.
]#
proc removeKey*(config: AllegroConfig, section, key: string): void =
  discard alRemoveConfigKey(config, section, key)

#[
  Merge one configuration structure into another.
  Values in configuration ‘add’ override those in ‘master’.
  ‘master’ is modified. Comments from ‘add’ are not retained.
]#
proc merger*(master, add: AllegroConfig): void =
  alMergeConfigInto(master, add)


#[
  Merge two configuration structures, and return the result as a new configuration.
  Values in configuration ‘cfg2’ override those in ‘cfg1’.
  Neither of the input configuration structures are modified.
  Comments from ‘cfg2’ are not retained.
]#
proc `+`*(cfg1, cfg2: AllegroConfig): AllegroConfig =
  alMergeConfig(cfg1, cfg2)

#[]#
iterator sections*(config: AllegroConfig): string =
  var section = new AllegroConfigSection
  var sectionName = alGetFirstConfigSection(config, section)
  while not sectionName.isNil:
    yield $sectionName
    sectionName = alGetNextConfigSection(section)

#[]#
iterator entries*(config: AllegroConfig, section: string): string =
  var entry = new AllegroConfigEntry
  var entryName = alGetFirstConfigEntry(config, section, entry)
  while not entryName.isNil:
    yield $entryName
    entryName = alGetNextConfigEntry(entry)

#[]#
proc `[]`*(config: AllegroConfig, section: string): TableRef[string, string] =
  var values = newTable[string, string]()
  for entry in config.entries(section):
    values[entry] = config.getValue(section, entry).get()
  return values
