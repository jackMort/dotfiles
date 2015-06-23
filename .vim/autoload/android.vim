function! android#logi(msg)
  redraw
  echomsg "vim-android: " . a:msg
endfunction

function! android#logw(msg)
  echohl warningmsg
  echo "vim-android: " . a:msg
  echohl normal
endfunction

function! android#loge(msg)
  echohl errormsg
  echo "vim-android: " . a:msg
  echohl normal
endfunction

""
" Simple heuristic that tries to find the location for the AndroidManifest.xml
" file.
"
" If the g:android_manifest is set then use it as location for the manifest.
"
" If the current opened buffer is the AndroidManifest.xml file and
" if it is then return its absolute path.
"
" Finally try to find the manifest using the findfile function of vim that looks
" recursively inside the current path.
function! android#findManifest()

  if exists('g:android_manifest')
    return g:android_manifest
  endif

  if(expand('%:t') == 'AndroidManifest.xml')
    let g:android_manifest = expand('%:p')
    return g:android_manifest
  endif

  let old_wildignore = &wildignore
  set wildignore+=*/build/*
  let g:android_manifest = findfile("AndroidManifest.xml")
  let &wildignore = old_wildignore
  return g:android_manifest
endfunction

function! android#isAndroidProject()
  return filereadable(android#findManifest())
endfunction

function! android#checkAndroidHome()
  if exists("g:android_sdk_path") && finddir(g:android_sdk_path) != ""
    let $ANDROID_HOME=g:android_sdk_path
  elseif exists("$ANDROID_HOME") && finddir($ANDROID_HOME) != ""
    let g:android_sdk_path = $ANDROID_HOME
  else
    call android#loge("Could not find android SDK. Ensure the g:android_sdk_path variable or ANDROID_HOME env variable are set and correct.")
    return 0
  endif
  return 1
endfunction

""
" Appends ctags for all referenced libraries used for the Android project. The
" library list is obtained from the project.properties file.
function! android#updateLibraryTags()
  " TODO: Implement this method
endfunction

""
" Create a tags file inside the g:android_sdk_tags folder that includes tags for
" the current project source, the target android sdk source, all library
" dependencies, all xml resource files, etc.
function! android#updateAndroidTags()

  if !executable("ctags")
    call android#logw("updateAndroidTags() failed: ctags tool not found.")
    return 0
  endif

  let l:android_sources = substitute(copy($SRCPATH), ":", " ", "g")
  let l:ctags_cmd = 'ctags --recurse --fields=+l --langdef=XML --langmap=Java:.java,XML:.xml --languages=Java,XML --regex-XML=/id="([a-zA-Z0-9_]+)"/\1/d,definition/  -f '

  if exists("*mkdir")
    let l:basepath = fnamemodify(g:android_sdk_tags, ":h")
    silent! mkdir(l:basepath, "p")
  endif

  if finddir(l:basepath) == ""
    call android#loge("Tags folder " . l:basepath . " does not exists. Create the path or change your g:android_sdk_tags variable to a path that exists.")
    return
  endif

  let l:cmd = l:ctags_cmd . g:android_sdk_tags . " " . l:android_sources

  "if exists('g:loaded_dispatch')
  ""  silent! exe 'Start!' l:cmd
  "else
    call android#logi("Generating android SDK tags (may take a while to finish)" )
    call system(l:cmd)
    call android#logi("  Done!" )
  "endif
endfunction

" Try to determine the project package name by reading the AndroidManifest.xml
" file. Returns a string containing the package name or throws and exception if
" not found.
function! android#packageName()
  if ! exists("s:androidPackageName")
    for line in readfile(android#findManifest())
      if line =~ 'package='
        let s:androidPackageName = matchstr(line, '\cpackage=\([''"]\)\zs.\{-}\ze\1')
        if empty("s:androidPackageName")
          throw "Unable to get package name"
        endif
      endif
    endfor
  endif
  return s:androidPackageName
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" High level methods

function! android#clean()

  call gradle#setCompiler()

  if(!gradle#isCompilerSet())
    call android#logw("Android compiler not set")
    return
  endif

  let l:result = s:compile("clean")

  if(l:result == 0)
    call android#logi("Finished cleaning project")
  else
    call android#logw("Cleaning failed")
  endif
endfunction

function! android#test()

  call gradle#setCompiler()

  if(!gradle#isCompilerSet())
    call android#logw("Android compiler not set")
    return
  endif

  let l:result = s:compile("test")

  if(l:result == 0)
    call android#logi("Finished testing project")
  else
    call android#logw("Errors during testing project")
  endif
endfunction

function! android#compile(...)

  call gradle#setCompiler()

  if(!gradle#isCompilerSet())
    throw "Android compiler not set"
  endif

  if(a:0 == 0)
    let l:mode = "build"
    let l:result = gradle#run(l:mode)
  elseif(a:0 == 1 && a:1 == "debug")
    let l:mode = 'assemble' . android#capitalize(a:1)
    let l:result = gradle#run(l:mode)
  elseif(a:0 == 0 && a:1 == "release")
    let l:mode = 'assemble' . android#capitalize(a:1)
    let l:result = gradle#run(l:mode)
  else
    let l:result = call("gradle#run", a:000)
  endif

  if(l:result == 0)
    call android#logi("Building finished successfully")
  else
    call android#loge("Building finished with " . l:result . " errors")
  endif
endfunction

function! android#install(mode)

  call gradle#setCompiler()

  if(!gradle#isCompilerSet())
    call android#logw("Android compiler not set")
    return
  endif

  if(!filereadable(android#getApkPath(a:mode)))
    call android#compile(a:mode)
    return
  endif

  if(!filereadable(android#getApkPath(a:mode)))
    call android#logw("Android apk file " . android#getApkPath(a:mode) . " not found")
    return
  endif

  let l:mode = a:mode
  let l:devices = adb#devices()

  " If no device found give a warning an exit
  if len(l:devices) == 0
    call android#logw("No android device/emulator found. Skipping install step.")
    return 0
  endif

  " If only one device is found automatically install to it.
  if len(l:devices) == 1
    let l:device = strpart(l:devices[0], 3)
    return adb#install(l:device, a:mode)
  endif

  " If more than one device is found give a list so the user can choose.
  let l:choice = -1

  let l:devices = ["0. All Devices"] + l:devices

  "call add(l:devices, (len(l:devices) + 1) . ". All devices")
  while(l:choice < 0 || l:choice > len(l:devices))
    echom "Select target device"
    call inputsave()
    let l:choice = inputlist(l:devices)
    call inputrestore()
    echo "\n"
  endwhile

  echomsg l:choice

  if l:choice == "0"
    call android#logi("Installing on all devices... (May take some time)")
    call remove(l:devices, 0) " Remove All Devices option
    for device in l:devices
      let l:device = strpart(device, 3)
      let l:result = adb#install(l:device, a:mode)
      if l:result != 0
        call android#logw("Abort installation of all devices")
        return 1
      endif
    endfor
    call android#logi ("Finished installing on the following devices " . join(l:devices, " "))
  else
    let l:option = l:devices[l:choice]
    let l:device = strpart(l:option, 3)
    call android#logi("Installing on " . l:device . " ...")
    let l:res = adb#install(l:device, a:mode)

    if(!l:res)
      call android#logi("Finished installing on " . l:device)
    endif
  endif
endfunction

function! android#uninstall()

  call gradle#setCompiler()

  if(!gradle#isCompilerSet())
    call android#logw("No android compiler set.")
    return
  endif

  let l:devices = adb#devices()

  " If no device found give a warning an exit
  if len(l:devices) == 0
    call android#logw("No android device/emulator found. Skipping uninstall.")
    return 0
  endif

  " If only one device is found automatically uninstall app from it.
  if len(l:devices) == 1
    let l:device = strpart(l:devices[0], 3)
    call adb#uninstall(l:device)
    call android#logi("Finished uninstalling from device " . l:device)
    return 0
  endif

  " If more than one device is found give a list so the user can choose.
  let l:choice = -1
  let l:devices = ["0. All Devices"] + l:devices
  while(l:choice < 0 || l:choice > len(l:devices))
    echom "Select target device"
    call inputsave()
    let l:choice = inputlist(l:devices)
    call inputrestore()
    echo "\n"
  endwhile

  if l:choice == 0
    call android#logi("Uninstalling from all devices...")
    call remove(l:devices, 0)
    for device in l:devices
      let l:device = strpart(device, 3)
      call adb#uninstall(l:device)
    endfor
    call android#logi ("Finished uninstalling from the following devices " . join(l:devices, " "))
  else
    let l:option = l:devices[l:choice]
    let l:device = strpart(l:option, 3)
    call adb#uninstall(l:device)
    call android#logi ("Finished uninstalling from device " . l:device)
  endif
endfunction

""
" Add the android sdk ctags file to the local tags. This assumes the android
" tags file is located at '~/.vim/tags/android' by default or the value set on
" the g:android_sdk_tags variable if defined.
function! android#setAndroidSdkTags()
  if !exists('g:android_sdk_tags')
    let g:android_sdk_tags = getcwd() . '/.tags'
  endif
  execute 'silent! setlocal ' . 'tags+=' . g:android_sdk_tags
endfunction

function! android#setClassPath()
  call classpath#setClassPath()
endfunction

""
" Try to find out the project name. The resulting apk files will have this name
" as prefix so we need it to install the apk on the devices/emulators.
"
function! android#getProjectName()
  if filereadable('build.xml')
    " If there is a build.xml file (ant build) we can get the project name from
    " it.
    for line in readfile('build.xml')
      if line =~ "project name"
        let s:androidProjectName = matchstr(line, '\cproject name=\([''"]\)\zs.\{-}\ze\1')
      endif
    endfor
  else
    " If there is no build.xml file (gradle build) we use the current directory
    " name as project name.
    "
    " TODO: Using the folder name as project name is not reliable. In gradle
    " 1.11 it is possible to set a different project name in the settings.gradle
    " file. We must add a check here to find that file and if exists then
    " extract the project name from it.
    let s:androidProjectName = fnamemodify(".",":p:h:t")
  endif
  return s:androidProjectName
endfunction

function! android#getApkPath(mode)
  let s:androidApkFile = android#getProjectName() . "-" . a:mode . ".apk"
  let old_wildignore = &wildignore
  let &wildignore = ""
  let s:androidApkPath = findfile(s:androidApkFile, ".**")
  let &wildignore = old_wildignore
  return s:androidApkPath
endfunction

function! android#listDevices()
  let l:devices = adb#devices()
  if len(l:devices) <= 0
    call android#logw("Could not find any android devices or emulators.")
  else
    call android#logi("Android Devices: " . join(l:devices, " "))
  endif
endfunction

" Upcase the first leter of string.
function! android#capitalize(str)
  return substitute(a:str, '\(^.\)', '\u&', 'g')
endfunction

""
" Function that tries to determine the location of the android binary.
function! android#bin()

  if exists('g:android_tool')
    return g:android_tool
  endif

  let g:android_tool = g:android_sdk_path . "/tools/android"

  if(!executable(g:android_tool))
    if executable("android")
      let g:android_tool = "android"
    else
      throw "Unable to find android tool binary. Ensure you set g:android_sdk_path correctly."
    endif
  endif

  return g:android_tool

endfunction

""
" Find android emulator binary
function! android#emulatorbin()

  if exists('g:android_emulator')
    return g:android_emulator
  endif

  let g:android_emulator = g:android_sdk_path . "/tools/emulator"

  if(!executable(g:android_emulator))
    if executable("emulator")
      let g:android_emulator = "emulator"
    else
      throw "Unable to find android emulator binary. Ensure you set g:android_sdk_path correctly."
    endif
  endif

  return g:android_emulator
endfunction

""
" List AVD emulators
function! android#avds()

  let l:avd_output = system(android#bin() . " list avd")
  let l:avd_devices = filter(split(l:avd_output, '\n'), 'v:val =~ "Name: "')
  let l:avd = map(l:avd_devices, 'v:key . ". " . substitute(v:val, "Name: ", "", "")')

  "call android#logi(len(l:devices) . "  Devices " . join(l:devices, " || "))

  return l:avd
endfunction

function! android#emulator()

  let l:avds = android#avds()

  " There are no avds defined
  if len(l:avds) == 0
    call android#logw("No android emulator defined")
    return 0
  endif

  " If only one device is found automatically install to it.
  if len(l:avds) == 1
    let l:avd = strpart(l:avds[0], 3)
    execute 'silent !' . android#emulatorbin() . " -avd " . l:avd . " &> /dev/null &"
    redraw!
  endif

  " If more than one emulator avd is found give a list so the user can choose.
  let l:choice = -1

  while(l:choice < 0 || l:choice >= len(l:avds))
    echom "Select target device"
    call inputsave()
    let l:choice = inputlist(l:avds)
    call inputrestore()
    echo "\n"
  endwhile

  echomsg l:choice

  let l:option = l:avds[l:choice]
  let l:avd = strpart(l:option, 3)

  execute 'silent !' . android#emulatorbin() . " -avd " . l:avd . " &> /dev/null &"
  redraw!

endfunction

function! android#setupAndroidCommands()
  command! -nargs=+ Gradle call android#compile(<f-args>)
  command! -nargs=+ Android call android#compile(<f-args>)
  command! -nargs=? AndroidBuild call android#compile(<f-args>)
  command! -nargs=1 AndroidInstall call android#install(<f-args>)
  command! AndroidClean call android#clean()
  command! AndroidTest call android#test()
  command! AndroidUninstall call android#uninstall()
  command! AndroidUpdateTags call android#updateAndroidTags()
  command! AndroidDevices call android#listDevices()
  command! AndroidEmulator call android#emulator()
endfunction
