hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
  end)
  hs.alert.show("🔨 Reloaded 🥄")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "D", function()
  hs.eventtap.keyStrokes(os.date("!%Y-%m-%dt%TZ")) end)

hs.hotkey.bind({"cmd", "shift"}, "\\", function()
  hs.eventtap.keyStrokes(os.date("!%Y-%m-%d")) end)

hs.hotkey.bind({"cmd", "alt"}, "V", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

hs.hotkey.bind({"cmd", "alt"}, "P", function()
    hs.task.new("/opt/homebrew/bin/pwqgen", function(st, stdout, stderr)
      hs.alert.show("Password Generated: " .. stdout)
      hs.pasteboard.setContents(stdout)
    end, {"random=80"}):start()
  end)

hs.hotkey.bind({"cmd", "alt"}, "Z", function()
    hs.application.launchOrFocus('zoom.us')
  end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Z", function()
    hs.application'zoom':selectMenuItem('Keep on Top')
    hs.alert('Zoom on Top')
  end)

hs.hotkey.bind({"cmd", "alt"}, "E", function()
  hs.pasteboard.setContents("pol.llovet@gmail.com")
  hs.alert.show("📧")
end)


hs.hotkey.bind({"cmd"}, "=", function()
  hs.eventtap.keyStrokes("-")
end)

hs.hotkey.bind({"cmd", "shift"}, "=", function()
  hs.eventtap.keyStrokes("_")
end)

