# @file   : dwb_selective_tree.ps1
# @since  : 2025-08-31
# @author : David BLACK   GitHub @bballdave025
#
#   Usage, should work anywhere permissions are right:
#  
# PS> powershell -ExecutionPolicy Bypass -File `
#       .\dwb_selective_tree.ps1 -Path "." `
#         -ExcludeDirs @(
#              ".git", `
#              "dataset_preparation_examples", `
#              "experiment_environment_examples", `
#              "general_lab_notebooks_-_other_examples", `
#              "img"
#         )
#
#
#   If you have run
# PS> Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
#   or something similar, run with
# PS> dwb_selective_tree -Path "." `
#                        -IncludeDirs @(".git", "img")
#
#   You have to choose either -IncludeDirs or ExcludeDirs
#
#
#   A better option (for exclude) seems to be the Get-PSTree cmdlet
#   from the PowerShell Gallery
#
# #######  One-time (without permanent installation)  #######
# # Create a temporary folder to save the module
# PS> $tempModulePath = Join-Path -Path $env:TEMP -ChildPath "TempModule_$(Get-Random)"
# PS> New-Item -ItemType Directory -Path $tempModulePath | Out-Null
# # Save the Module 
# PS> Save-Module -Name PSTree -Path $tempModulePath -Force
# # Import the module from the temporary Path
# PS> Import-Module -Name PSTree -Scope Local -Global -ErrorAction Stop
#       # Note: `-Global` makes module available in current scope and 
#       #       is necessary for it to be accessible for the single use
# # Verify the module is loaded
# PS> Get-Module -Name PSTree
#
# #######  Install (make it available all the time)  #######
# PS> Install-Module PSTree -Scope CurrentUser # Only needed once
#
# #######  Run it (exclude example)  #######
# PS> Get-PSTree -Path "." `
#                -Exclude ".git", `
#                         "dataset_preparation_examples", `
#                         "experiment_environment_examples", `
#                         "general_lab_notebooks_-_other_examples", `
#                         "img"
# #######  Run it (include example)  #######
# PS> Get-PSTree -Path "." `
#                -Include "test_project_ps", `
#                         "test_project_bash"
#

param(
  [string]$Path,
  [array]$IncludeDirs, #  Directories to descend into, case insnstv
  [array]$ExcludeDirs, #  Directories not to descend into, case insnstv
  [int]$Level = 0, # The starting level (Why a parameter, i.e. why not always start 0?)
  [bool]$DoShowReport = $true, # number of directories and files
  [bool]$DoShowExcludedDirNames = $false, # matches with *NIX tree
  [bool]$DoTheDebug = $false # Dev stuff
)
  ##  Done-over-perfect -> Don't do  [int]$MaxLevel  for now.

$global:nDirsSeen  = 0
$global:nFilesSeen = 0

$global:DoTheShowExclDebug = $false

