import std/options

import private/library

type
  AllegroPath* = ptr object

{.push header: "<allegro5/path.h>"}
let allegroNativePathSeparator {.importc: "ALLEGRO_NATIVE_PATH_SEP".}: cchar
{.pop.}

{.push importc, dynlib: library.allegro.}
proc al_create_path(str: cstring): AllegroPath
proc al_create_path_for_directory(str: cstring): AllegroPath
proc al_clone_path(path: AllegroPath): AllegroPath

proc al_get_path_num_components(path: AllegroPath): cint
proc al_get_path_component(path: AllegroPath, i: cint): cstring
proc al_replace_path_component(path: AllegroPath, i: cint, s: cstring): void
proc al_remove_path_component(path: AllegroPath, i: cint): void
proc al_insert_path_component(path: AllegroPath, i: cint, s: cstring): void
proc al_get_path_tail(path: AllegroPath): cstring
proc al_drop_path_tail(path: AllegroPath): void
proc al_append_path_component(path: AllegroPath, s: cstring): void
proc al_join_paths(path: AllegroPath, tail: AllegroPath): bool
proc al_rebase_path(path: AllegroPath, tail: AllegroPath): bool
proc al_path_cstr(path: AllegroPath, delim: cchar): cstring
proc al_destroy_path(path: AllegroPath): void

proc al_set_path_drive(path: AllegroPath, drive: cstring): void
proc al_get_path_drive(path: AllegroPath): cstring

proc al_set_path_filename(path: AllegroPath, filename: cstring): void
proc al_get_path_filename(path: AllegroPath): cstring

proc al_get_path_extension(path: AllegroPath): cstring
proc al_set_path_extension(path: AllegroPath, extension: cstring): bool
proc al_get_path_basename(path: AllegroPath): cstring

proc al_make_path_canonical(path: AllegroPath): bool
{.pop.}

proc newAllegroPath*(): AllegroPath =
  ## Create a path structure from a string. The last component, if it is
  ## followed by a directory separator and is neither "." nor "..", is
  ## treated as the last directory name in the path. Otherwise the last
  ## component is treated as the filename. 
  return al_create_path(nil)

proc newAllegroPath*(str: string): AllegroPath =
  ## Create a path structure from a string. The last component, if it is
  ## followed by a directory separator and is neither "." nor "..", is
  ## treated as the last directory name in the path. Otherwise the last
  ## component is treated as the filename. 
  return al_create_path(str)

proc newAllegroPathForDirectory*(str: string): AllegroPath =
  ## This is the same as newAllegroPath, but interprets the passed string
  ## as a directory path. The filename component of the returned path will
  ## always be empty.
  return al_create_path_for_directory(str)

proc clone*(path: AllegroPath): AllegroPath =
  ## Clones an AllegroPath structure
  return al_clone_path(path)

proc numComponents*(path: AllegroPath): int32 =
  ## Return the number of directory components in a path.
  ## 
  ## The directory components do not include the final part of a path
  ## (the filename).
  return al_get_path_num_components(path)

proc component*(path: AllegroPath, index: int32): string =
  ## Return the i'th directory component of a path, counting from zero.
  ## If the index is negative then count from the right, i.e. -1 refers
  ## to the last path component. It is an error to pass an index which
  ## is out of bounds.
  return $al_get_path_component(path, index)

proc replaceComponent*(path: AllegroPath, index: int32, component: string): void =
  ## Replace the i'th directory component by another string. If the
  ## index is negative then count from the right, i.e. -1 refers to
  ## the last path component. It is an error to pass an index which
  ## is out of bounds.
  al_replace_path_component(path, index, component)

proc removeComponent*(path: AllegroPath, index: int32): void =
  ## Delete the i'th directory component. If the index is negative
  ## then count from the right, i.e. -1 refers to the last path
  ## component. It is an error to pass an index which is out of bounds.
  al_remove_path_component(path, index)

proc insertComponent*(path: AllegroPath, index: int32, component: string): void =
  ## Insert a directory component at index i. If the index is negative
  ## then count from the right, i.e. -1 refers to the last path component.
  al_insert_path_component(path, index, component)

