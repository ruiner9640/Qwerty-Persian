# Qwerty-Persian
AutoHotkey Script to turn your Persian (Farsi) keyboard into a more phonetic keyboard with true qwerty layout

#Note that this uses "standard Persian (Farsi)" keyboard layout by default as that is the usual secondary keyboard for Iranians,
If you want to use this for the default Persian (Farsi) keyboard change the "global g_persianLayoutId :=" from 0xF03A0429 to 0x04290429

#If you want to run this at windows start press Win + R type shell:startup and paste the script or the .exe file's shortcut there

Worked on this for a couple of hours, I thought it turned out pretty well

I reused some of the logic of another script I made for 9key keyboard layouts

Persian having a bunch of letters that made the same sound like four "z" letters made it hard to make an actual qwerty keyboard layout for it

Now all the duplicate sounds are cyclable letters kinda like the 9key keyboards

All Letters and vowels map the keys nicely with the exception of the w key which is assigned to "aleph", persian doesn't have a w sound and I didn't know where else to put ا and آ

Some letters are repeated because of their dual purpose of consonant and vowel like و ی ه

Numbers, symbols and all those stuff are all combined from default Persian (Farsi) and standard Persian (Farsi), only "?" is missing from the keyboard which is useless for a right to left script and making it cyclable would make spamming it annoying

Hope this'd be useful for you