#  Here is code for include
function Get-IncludeTree {
  param(
    [string]$Path,
    [array]$IncludeDirs, #  Directories to descend into, case insnstv
    [int]$Level = 0, # The starting level (Why a parameter, i.e. why not always start 0?)
    [bool]$DoShowReport = $true, # number of directories and files
    [bool]$DoShowExcludedDirNames = $false, # matches with *NIX tree
    [bool]$DoTheDebug = $false # Dev stuff
  )
  
  if ($DoTheDebug) {
    Write-Host "DEBUG:-----------------------------------------------"
    Write-Host "DEBUG:"
    Write-Host "DEBUG: For Get-IncludeTree"
    Write-Host ""
  }
  
  if ($global:DoTheShowExclDebug) {
    Write-Host `
       "DEBUG: Include: DoShowExcludedDirNames: $DoShowExcludedDirNames"
  }
  
  $indent = "|   " * $Level
  
  ## Used different math below
  #if ($Level -gt 0) {
  #  $indent = "|   " * ($Level - 1) + "|-- " 
  #}
  
  $absPathRoot = (Get-Item $Path).FullName
  
  if ($DoTheDebug) {
    Write-Host "DEBUG:-----------------------------------------------"
    Write-Host "DEBUG:"
    Write-Host "DEBUG: Path:        $Path"
    Write-Host "DEBUG: Level:       $Level"
    Write-Host "DEBUG: indent:      '$indent'"
    Write-Host "DEBUG: absPathRoot: $absPathRoot"
    Write-Host ""
  }
  
  # Display the root directory for the tree
  if ($Level -eq 0) {
    Write-Host "'$Path' resolves to"
    Write-Host "$($indent)$absPathRoot\"
  }
  
  # Get sub-directories
  $childThings = Get-ChildItem -Path $absPathRoot | Sort-Object Name
  foreach ($thing in $childThings) {
    
    if ($DoTheDebug) {
      Write-Host "DEBUG:-----------------------------------------------"
      Write-Host "DEBUG:"
      Write-Host "DEBUG: thing: $thing"
      Write-Host "DEBUG: childThings:"
      Write-Host $childThings
      Write-Host ""
    }
    
    $childIsAFile = ( Test-Path -Path ( Join-Path $absPathRoot `
                                               -ChildPath $thing `
                                ) `
                                -PathType Leaf `
    )
    
    $childIsADir  = ( Test-Path -Path ( Join-Path $absPathRoot `
                                               -ChildPath $thing `
                                ) `
                                -PathType Container `
    )
    
    if ($DoTheDebug) {
      Write-Host "DEBUG:-----------------------------------------------"
      Write-Host "DEBUG:"
      Write-Host "DEBUG: childIsAFile: $childIsAFile"
      Write-Host "DEBUG: childIsADir:  $childIsADir"
      Write-Host ""
    }
    
    if ($childIsAFile) {
      $global:nFilesSeen = ($global:nFilesSeen + 1)
      
      $thisFile =     $thing.Name
      $thisFileFull = $thing.FullName
      
      if ($DoTheDebug) {
        Write-Host "DEBUG:-----------------------------------------------"
        Write-Host "DEBUG:"
        Write-Host "DEBUG: thisFile:     $thisFile"
        Write-Host "DEBUG: thisFileFull: $thisFileFull"
        Write-Host ""
      }
      
      #  File an dir names in one level need to be unique
      #+ Not optimizing, just doing before every output
      #+ e.g.
      #+ PS> echo what > abc
      #+ PS> mkdir abc
      #+ mkdir : An item with the specified name
      #+ ...
      #+ already exists
      #+ ...
      #+ and another e.g. with bash
      #+ $ mkdir abc
      #+ $ echo "Hi" > abc
      #+ -bash: abc: Is a directory
      $elementToTest = $thing
      $lastElement   = $childThings[-1]
      
      $thisIsLastElement = ($elementToTest -eq $lastElement)
      
      # The output for the tree-output
      if ($thisIsLastElement) {
        Write-Host "$($indent)``-- $($thisFile)"
      } else {
        Write-Host "$($indent)|-- $($thisFile)"
      }
      
      #before#Write-Host "$($indent)|---$($thisFile)"
    } elseif ($childIsADir) {
      $global:nDirsSeen = ($global:nDirsSeen + 1)
      
      $thisDir = $thing.Name
      $thisDirFull = $thing.FullName
      
      if ($DoTheDebug) {
        Write-Host "DEBUG:-----------------------------------------------"
        Write-Host "DEBUG:"
        Write-Host "DEBUG: thisDir:     $thisDir"
        Write-Host "DEBUG: thisDirFull: $thisDirFull"
        Write-Host "DEBUG: IncludeDirs:"
        Write-Host $IncludeDirs
        Write-Host ""
      }
      
      #  Check if the current directory is in the include list 
      #+ OR if we are already within an included path
      # This allows descending into subdirs of included dirs
      $dirIncluded = ($IncludeDirs -contains $thisDir)
      $withinIncludedPath = `
         ($IncludeDirs | Where-Object { $thisDirFull -like "*\$_*" })
              #  $withinIncludedPath returns the matching string from
              #+ $thisDirFull (which is $thisDir, AFAIK) if the match 
              #+ is found with one of the elements of the $IncludedDirs
              #+ A returned string is a truthy value ($true-thy value)
              #+ An empty string (no match) is a falsey value.
      
      
      if ($DoTheDebug) {
        Write-Host "DEBUG:-----------------------------------------------"
        Write-Host "DEBUG:"
        Write-Host "DEBUG: dirIncluded:        $dirIncluded"
        Write-Host "DEBUG: withinIncludedPath: $withinIncludedPath"
        Write-Host ""
      }
      
      if ($dirIncluded -or $withinIncludedPath) {
        if ($DoTheDebug) {
          Write-Host "DEBUG:-----------------------------------------------"
          Write-Host "DEBUG:"
          Write-Host "DEBUG: Recursive Parameters:"
          Write-Host "DEBUG: thisDirFull: $thisDirFull"
          Write-Host "DEBUG: IncludeDirs:"
          Write-Host $IncludeDirs
          Write-Host ""
        }
        
        #  File an dir names in one level need to be unique
        #+ Not optimizing, just doing before every output
        #+ e.g.
        #+ PS> echo what > abc
        #+ PS> mkdir abc
        #+ mkdir : An item with the specified name
        #+ ...
        #+ already exists
        #+ ...
        #+ and another e.g. with bash
        #+ $ mkdir abc
        #+ $ echo "Hi" > abc
        #+ -bash: abc: Is a directory
        $elementToTest = $thing
        $lastElement   = $childThings[-1]
        
        $thisIsLastElement = ($elementToTest -eq $lastElement)
        
        # The output for the tree-output
        if ($thisIsLastElement) {
          Write-Host "$($indent)``-- $($thisDir)/"
        } else {
          Write-Host "$($indent)|-- $($thisDir)/"
        }
        
        #before#Write-Host "$($indent)|---$($thisDir)\"
        
        Get-IncludeTree -Path $thisDirFull `
                        -IncludeDirs $IncludeDirs `
                        -Level ($Level + 1) `
                        -DoShowExcludedDirNames $DoShowExcludedDirNames `
                        -DoShowExclDebug $DoShowExclDebug `
                        -DoTheDebug $DoTheDebug
      } else {
        
        #  File an dir names in one level need to be unique
        #+ Not optimizing, just doing before every output
        #+ e.g.
        #+ PS> echo what > abc
        #+ PS> mkdir abc
        #+ mkdir : An item with the specified name
        #+ ...
        #+ already exists
        #+ ...
        #+ and another e.g. with bash
        #+ $ mkdir abc
        #+ $ echo "Hi" > abc
        #+ -bash: abc: Is a directory
        $elementToTest = $thing
        $lastElement   = $childThings[-1]
        
        $thisIsLastElement = ($elementToTest -eq $lastElement)
        
        # The output for the tree-output (if any)
        if ($global:DoTheShowExclDebug) {
          Write-Host `
    "DEBUG: Include->pre-if: DoShowExcludedDirNames: $DoShowExcludedDirNames"
        }
        
        if ($DoShowExcludedDirNames) {
          if ($global:DoShowExclDebug) {
            Write-Host "DEBUG: ============= in the show excl ============"
            Write-Host "DEBUG: thisIsLastElement: $thisIsLastElement"
          }
          # Display excluded directories without descending
          if ($thisIsLastElement) {
            Write-Host "$($indent)``-- $($thisDir)/ (excluded)"
          } else {
            Write-Host "$($indent)|-- $($thisDir)/ (excluded)"
          }
        }
        
        #before## Display excluded directories without descending
        #before#Write-Host "$($indent)|---$($thisDir)\ (excluded)"
      }
    } else {
      #  File an dir names in one level need to be unique
      #+ Not optimizing, just doing before every output
      #+ e.g.
      #+ PS> echo what > abc
      #+ PS> mkdir abc
      #+ mkdir : An item with the specified name
      #+ ...
      #+ already exists
      #+ ...
      #+ and another e.g. with bash
      #+ $ mkdir abc
      #+ $ echo "Hi" > abc
      #+ -bash: abc: Is a directory
      $elementToTest = $thing
      $lastElement   = $childThings[-1]
      
      $thisIsLastElement = ($elementToTest -eq $lastElement)
      
      # The output for the tree-output
      if ($thisIsLastElement) {
        Write-Host `
           "$($indent)``-- $($thing.Name)(?) (has a problem; not file nor dir)"
      } else {
        Write-Host `
           "$($indent)|-- $($thing.Name)(?) (has a problem; not file nor dir)"
      }
      
      #before#Write-Host `
      #before#   "$($indent)|---$($thing.Name)(?) (has a problem; not file nor dir)"
    }
  }
}


