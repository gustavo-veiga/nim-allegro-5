import private/library

{.push importc, dynlib: library.allegro.}
proc al_get_cpu_count(): cint
proc al_get_ram_size(): cint
{.pop.}

proc cpuCount*(): uint =
  ## Returns the number of CPU cores that the system Allegro is running on has and which
  ## could be detected, or a negative number if detection failed. Even if a positive
  ## number is returned, it might be that it is not correct. For example, Allegro
  ## running on a virtual machine will return the amount of CPU’s of the VM, and not
  ## that of the underlying system.
  ## 
  ## Furthermore even if the number is correct, this only gives you information about the
  ## total CPU cores of the system Allegro runs on. The amount of cores available to your
  ## program may be less due to circumstances such as programs that are currently running.
  ## 
  ## Therefore, it's best to use this for advisory purposes only. It is certainly a bad
  ## idea to make your program exclusive to systems for which this function returns a
  ## certain "desirable" number.
  return al_get_cpu_count().uint

proc ramSize*(): uint =
  ## Returns the size in MB of the random access memory that the system Allegro is
  ## running on has and which could be detected, or a negative number if detection
  ## failed. Even if a positive number is returned, it might be that it is not correct.
  ## For example, Allegro running on a virtual machine will return the amount of RAM
  ## of the VM, and not that of the underlying system.
  ## 
  ## Furthermore even if the number is correct, this only gives you information about
  ## the total physical memory of the system Allegro runs on. The memory available to
  ## your program may be less or more than what this function returns due to
  ## circumstances such as virtual memory, and other programs that are currently running.
  ## 
  ## Therefore, it's best to use this for advisory purposes only. It is certainly a bad
  ## idea to make your program exclusive to systems for which this function returns a
  ## certain "desirable" number.
  return al_get_ram_size().uint
