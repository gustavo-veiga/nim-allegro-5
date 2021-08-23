type
  AllegroException* = object of Defect

  AllegroInstallException* = object of AllegroException
  AllegroInstallFontException* = object of AllegroInstallException
  AllegroInstallMouseException* = object of AllegroInstallException
  AllegroInstallAudioException* = object of AllegroInstallException
  AllegroInstallAcodecException* = object of AllegroInstallException
  AllegroInstallSystemException* = object of AllegroInstallException
  AllegroInstallTtfFontException* = object of AllegroInstallException
  AllegroInstallJoystickException* = object of AllegroInstallException
  AllegroInstallKeyboardException* = object of AllegroInstallException
  