#  Here is code for exclude
function Get-ExcludeTree {
  param(
    [string]$Path,
    [array]$ExcludeDirs, #  Directories not to descend into, case insnstv
    [int]$Level = 0, # The starting level (Why a parameter, i.e. why not always start 0?)
    [bool]$DoShowReport = $true, # number of directories and files
    [bool]$DoShowExcludedDirNames = $false, # matches with *NIX tree
    [bool]$DoTheDebug = $false # Dev stuff
  )
  
  if ($DoTheDebug) {
    Write-Host "DEBUG:-----------------------------------------------"
    Write-Host "DEBUG:"
    Write-Host "DEBUG: For Get-ExcludeTree"
    Write-Host ""
  }
  
  if ($DoTheDebug) {
    Write-Host `
       "DEBUG: Exclude: DoShowExcludedDirNames: $DoShowExcludedDirNames"
  }
  
  $indent = "|   " * $Level
  
  $absPathRoot = (Get-Item $Path).FullName
  
  if ($DoTheDebug) {
    Write-Host "DEBUG:-----------------------------------------------"
    Write-Host "DEBUG:"
    Write-Host "DEBUG: Path:        $Path"
    Write-Host "DEBUG: Level:       $Level"
    Write-Host "DEBUG: indent:      '$indent'"
    Write-Host "DEBUG: absPathRoot: $absPathRoot"
    Write-Host ""
  }

  # Display the root directory for the tree
  if ($Level -eq 0) {
    Write-Host "'$Path' resolves to"
    Write-Host "$($indent)$absPathRoot\"
  }
  
  # Get sub-directories
  $childThings = Get-ChildItem -Path $absPathRoot | Sort-Object Name
  foreach ($thing in $childThings) {
    
    if ($DoTheDebug) {
      Write-Host "DEBUG:-----------------------------------------------"
      Write-Host "DEBUG:"
      Write-Host "DEBUG: thing: $thing"
      Write-Host "DEBUG: childThings:"
      Write-Host $childThings
      Write-Host ""
    }
    
    $childIsAFile = ( Test-Path -Path ( Join-Path $absPathRoot `
                                               -ChildPath $thing `
                                ) `
                                -PathType Leaf `
    )
    
    $childIsADir  = ( Test-Path -Path ( Join-Path $absPathRoot `
                                               -ChildPath $thing `
                                ) `
                                -PathType Container `
    )
    
    if ($DoTheDebug) {
      Write-Host "DEBUG:-----------------------------------------------"
      Write-Host "DEBUG:"
      Write-Host "DEBUG: childIsAFile: $childIsAFile"
      Write-Host "DEBUG: childIsADir:  $childIsADir"
      Write-Host ""
    }
    
    if ($childIsAFile) {
      $global:nFilesSeen = ($global:nFilesSeen + 1)
      
      $thisFile =     $thing.Name
      $thisFileFull = $thing.FullName
      
      if ($DoTheDebug) {
        Write-Host "DEBUG:-----------------------------------------------"
        Write-Host "DEBUG:"
        Write-Host "DEBUG: thisFile:     $thisFile"
        Write-Host "DEBUG: thisFileFull: $thisFileFull"
        Write-Host ""
      }
      
      #  File an dir names in one level need to be unique
      #+ Not optimizing, just doing before every output
      #+ e.g.
      #+ PS> echo what > abc
      #+ PS> mkdir abc
      #+ mkdir : An item with the specified name
      #+ ...
      #+ already exists
      #+ ...
      #+ and another e.g. with bash
      #+ $ mkdir abc
      #+ $ echo "Hi" > abc
      #+ -bash: abc: Is a directory
      $elementToTest = $thing
      $lastElement   = $childThings[-1]
      
      $thisIsLastElement = ($elementToTest -eq $lastElement)
      
      # The output for the tree-output
      if ($thisIsLastElement) {
        Write-Host "$($indent)``-- $($thisFile)"
      } else {
        Write-Host "$($indent)|-- $($thisFile)"
      }
    } elseif ($childIsADir) {
      $global:nDirsSeen = ($global:nDirsSeen + 1)
      
      $thisDir = $thing.Name
      $thisDirFull = $thing.FullName
      
      if ($DoTheDebug) {
        Write-Host "DEBUG:-----------------------------------------------"
        Write-Host "DEBUG:"
        Write-Host "DEBUG: thisDir:     $thisDir"
        Write-Host "DEBUG: thisDirFull: $thisDirFull"
        Write-Host "DEBUG: ExcludeDirs:"
        Write-Host $ExcludeDirs
        Write-Host ""
      }
      
      #  Check if the current directory is not in the exclude list 
      #+ (I don't think the "OR" will matter, but will keep until I test
      ###+ OR if we are already within an included path
      ### This allows descending into subdirs of included dirs
      $dirIncluded = (! ($ExcludeDirs -contains $thisDir))
      $withinExcludedPath = `
         ($ExcludeDirs | Where-Object { $thisDirFull -like "*\$_*" })
              #  $withinExcludedPath returns ??????
              
              #+ With the $withinIncludedPath, 'twas the matching string
              #+ from $thisDirFull (which is $thisDir, AFAIK) if the match 
              #+ is found with one of the elements of the $IncludedDirs
              #+ A returned string is a truthy value ($true-thy value)
              #+ An empty string (no match) is a falsey value.
      
      if ($DoTheDebug) {
        Write-Host "DEBUG:-----------------------------------------------"
        Write-Host "DEBUG:"
        Write-Host "DEBUG: dirIncluded:        $dirIncluded"
        Write-Host "DEBUG: withinExcludedPath: $withinIncludedPath"
        Write-Host ""
      }
      
      #if ($dirIncluded -or $withinIncludedPath) #I think no need 2nd
      if ($dirIncluded) {
        if ($DoTheDebug) {
          Write-Host "DEBUG:-----------------------------------------------"
          Write-Host "DEBUG:"
          Write-Host "DEBUG: Recursive Parameters:"
          Write-Host "DEBUG: thisDirFull: $thisDirFull"
          Write-Host "DEBUG: ExcludeDirs:"
          Write-Host $ExcludeDirs
          Write-Host ""
        }
        
        #  File an dir names in one level need to be unique
        #+ Not optimizing, just doing before every output
        #+ e.g.
        #+ PS> echo what > abc
        #+ PS> mkdir abc
        #+ mkdir : An item with the specified name
        #+ ...
        #+ already exists
        #+ ...
        #+ and another e.g. with bash
        #+ $ mkdir abc
        #+ $ echo "Hi" > abc
        #+ -bash: abc: Is a directory
        $elementToTest = $thing
        $lastElement   = $childThings[-1]
        
        $thisIsLastElement = ($elementToTest -eq $lastElement)
        
        # The output for the tree-output
        if ($thisIsLastElement) {
          Write-Host "$($indent)``-- $($thisDir)/"
        } else {
          Write-Host "$($indent)|-- $($thisDir)/"
        }
        
        #before#Write-Host "$($indent)|---$($thisDir)\"
        
        Get-ExcludeTree -Path $thisDirFull `
                        -ExcludeDirs $ExcludeDirs `
                        -Level ($Level + 1) `
                        -DoShowExcludedDirNames $DoShowExcludedDirNames `
                        -DoShowExclDebug $DoShowExclDebug `
                        -DoTheDebug $DoTheDebug
      } else {
        
        #  File an dir names in one level need to be unique
        #+ Not optimizing, just doing before every output
        #+ e.g.
        #+ PS> echo what > abc
        #+ PS> mkdir abc
        #+ mkdir : An item with the specified name
        #+ ...
        #+ already exists
        #+ ...
        #+ and another e.g. with bash
        #+ $ mkdir abc
        #+ $ echo "Hi" > abc
        #+ -bash: abc: Is a directory
        $elementToTest = $thing
        $lastElement   = $childThings[-1]
        
        $thisIsLastElement = ($elementToTest -eq $lastElement)
        
        # The output for the tree-output (if any)
        
        if ($DoShowExcludedDirNames) {
          if ($global:DoShowExclDebug) {
            Write-Host "DEBUG: ============= in the show excl ============"
            Write-Host "DEBUG: thisIsLastElement$thisIsLastElement"
          }
          # Display excluded directories without descending
          if ($thisIsLastElement) {
            Write-Host "$($indent)``-- $($thisDir)/ (excluded)"
          } else {
            Write-Host "$($indent)|-- $($thisDir)/ (excluded)"
          }
        }
        
        #before## Display excluded directories without descending
        #before#Write-Host "$($indent)|---$($thisDir)\ (excluded)"
      }
    } else {
      
      #  File an dir names in one level need to be unique
      #+ Not optimizing, just doing before every output
      #+ e.g.
      #+ PS> echo what > abc
      #+ PS> mkdir abc
      #+ mkdir : An item with the specified name
      #+ ...
      #+ already exists
      #+ ...
      #+ and another e.g. with bash
      #+ $ mkdir abc
      #+ $ echo "Hi" > abc
      #+ -bash: abc: Is a directory
      $elementToTest = $thing
      $lastElement   = $childThings[-1]
      
      $thisIsLastElement = ($elementToTest -eq $lastElement)
      
      # The output for the tree-output
      if ($thisIsLastElement) {
        Write-Host `
           "$($indent)``-- $($thing.Name)(?) (has a problem; not file nor dir)"
      } else {
        Write-Host `
           "$($indent)|-- $($thing.Name)(?) (has a problem; not file nor dir)"
      }
      
      #before#Write-Host `
      #before#   "$($indent)|---$($thing.Name)(?) (has a problem; not file nor dir)"
    }
  }
}


