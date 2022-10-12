# Utilities
Miscellaneous Utilities, mainly written in Autohotkey 

## AddSubtitleTag.ahk
To add html tags to sub-title lines in a .srt file to change font size, color, etc.  For example:

   &ensp;&thinsp;setting Prefix to `<font face="Helvetica" size="80" color="#FFFFFF">`
   
   &ensp;&thinsp;and Suffix to `</font>`
   
   will change all sub-title lines to:
   
   &ensp;&thinsp;`<font face="Helvetica" size="80" color="#FFFFFF">line of the subtitle</font>`
   
This is also useful when using Handbrake to embed sub-titles into a video file. (You may need to upgrade Handbrake to the latest version.)  
