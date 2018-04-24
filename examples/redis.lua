local lrc = require "lredis.cqueues"
local r = lrc.connect_tcp()

r:ping()