#  Here is code for all
function Get-AllTree {
  param(
    [string]$Path,
    [int]$Level = 0, # The starting level (Why a parameter, i.e. why not always start 0?)
    [bool]$DoShowReport = $true, # number of directories and files
    [bool]$DoTheDebug = $false # Dev stuff
  )
  
  if ($DoTheDebug) {
    Write-Host "DEBUG:-----------------------------------------------"
    Write-Host "DEBUG:"
    Write-Host "DEBUG: For Get-IncludeTree"
    Write-Host ""
  }
  
  $indent = "|   " * $Level
  
  $absPathRoot = (Get-Item $Path).FullName
  
  if ($DoTheDebug) {
    Write-Host "DEBUG:-----------------------------------------------"
    Write-Host "DEBUG:"
    Write-Host "DEBUG: Path:        $Path"
    Write-Host "DEBUG: Level:       $Level"
    Write-Host "DEBUG: indent:      '$indent'"
    Write-Host "DEBUG: absPathRoot: $absPathRoot"
    Write-Host ""
  }
  
  # Display the root directory for the tree
  if ($Level -eq 0) {
    Write-Host "'$Path' resolves to"
    Write-Host "$($indent)$absPathRoot\"
  }
  
  # Get sub-directories
  $childThings = Get-ChildItem -Path $absPathRoot | Sort-Object Name
  foreach ($thing in $childThings) {
    
    if ($DoTheDebug) {
      Write-Host "DEBUG:-----------------------------------------------"
      Write-Host "DEBUG:"
      Write-Host "DEBUG: thing: $thing"
      Write-Host "DEBUG: childThings:"
      Write-Host $childThings
      Write-Host ""
    }
    
    $childIsAFile = ( Test-Path -Path ( Join-Path $absPathRoot `
                                               -ChildPath $thing `
                                ) `
                                -PathType Leaf `
    )
    
    $childIsADir  = ( Test-Path -Path ( Join-Path $absPathRoot `
                                               -ChildPath $thing `
                                ) `
                                -PathType Container `
    )
    
    if ($DoTheDebug) {
      Write-Host "DEBUG:-----------------------------------------------"
      Write-Host "DEBUG:"
      Write-Host "DEBUG: childIsAFile: $childIsAFile"
      Write-Host "DEBUG: childIsADir:  $childIsADir"
      Write-Host ""
    }
    
    if ($childIsAFile) {
      $global:nFilesSeen = ($global:nFilesSeen + 1)
      
      $thisFile =     $thing.Name
      $thisFileFull = $thing.FullName
      
      if ($DoTheDebug) {
        Write-Host "DEBUG:-----------------------------------------------"
        Write-Host "DEBUG:"
        Write-Host "DEBUG: thisFile:     $thisFile"
        Write-Host "DEBUG: thisFileFull: $thisFileFull"
        Write-Host ""
      }
      
      #  File an dir names in one level need to be unique
      #+ Not optimizing, just doing before every output
      #+ e.g.
      #+ PS> echo what > abc
      #+ PS> mkdir abc
      #+ mkdir : An item with the specified name
      #+ ...
      #+ already exists
      #+ ...
      #+ and another e.g. with bash
      #+ $ mkdir abc
      #+ $ echo "Hi" > abc
      #+ -bash: abc: Is a directory
      $elementToTest = $thing
      $lastElement   = $childThings[-1]
      
      $thisIsLastElement = ($elementToTest -eq $lastElement)
      
      # The output for the tree-output
      if ($thisIsLastElement) {
        Write-Host "$($indent)``-- $($thisFile)"
      } else {
        Write-Host "$($indent)|-- $($thisFile)"
      }
      
      #before#Write-Host "$($indent)|---$($thisFile)"
    } elseif ($childIsADir) {
      $global:nDirsSeen = ($global:nDirsSeen + 1)
      
      $thisDir = $thing.Name
      $thisDirFull = $thing.FullName
      
      if ($DoTheDebug) {
        Write-Host "DEBUG:-----------------------------------------------"
        Write-Host "DEBUG:"
        Write-Host "DEBUG: thisDir:     $thisDir"
        Write-Host "DEBUG: thisDirFull: $thisDirFull"
        Write-Host "DEBUG: IncludeDirs: $IncludeDirs"
        Write-Host ""
      }
      
      #  File an dir names in one level need to be unique
      #+ Not optimizing, just doing before every output
      #+ e.g.
      #+ PS> echo what > abc
      #+ PS> mkdir abc
      #+ mkdir : An item with the specified name
      #+ ...
      #+ already exists
      #+ ...
      #+ and another e.g. with bash
      #+ $ mkdir abc
      #+ $ echo "Hi" > abc
      #+ -bash: abc: Is a directory
      $elementToTest = $thing
      $lastElement   = $childThings[-1]
      
      $thisIsLastElement = ($elementToTest -eq $lastElement)
      
      # The output for the tree-output
      if ($thisIsLastElement) {
        Write-Host "$($indent)``-- $($thisDir)/"
      } else {
        Write-Host "$($indent)|-- $($thisDir)/"
      }
        
      #before#Write-Host "$($indent)|---$($thisDir)\"
        
      Get-AllTree -Path $thisDirFull `
                  -Level ($Level + 1) `
                  -DoTheDebug $DoTheDebug
    } else {
      
      #  File an dir names in one level need to be unique
      #+ Not optimizing, just doing before every output
      #+ e.g.
      #+ PS> echo what > abc
      #+ PS> mkdir abc
      #+ mkdir : An item with the specified name
      #+ ...
      #+ already exists
      #+ ...
      #+ and another e.g. with bash
      #+ $ mkdir abc
      #+ $ echo "Hi" > abc
      #+ -bash: abc: Is a directory
      $elementToTest = $thing
      $lastElement   = $childThings[-1]
      
      $thisIsLastElement = ($elementToTest -eq $lastElement)
      
      # The output for the tree-output
      if ($thisIsLastElement) {
        Write-Host `
           "$($indent)``-- $($thing.Name)(?) (has a problem; not file nor dir)"
      } else {
        Write-Host `
           "$($indent)|-- $($thing.Name)(?) (has a problem; not file nor dir)"
      }
      
      #before#Write-Host `
      #before#   "$($indent)|---$($thing.Name)(?) (has a problem; not file nor dir)"
    }
  }
}