proc tail*(path: AllegroPath): Option[string] =
  ## Returns the last directory component, or none if there are no
  ## directory components.
  let value = al_get_path_tail(path)
  if value.isNil:
    return none(string)
  return some($value)

proc dropTail*(path: AllegroPath): void =
  ## Remove the last directory component, if any.
  al_drop_path_tail(path)

proc appendComponent*(path: AllegroPath, component: string): void =
  ## Append a directory component.
  al_append_path_component(path, component)

proc join*(path: AllegroPath, tail: AllegroPath): void =
  ## Concatenate two path structures. The first path structure is modified.
  ## If 'tail' is an absolute path, this function does nothing.
  ## 
  ## If 'tail' is a relative path, all of its directory components will be
  ## appended to 'path'. tail's filename will also overwrite pat''s filename,
  ## even if it is just the empty string.
  ## 
  ## Tail's drive is ignored.
  discard al_join_paths(path, tail)

proc rebase*(path: AllegroPath, tail: AllegroPath): void =
  ## Concatenate two path structures, modifying the second path structure.
  ## If tail is an absolute path, this function does nothing. Otherwise,
  ## the drive and path components in head are inserted at the start of tail.
  ## 
  ## For example, if head is "/anchor/" and tail is "data/file.ext", then
  ## after the call tail becomes "/anchor/data/file.ext".
  discard al_rebase_path(path, tail)

proc `$`*(path: AllegroPath): string =
  ## Convert a path to its string representation, i.e. optional drive.
  return $al_path_cstr(path, allegroNativePathSeparator)

proc `$`*(path: AllegroPath, delim: char): string =
  ## Convert a path to its string representation, i.e. optional drive,
  ## followed by directory components separated by 'delim', followed
  ## by an optional filename.
  return $al_path_cstr(path, delim)

proc free*(path: AllegroPath): void =
  ## Free a path structure.
  al_destroy_path(path)

proc drive*(path: AllegroPath, drive: string): void =
  ## Set the drive string on a path.
  al_set_path_drive(path, drive)

proc drive*(path: AllegroPath): string =
  ## Return the drive letter on a path, or the empty string if there is none.
  ## 
  ## The "drive letter" is only used on Windows, and is usually a string like
  ## "c:", but may be something like "\\Computer Name" in the case of UNC
  ## (Uniform Naming Convention) syntax.
  return $al_get_path_drive(path)

proc filename*(path: AllegroPath, filename: string): void =
  ## Set the optional filename part of the path.
  al_set_path_filename(path, filename)

proc filename*(path: AllegroPath): string =
  ## Return the filename part of the path, or the empty string if there is none.
  return $al_get_path_filename(path)

proc extension*(path: AllegroPath): string =
  ## Return a pointer to the start of the extension of the filename, i.e.
  ## everything from the final dot ('.') character onwards. If no dot exists,
  ## returns an empty string.
  return $al_get_path_extension(path)

proc extension*(path: AllegroPath, extension: string): void =
  ## Replaces the extension of the path with the given one, i.e. replaces
  ## everything from the final dot ('.') character onwards, including the dot.
  ## If the filename of the path has no extension, the given one is appended.
  ## Usually the new extension you supply should include a leading dot.
  discard al_set_path_extension(path, extension)

proc basename*(path: AllegroPath): string =
  ## Return the basename, i.e. filename with the extension removed. If the
  ## filename doesn't have an extension, the whole filename is the basename.
  ## If there is no filename part then the empty string is returned.
  return $al_get_path_basename(path)

proc canonical*(path: AllegroPath): void =
  ## Removes any leading '..' directory components in absolute paths.
  ## Removes all '.' directory components.
  ## 
  ## Note that this does not collapse "x/../y" sections into "y".
  ## This is by design. If "/foo" on your system is a symlink to "/bar/baz",
  ## then "/foo/../quux" is actually "/bar/quux", not "/quux" as a naive
  ## removal of ".." components would give you.
  discard al_make_path_canonical(path)
