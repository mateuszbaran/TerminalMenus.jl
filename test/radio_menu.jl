# Check to make sure types are imported properly
@test RadioMenu <: TerminalMenus.AbstractMenu

# Constructor
@test RadioMenu(["one", "two", "three"]).pagesize == 3
@test RadioMenu(string.(1:30), pagesize=-1).pagesize == 30
@test RadioMenu(string.(1:4), pagesize=10).pagesize == 4
@test RadioMenu(string.(1:100)).pagesize == 10

radio_menu = RadioMenu(string.(1:20))
@test TerminalMenus.options(radio_menu) == string.(1:20)
radio_menu.selected = 2
TerminalMenus.cancel(radio_menu)
@test radio_menu.selected == -1
@test TerminalMenus.header(radio_menu) == ""

# Output
TerminalMenus.config() # Use default chars
CONFIG = TerminalMenus.CONFIG

# Test writeLine function
term_width = 100
radio_menu = RadioMenu(string.(1:10))
buf = IOBuffer()
TerminalMenus.writeLine(buf, radio_menu, 1, true, term_width)
@test String(take!(buf)) == string(CONFIG[:cursor], " 1")
TerminalMenus.config(cursor='+')
TerminalMenus.writeLine(buf, radio_menu, 1, true, term_width)
@test String(take!(buf)) == "+ 1"
TerminalMenus.config(charset=:unicode)
TerminalMenus.writeLine(buf, radio_menu, 1, true, term_width)
@test String(take!(buf)) == string(CONFIG[:cursor], " 1")

# Test using STDIN
radio_menu = RadioMenu(string.(1:10))
@test simulateInput(3, radio_menu, :down, :down, :enter)
radio_menu = RadioMenu(["single option"])
@test simulateInput(1, radio_menu, :up, :up, :down, :up, :enter)
radio_menu = RadioMenu(string.(1:3), pagesize=1)
@test simulateInput(3, radio_menu, :down, :down, :down, :down, :enter)