#  Here is commented code for changing an "include" to an "exclude"
#+ Options of Get-ChildItem made this unnecessary
#exclude#function Get-SelectiveTree {
#exclude#
#exclude#  $indent = "    " * $Level
#exclude#  
#exclude#  $absPathRoot = (Get-Item $Path).FullName
#exclude#
#exclude#  # Display the root directory for the tree
#exclude#  Write-Host "'$Path' resolves to"
#exclude#  Write-Host "$($indent)$absPathRoot\"
#exclude#  
#exclude#  # Get sub-directories
#exclude#  $childDirs = Get-ChildItem -Path $Path -Directory | Sort-Object Name
#exclude#  foreach ($dir in $childDirs) {
#exclude#    #  Check if the current directory isn't in the exclude list 
#exclude#    #+ OR if we are not already within an excluded path
#exclude#    # This allows descending into subdirs of included dirs
#exclude#    $dirNotExcluded = (! $ExcludeDirs -contains $dir.Name)
#exclude#    $not_within_excluded_path
#exclude#    if (! $ExcludeDirs -contains $dir.Name -or ! $ExcludeDirs | `
#exclude#          Where-Object {  $dir.FullName -like "*\$_*" }) {
#exclude#      Get-SelectiveTree -Path $dir.FullName `
#exclude#                        -IncludeDirs $IncludeDirs `
#exclude#                        -Level ($Level + 1)
#exclude#    } else {
#exclude#      # Display excluded directories without descending
#exclude#      Write-Host "$($indent)    $($dir.Name)\ (excluded)"
#exclude#    }
#exclude#  }


##  Here is code for exclude, again commented out. It didn't look
##+ anything like 'tree' output.
#function Get-ExcludeTree {
#  $absPathRoot = (Get-Item $Path).FullName 
#  Get-ChildItem -Path $absPathRoot -Recurse | Where-Object { $_.FullName -notin $ExcludeDirs } | Format-List FullName, Mode
#}


$pathIsSet = ($Path -ne $null)
$includeIsNotEmpty = (! $IncludeDirs.Count -eq 0)
$excludeIsNotEmpty = (! $ExcludeDirs.Count -eq 0)
$bothEmpty = (! $includeIsNotEmpty -and ! $excludeIsNotEmpty)
$onlyOneNotEmpty = (($includeIsNotEmpty -and ! $excludeIsNotEmpty) -or `
                    ($excludeIsNotEmpty -and ! $includeIsNotEmpty))
  
$quickUsageStr = @'
  Usage:   
PS> dwb_selective_tree.ps1 `
       -Path PATH_STRING`
      (-IncludeDirs INCLUDE_ARRAY | -ExcludeDirs EXCLUDE_ARRAY | <nothing>)
      [-Level MIN_LEVEL]
  
  PATH_STRING is required,
  Either INCLUDE_ARRAY or EXCLUDE ARRAY is can be used, but can''t 
    use both. Using neither will give the whole tree.
  MIN_LEVEL is optional and not suggested. It sets the starting level.
  
  Examples:
  
PS> powershell -ExecutionPolicy Bypass -File `
       .\dwb_selective_tree.ps1 -Path "." `
         -ExcludeDirs @(
              ".git", `
              "dataset_preparation_examples", `
              "experiment_environment_examples", `
              "general_lab_notebooks_-_other_examples", `
              "img"
         )

# ( Equivalent to
# PS> Get-PSTree -Path "." -Exclude ".git","dataset_preparation_examples", `
# "experiment_environment_examples","general_lab_notebooks_-_other_examples",`
# "img"
# )


   If you are able to change the system setting by running
PS> Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
    or something similar, then you can run with
PS> dwb_selective_tree -Path "." `
                       -IncludeDirs @("test_project_ps", `
                                      "test_project_bash")
  
# ( Equivalent to
# PS> Get-PSTree -Path "." `
#                -Include "test_project_ps", `
#                         "test_project_bash"
# )
  
  You might also consider installing the Get-PSTree cmdlet from the 
  PowerShell Gallery and just using the equivalent calls.
'@

if ($global:DoTheShowExclDebug) {
  Write-Host `
    "DEBUG: Initial: DoShowExcludedDirNames: $DoShowExcludedDirNames"
}

if (! $pathIsSet -or ! ($onlyOneNotEmpty -or $bothEmpty)) {
  Write-Error -Category InvalidArgument -Message "Problem with input call."
  if (! $pathIsSet) {
    Write-Error -Category InvalidArgument `
     -Message "No path was given, i.e. '-Path PATH_STRING' not used."
  }
  if (! ($onlyOneNotEmpty -or $bothEmpty)) {
    Write-Error -Category InvalidArgument -Message @'
You must use either ''-IncludeDirs INCLUDE_ARRAY'' or
''-ExcludeDirs EXCLUDE_ARRAY'', or neither, but not both.
'@
  }
  
  Write-Error -Category NotSpecified -Message "$quickUsageStr"
  
} else {
  if ( $bothEmpty) {
    Get-AllTree -Path $Path `
                -Level ($Level) `
                -DoTheDebug $DoTheDebug
    
    if ($DoShowReport) {
      Write-Host ""
      Write-Host "$($global:nDirsSeen) directories, $($global:nFilesSeen) files"
      Write-Host "(Not counting children of excluded or hidden directories,"
      Write-Host "not including hidden directories, & not including the root)."
      Write-Host ""
    }
  } elseif ( $includeIsNotEmpty ) {
    Get-IncludeTree -Path $Path `
                    -IncludeDirs $IncludeDirs `
                    -Level ($Level) `
                    -DoShowExcludedDirNames $DoShowExcludedDirNames `
                    -DoShowExclDebug $DoShowExclDebug `
                    -DoTheDebug $DoTheDebug
    
    if ($DoShowReport) {
      Write-Host ""
      Write-Host "$($global:nDirsSeen) directories, $($global:nFilesSeen) files"
      Write-Host "(Not counting children of excluded or hidden directories,"
      Write-Host "including hidden directories, & not including the root)."
      Write-Host ""
    }
  } elseif ( $excludeIsNotEmpty ) {
    Get-ExcludeTree -Path $Path `
                    -ExcludeDirs $ExcludeDirs `
                    -Level ($Level) `
                    -DoShowExcludedDirNames $DoShowExcludedDirNames `
                    -DoShowExclDebug $DoShowExclDebug `
                    -DoTheDebug $DoTheDebug
    
    if ($DoShowReport) {
      Write-Host ""
      Write-Host "$($global:nDirsSeen) directories, $($global:nFilesSeen) files"
      Write-Host "(Not counting children of excluded or hidden directories,"
      Write-Host "not including hidden directories, & not including the root)."
      Write-Host ""
    }
  } else {
    Write-Error -Category NotSpecified -Message @'
Something wrong happened. You shouldn''t have gotten here.
The condition that either zero or one-and-only-one of the 
include (x)or exclude options must be set should already 
have been tested, yet neither ''$includeIsNotEmpty'' nor 
''$excludeIsNotEmpty'' is True. Tant pis.
'@
  }
}



###-------------------------------------------------------------------
##  Testing stuff, since I have it. Uncomment everything. something
##+ like a 's/^[#]//g'
##+
##+ If there's no comment, it almost certainly worked as expected.
##+ All comments on what worked are from a test 2025-08-31
#
## the whole tree
#.\dwb_selective_tree.ps1 -Path "."
#
#
############################################################
#
#
## some, not others
#.\dwb_selective_tree.ps1 -Path "." `
#         -ExcludeDirs @(
#              ".git",
#              "experiment_environment_examples",
#              "general_lab_notebooks_-_other_examples"
#         )
#
#
## only img/ missing
#.\dwb_selective_tree.ps1 -Path "." `
#         -ExcludeDirs @(
#              "img"
#         )
#
#
## should give none (i.e. no directories expanded, only see files)
#.\dwb_selective_tree.ps1 -Path "." `
#         -ExcludeDirs @(
#              ".git",
#              "dataset_preparation_examples",
#              "experiment_environment_examples",
#              "general_lab_notebooks_-_other_examples",
#              "img"
#         )
#
#
##  will this work and give us all? Yes, but I think it's calling
##+ TreeAll, and thus not working for the right reasons (coincidence)
#.\dwb_selective_tree.ps1 -Path "." `
#         -ExcludeDirs @()
#
#
#############################################################
#
#
## should give all
#.\dwb_selective_tree.ps1 -Path "." `
#         -IncludeDirs @(
#              ".git",
#              "dataset_preparation_examples",
#              "experiment_environment_examples",
#              "general_lab_notebooks_-_other_examples",
#              "img"
#         )
#
#
##  see if it can give us our '.git/' directory contents
##+ nope, we don't get to see hidden dirs with this script
#.\dwb_selective_tree.ps1 -Path "." `
#         -IncludeDirs @(
#              ".git"
#         )
#
#
## just the stuff in img/
#.\dwb_selective_tree.ps1 -Path "." `
#         -IncludeDirs @(
#              "img"
#         )
#
#
##  will this work and give us none? I doubt it. I think it will
##+ see two empty arrays and go to TreeAll. Yep it gave everything
##+ instead of the nothing that this command seems to ask.
#.\dwb_selective_tree.ps1 -Path "." `
#         -IncludeDirs @()
#
#
## some, not others
#.\dwb_selective_tree.ps1 -Path "." `
#         -IncludeDirs @(
#              ".git",
#              "experiment_environment_examples",
#              "general_lab_notebooks_-_other_examples"
#         )
#
